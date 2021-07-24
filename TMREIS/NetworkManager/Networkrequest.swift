////
////  Networkrequest.swift
////  TMREIS
////
////  Created by deep chandan on 27/04/21.
////
//
import Foundation
import Alamofire
import PKHUD
enum NetworkError: Error {
    case domainError(_ msg : Error)
    case decodingError(_ msg : Error)
}
class NetworkRequest
{
    class func makeRequest<T : Decodable>(type : T.Type , urlRequest : Router , completion : @escaping (Swift.Result<T , NetworkError>)->())
    {
        print("url :- \(urlRequest.urlRequest?.url?.absoluteString)")
        print("headers :- \(String(describing: urlRequest.urlRequest?.allHTTPHeaderFields))")
        
//        print("Url:- ",urlRequest.urlRequest?.url?.absoluteString as Any)
        if urlRequest.method == .post
        {
            if let data = urlRequest.urlRequest?.httpBody {
                if let jsondata = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
                {
                   // print("parameters :- ", jsondata)
                }
            }
        }


//        let configuration = URLSessionConfiguration.default
//        configuration.timeoutIntervalForRequest = urlRequestTimeOutInterval
//        configuration.timeoutIntervalForResource = urlRequestTimeOutInterval
//        let alamoFireManager = Alamofire.SessionManager(configuration: configuration) // not in this line
        //guard Reachability.isConnectedToNetwork() else { self.showAlert(message: NoInternet) ; return }
        DispatchQueue.main.async {
            self.showLoading(text: "Loading")
        }
        AF.request(urlRequest).responseJSON { (response) in
            DispatchQueue.main.async {
                self.hideLoading()
            }
           // print(response)
          //  print(try! JSONSerialization.jsonObject(with: response.data!, options: .allowFragments))
            guard let data = response.data, response.error == nil else {

                if let error = response.error as NSError? {
                print(error)
                    DispatchQueue.main.async {
                        self.hideLoading()
                    }
                     completion(.failure(.domainError(error)))
                }
                return
            }

            do {
                let modelData = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                     self.hideLoading()
                }
                completion(.success(modelData))
            } catch let err{
                DispatchQueue.main.async {
                    self.hideLoading()
                }
                completion(.failure(.decodingError(err)))
            }
        }
    }
    class func makeRequestArray<T : Decodable>(type : T.Type , urlRequest : Router , completion : @escaping (Swift.Result<[T] , NetworkError>)->())
    {
        DispatchQueue.main.async {
            self.showLoading(text: "Loading")
        }
        AF.request(urlRequest).responseJSON { (response) in
            guard let data = response.data, response.error == nil else {
                if let error = response.error as NSError?, error.domain == NSURLErrorDomain {
                    DispatchQueue.main.async {
                        self.hideLoading()
                    }
                    completion(.failure(.domainError(error)))
                }
                return
            }
            do {
                let modelData = try JSONDecoder().decode([T].self, from: data)
                DispatchQueue.main.async {
                    self.hideLoading()
                }
                completion(.success(modelData))
            } catch let err{
                DispatchQueue.main.async {
                    self.hideLoading()
                }
                completion(.failure(.decodingError(err)))
            }

        }

    }


    class func showLoading(text: String)
    {




      //  PKHUD.sharedHUD.contentView = PKHUDTextView(text: text)
    //    PKHUD.sharedHUD.contentView = PKHUDSquareBaseView(image: nil, title: "Loading..", subtitle: nil)
      PKHUD.sharedHUD.contentView = PKHUDProgressView(title: nil, subtitle: nil)
       // PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.dimsBackground = true
        PKHUD.sharedHUD.show()

    }
    class func hideLoading() {
        PKHUD.sharedHUD.hide()
    }
//    class func showAlert(message: String)
//    {
//        let alert = UIAlertController(title: "Red Cross", message:message, preferredStyle: UIAlertController.Style.alert)
//        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
//        present(alert, animated: true, completion: nil)
//
//    }
}

//enum NetworkError1: Error {
//    case domainError(_ msg : Error)
//    case decodingError(_ msg : Error)
//}
//enum HTTPMethod : String
//{
//    case get = "GET"
//    case post = "POST"
//}
//class NetworkManager
//{
//    class func makeRequest<T : Codable>(type : T.Type , method : HTTPMethod,parameters : [String : Any]?, url : URL ,encoding : JSONEncoding, completion : @escaping (Swift.Result<T , NetworkError1>)->())
//    {
//        var urlRequest = URLRequest(url: url)
//        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        switch method
//        {
//        case .get :
//            print("get")
//            urlRequest.httpMethod = "GET"
//        case .post :
//            if let parameters = parameters
//            {
//                if let jsondata = try? JSONSerialization.data(withJSONObject: parameters, options: .fragmentsAllowed)
//                {
//                    urlRequest.httpMethod = "POST"
//                    urlRequest.httpBody = jsondata
//                   // urlRequest.addValue(UserDefaultVars.token!, forHTTPHeaderField:"Auth_token")
//                    print(urlRequest)
//                }
//            }
//            print("post method")
//        }
//        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
//            guard let data = data, error == nil else {
//                if let error = error as NSError?, error.domain == NSURLErrorDomain {
//                                        completion(.failure(.domainError(error)))
//                }
//                return
//            }
//            do {
//                let modelData = try JSONDecoder().decode(T.self, from: data)
//                completion(.success(modelData))
//            } catch let err{
//                completion(.failure(.decodingError(err)))
//            }
//        }
//        task.resume()
//    }
//}
