//
//  SplashVC.swift
//  TMREIS
//
//  Created by Haritej on 01/05/21.
//

import UIKit

class SplashVC: UIViewController {
    
    @IBOutlet weak var neverShowContainerView: UIView!
    @IBOutlet weak var neverShowBottomAnchor: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //  debugPrint("helllo")
       // self.versionCheck()
        
        if UserDefaults.standard.value(forKey: "neverShowView") != nil
        {
            neverShowBottomAnchor.constant = 80
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
                self.navigateToSignInVC()
            }
           
        }
        else{
            neverShowBottomAnchor.constant = 0
        }
   
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    @IBAction func neverShowClicked(_ sender: UIButton) {
        UserDefaults.standard.setValue("neverShow", forKey: "neverShowView")
        navigateToSignInVC()
    }
    
    @IBAction func skipClicked(_ sender: UIButton) {
        navigateToSignInVC()
    }
    func navigateToSignInVC()
    {
        let vc = storyboards.Login.instance.instantiateViewController(withIdentifier: "SigninSwipeupVC") as! SigninSwipeupVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func versionCheck() {
    guard Reachability.isConnectedToNetwork() else {self.showAlert(message: noInternet);return}
    NetworkRequest.makeRequest(type: VersionCheckModel.self, urlRequest: Router.versionCheck, completion: { [weak self](result) in
        switch result{
        case  .success(let data):
           // self?.versionmodel = data
            let statusMsg = data.statusCode
            if statusMsg == 200 {
               // debugPrint(data)
                guard let serverVersion = data.data?.versionNo else {return}
                guard let lastUpdateddate = data.data?.lastupdatedDate else {return}
                UserDefaults.standard.set(serverVersion,forKey: "serverVersion")
                UserDefaults.standard.set(lastUpdateddate,forKey: "lastUpdateddate")
                let maxTimeCheck = data.data?.maxTimeCheck
                UserDefaults.standard.set(maxTimeCheck ?? " ", forKey: "max_time_chk")
              //  UserDefaultVars.maxTimeCheck = maxTimeCheck
                let localVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
                guard let floatLocValue = Float(localVersion) else {return}
                guard let floatServValue = Float(serverVersion.prefix(3)) else {return}
                debugPrint(floatServValue , floatLocValue)
                if floatLocValue > floatServValue || floatLocValue == floatServValue {
                if UserDefaults.standard.object(forKey: "mpin") != nil{
                       if UserDefaults.standard.object(forKey: "mpin") as! String == "00"
                       {
                           let  vc = UIStoryboard.init(name:"Login", bundle: Bundle.main).instantiateViewController(withIdentifier: "SigninSwipeupVC") as? SigninSwipeupVC
                           self?.navigationController?.pushViewController(vc!, animated: true)
                       }
                       else{
                        let vc = self?.storyboard?.instantiateViewController(withIdentifier: "UpdateMpinVC") as! UpdateMpinVC
                           //  vc.mpin = data.data?.mpin
                           self?.navigationController?.pushViewController(vc, animated: true)
                       }
                   }
                   else
                   {
                       let  vc = UIStoryboard.init(name:"Login", bundle: Bundle.main).instantiateViewController(withIdentifier: "SigninSwipeupVC") as? SigninSwipeupVC
                    self?.navigationController?.pushViewController(vc!, animated: true)
                   }
                }else{
                    self?.showAlert(message: "Please update the app to version " + (data.data?.versionNo ?? " "))
                    {
                        if let customAppURL = URL(string: "https://apps.apple.com/us/app/virtuo/id1528824793"){
                            if(UIApplication.shared.canOpenURL(customAppURL)){
                                UIApplication.shared.open(customAppURL, options: [:], completionHandler: nil)
                            }
                            else {
                                self?.showAlert(message: "Unable to open Appstore")
                            }
                        }
                    }
                }
            } else {
                self?.showAlert(message: data.statusMessage ?? serverNotResponding)
                
            }
        case .failure(let err):
            debugPrint(err)
            DispatchQueue.main.async {
                self?.showAlert(message: serverNotResponding)
                //code to be executed on main thread
            }
        }
    })
}
}
// MARK: - VersionCheckModel
struct VersionCheckModel: Codable {
    let success: Bool
    let statusMessage: String?
    
    let statusCode: Int
    let data: DataClass?
    let paginated: Bool

    enum CodingKeys: String, CodingKey {
        case success
        case statusMessage = "status_Message"
        case statusCode = "status_Code"
       
        case data, paginated
    }
}

// MARK: - DataClass
struct DataClass: Codable {
    let versionNo, lastupdatedDate, maxTimeCheck: String?

    enum CodingKeys: String, CodingKey {
        case versionNo = "version_no"
        case lastupdatedDate = "lastupdated_date"
        case maxTimeCheck = "max_time_chk"
    }
}


