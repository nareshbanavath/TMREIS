//
//  Router.swift
//  TMREIS
//
//  Created by deep chandan on 27/04/21.
//

import Foundation
import Alamofire
import UIKit


let PROD = 1
let STAG = 2
let DEMO = 3
let DEV  = 4
let LOC  = 5

var ENV = 3


let urlRequestTimeOutInterval = 30.0
let urlResponseTimeOutInterval = 10.0

var baseUrl = baseUrl1()


func baseUrl1() -> String {
    
    if ENV == PROD { // Production
        return ""
    } else if ENV == STAG { // staging
        return   ""
    } else if ENV == DEMO { // Testing
        return "http://uat9.cgg.gov.in/tmreis/api/web/"
    } else if ENV == DEV { // Development
        return ""
    } else { // Local Server
        return "http://10.2.24.230:8080/"
    }
}
func getVersion() -> String
{
    if ENV == PROD { // Production
        return "Version:- \(Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String)"
    } else if ENV == STAG { // UAT
        return   ""
    } else if ENV == DEMO { // Testing
        return "Version:- Uat \(Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String)"
    } else if ENV == DEV { // Development
        return ""
    } else { // Local Server
        return ""
    }
}

enum Router:URLRequestConvertible{
  //  case login(username : String , password : String, deviceId: String, IMEI: String,fcmToken: String ,deviceType:String)
  case versionCheck
  case genearteMpin(userName: String, mpin:String)
  case loginWithMobileNo(usertype : String ,mobileNumber : String,deviceId: String, IMEI: String, fcmToken: String,deviceType: String)
  case validateMpin(userId:String, mpin:String , fcmToken:String)
  case getContactDetails(schoolTypeId : String)
  case getDesignationMasterDetails(schoolTypeId : String)
  case getOfficeLocationDetails
  case addEmpContact(parameters : Parameters)
  case updateEmpContact(parameters : Parameters)
  case deleteEmpContact(empId : String , userId : String)
  case getNotifications(strDate : String , endDate : String)
  case sendNotification(parameters : Parameters)
  // case genearteMpin(userName: String, mpin:String)
  //  case forgotMpin(userName:String, mpin:String)
  
  
  var method:HTTPMethod{
    switch self {
    case .addEmpContact , .updateEmpContact , .deleteEmpContact ,.sendNotification:
        return .post
    //loginWithUserName
    //        case .login :
    //            return .post
    //loginWithMobileNumber
    case .loginWithMobileNo , .genearteMpin , .getDesignationMasterDetails , .getOfficeLocationDetails , .getNotifications:
      return .get
    //GenerateMpin
    //        case .genearteMpin:
    //            return .get
    //        // forgotempin
    //        case .forgotMpin:
    //            return .get
    //version check
    case .versionCheck:
      return .get
    case .validateMpin:
      return .post
    case .getContactDetails:
      return .get
    }
  }
    var path:String {
        switch self {
        case .sendNotification:
            return "sendingNotification"
        case .getNotifications:
            return "getNotificationDetails"
        case .addEmpContact:
            return "addEmpContact"
        case .updateEmpContact:
            return "updateEmpContact"
        case .deleteEmpContact:
            return "deleteEmpContact"
        case .getDesignationMasterDetails:
            return "getDesignationMasterDetails"
        case .getOfficeLocationDetails:
            return "getOfficeLocationDetails"
        case .genearteMpin:
            return "updatingMpin/webApp"
        case .loginWithMobileNo:
            return "userVerification"
        // generatempin
        //        case .genearteMpin:
        //            return "updatingMpin/webApp"
        //        // forgotempin
        //        case .forgotMpin:
        //            return "forgotMpin/webApp"
        case .versionCheck:
            return "api/web/getCurrentAppVersion"
        case .validateMpin:
            return "mpinVerification"
        case .getContactDetails:
            return "getStaffContactDetails"
        }
    }
  func asURLRequest() throws -> URLRequest {
    let url = try baseUrl.asURL()
    var urlRequest = URLRequest(url: url.appendingPathComponent(path))
    urlRequest.httpMethod = method.rawValue
    urlRequest.timeoutInterval = TimeInterval(urlRequestTimeOutInterval)
    switch self {
    //Login
    //        case .login (let username , let password , let deviceId , let IMEI,let fcmToken, let deviceType):
    //            let pathString = path
    //            urlRequest = URLRequest(url: url.appendingPathComponent(pathString))
    //            urlRequest.setValue(username, forHTTPHeaderField: "userName")
    //            urlRequest.setValue(password, forHTTPHeaderField: "password")
    //            urlRequest.setValue(deviceId, forHTTPHeaderField: "deviceId")
    //            urlRequest.setValue(IMEI, forHTTPHeaderField: "IMEI")
    //            urlRequest.setValue(fcmToken, forHTTPHeaderField: "fcmToken")
    //            urlRequest.setValue(deviceType, forHTTPHeaderField: "deviceType")
    //            urlRequest.httpMethod = method.rawValue
    //            urlRequest = try JSONEncoding.default.encode(urlRequest)
    //            debugPrint(urlRequest)
    //loginWithMobileNumber
    case .getNotifications(let strDate, let endDate):
        let pathString = path
        urlRequest = URLRequest(url: url.appendingPathComponent(pathString))
        guard let token = UserDefaultVars.loginData?.data?.token else {fatalError("token not availabel")}
       //debugPrint("token :- \(token)")
        urlRequest.setValue(token, forHTTPHeaderField:"Auth_Token")
        urlRequest.setValue(strDate, forHTTPHeaderField: "startDate")
        urlRequest.setValue(endDate, forHTTPHeaderField: "endDate")
        
        guard let userType = UserDefaultVars.loginData?.data?.userType , let empId = UserDefaultVars.loginData?.data?.empID else {fatalError()}
        urlRequest.setValue(userType, forHTTPHeaderField: "userType")
        urlRequest.setValue(String(empId), forHTTPHeaderField: "empId")
        
        urlRequest.httpMethod = method.rawValue
        urlRequest = try JSONEncoding.default.encode(urlRequest)
    case .genearteMpin(let userName,let mpin):
        let pathString = path
        urlRequest = URLRequest(url: url.appendingPathComponent(pathString))
        guard let token = UserDefaultVars.loginData?.data?.token else {fatalError("token not availabel")}
       // debugPrint("token :- \(token)")
        urlRequest.setValue(token, forHTTPHeaderField:"Auth_Token")
        urlRequest.setValue(userName, forHTTPHeaderField: "userName")
        urlRequest.setValue(mpin, forHTTPHeaderField: "mpin")
        urlRequest.httpMethod = method.rawValue
        urlRequest = try JSONEncoding.default.encode(urlRequest)
    case .loginWithMobileNo (let userType,let mobileNumber ,  let deviceId , let IMEI,let fcmToken, let deviceType):
      let pathString = path
      urlRequest = URLRequest(url: url.appendingPathComponent(pathString))
      urlRequest.setValue(userType, forHTTPHeaderField: "usertype")
      urlRequest.setValue(mobileNumber, forHTTPHeaderField: "mobileNumber")
      urlRequest.setValue(deviceId, forHTTPHeaderField: "deviceId")
      urlRequest.setValue(IMEI, forHTTPHeaderField: "IMEI")
      urlRequest.setValue(fcmToken, forHTTPHeaderField: "fcmToken")
      urlRequest.setValue(deviceType, forHTTPHeaderField: "deviceType")
      urlRequest.httpMethod = method.rawValue
      urlRequest = try JSONEncoding.default.encode(urlRequest)
      debugPrint(urlRequest)
    case .validateMpin(let userId, let mpin, let fcmToken) :
      let pathString = path
      urlRequest = URLRequest(url: url.appendingPathComponent(pathString))
      urlRequest.httpMethod = method.rawValue
      guard let token = UserDefaultVars.loginData?.data?.token else {fatalError("token not availabel")}
      debugPrint("token :- \(token)")
      urlRequest.setValue(token, forHTTPHeaderField:"Auth_Token")
      urlRequest.setValue(userId, forHTTPHeaderField:"userId")
      urlRequest.setValue(mpin, forHTTPHeaderField:"mpin")
      urlRequest.setValue(fcmToken, forHTTPHeaderField: "fcmToken")
      urlRequest.setValue("IOS", forHTTPHeaderField: "deviceType")
      urlRequest = try JSONEncoding.default.encode(urlRequest)
     // debugPrint(urlRequest)
    //        // forgotempin
    //        case .forgotMpin(let userName,let mpin):
    //            let pathString = path
    //            urlRequest = URLRequest(url: url.appendingPathComponent(pathString))
    //            urlRequest.setValue(userName, forHTTPHeaderField: "userName")
    //            urlRequest.setValue(mpin, forHTTPHeaderField: "mpin")
    //            urlRequest.httpMethod = method.rawValue
    //            urlRequest = try JSONEncoding.default.encode(urlRequest)
    //           // debugPrint(urlRequest)
    
    case .versionCheck:
      let pathString = path
      urlRequest = URLRequest(url: url.appendingPathComponent(pathString))
      urlRequest.httpMethod = method.rawValue
      urlRequest = try JSONEncoding.default.encode(urlRequest)
      
    //Officer
    case .getContactDetails(let schoolTypeId):
      let pathString = path
      urlRequest = URLRequest(url: url.appendingPathComponent(pathString))
      urlRequest.httpMethod = method.rawValue
      guard let token = UserDefaultVars.loginData?.data?.token else {fatalError("token not availabel")}
     // debugPrint("token :- \(token)")
      urlRequest.setValue(token, forHTTPHeaderField:"Auth_Token")
      urlRequest.setValue(schoolTypeId, forHTTPHeaderField:"schoolTypeId")
      urlRequest = try JSONEncoding.default.encode(urlRequest)
    case .getOfficeLocationDetails:
      let pathString = path
      urlRequest = URLRequest(url: url.appendingPathComponent(pathString))
      urlRequest.httpMethod = method.rawValue
      guard let token = UserDefaultVars.loginData?.data?.token else {fatalError("token not availabel")}
     // debugPrint("token :- \(token)")
      urlRequest.setValue(token, forHTTPHeaderField:"Auth_Token")
      urlRequest = try JSONEncoding.default.encode(urlRequest)
        
    case .getDesignationMasterDetails(let schoolTypeId):
      let pathString = path
      urlRequest = URLRequest(url: url.appendingPathComponent(pathString))
      urlRequest.httpMethod = method.rawValue
      guard let token = UserDefaultVars.loginData?.data?.token else {fatalError("token not availabel")}
     // debugPrint("token :- \(token)")
      urlRequest.setValue(token, forHTTPHeaderField:"Auth_Token")
        urlRequest.setValue(schoolTypeId, forHTTPHeaderField:"schoolTypeId")
      urlRequest = try JSONEncoding.default.encode(urlRequest)
        
        
    case .addEmpContact(let parameters) , .updateEmpContact(let parameters) ,.sendNotification(let parameters):
        let pathString = path
        urlRequest = URLRequest(url: url.appendingPathComponent(pathString))
        urlRequest.httpMethod = method.rawValue
        guard let token = UserDefaultVars.loginData?.data?.token else {fatalError("token not availabel")}
        urlRequest.setValue(token, forHTTPHeaderField:"Auth_Token")
        urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
//    case .updateEmpContact(let parameters):
//        let pathString = path
//        urlRequest = URLRequest(url: url.appendingPathComponent(pathString))
//        urlRequest.httpMethod = method.rawValue
//        guard let token = UserDefaultVars.loginData?.data?.token else {fatalError("token not availabel")}
//        urlRequest.setValue(token, forHTTPHeaderField:"Auth_Token")
//        urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
    case .deleteEmpContact(let empId, let userId):
      let pathString = path
      urlRequest = URLRequest(url: url.appendingPathComponent(pathString))
      urlRequest.httpMethod = method.rawValue
      guard let token = UserDefaultVars.loginData?.data?.token else {fatalError("token not availabel")}
    //  debugPrint("token :- \(token)")
      urlRequest.setValue(token, forHTTPHeaderField:"Auth_Token")
      urlRequest.setValue(userId, forHTTPHeaderField:"userId")
      urlRequest.setValue(empId, forHTTPHeaderField:"empId")
      urlRequest.setValue(userId, forHTTPHeaderField: "userId")
      urlRequest = try JSONEncoding.default.encode(urlRequest)
    }
    return urlRequest
  }
}
extension URL {
    
    func appending(_ queryItem: String, value: String?) -> URL {
        
        guard var urlComponents = URLComponents(string: absoluteString) else { return absoluteURL }
        
        // Create array of existing query items
        var queryItems: [URLQueryItem] = urlComponents.queryItems ??  []
        
        // Create query item
        let queryItem = URLQueryItem(name: queryItem, value: value)
        
        // Append the new query item in the existing query items array
        queryItems.append(queryItem)
        
        // Append updated query items array in the url component object
        urlComponents.queryItems = queryItems
        
        // Returns the url from new url components
        return urlComponents.url!
    }
}

