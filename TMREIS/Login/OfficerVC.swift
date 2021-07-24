//
//  OfficerVC.swift
//  TMREIS
//
//  Created by deep chandan on 27/04/21.
//

import UIKit

class OfficerVC: UIViewController , UITextFieldDelegate{
  @IBOutlet weak var mobileNumberTF: UITextField!
  {
    didSet{
        mobileNumberTF.keyboardType = .phonePad
        mobileNumberTF.delegate = self
    }
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.navigationController?.isNavigationBarHidden = true

  }
  
  @IBAction func loginbtnClick(_ sender: Any) {
    if loginValidationswithmobileNo(){
      UserDefaultVars.userType = "O"
      self.OfficerLoginWS()
    }
  }
  
  func OfficerLoginWS(){
    let username = mobileNumberTF.text?.AESEncryption()
    guard Reachability.isConnectedToNetwork() else {self.showAlert(message: noInternet);return}
    NetworkRequest.makeRequest(type: LoginStruct.self, urlRequest: Router.loginWithMobileNo(usertype : "O",mobileNumber: username ?? "", deviceId: UserDefaultVars.deviceID ?? "", IMEI: UserDefaultVars.deviceID ?? "",fcmToken: UserDefaultVars.fcmToken , deviceType: "IOS"), completion: { [weak self](result) in
      switch result{
      case  .success(let data):
        // resetDefaults()
       // print(data)
        let statuscode = data.statusCode
        switch statuscode
        {
        case 200 :
          UserDefaultVars.loginData = data
            print(data)
          if data.data?.mpin == "00" //mpin not set
          {
            let vc = self?.storyboard?.instantiateViewController(withIdentifier: "OtpVC") as! OtpVC
            
            vc.otp = data.data?.otpMobile
            vc.mobileNumber = self?.mobileNumberTF.text!
            // vc.tag = 2
            self?.navigationController?.pushViewController(vc, animated: true)
          }
          else //mpin set
          {
            let vc = self?.storyboard?.instantiateViewController(withIdentifier: "UpdateMpinVC") as! UpdateMpinVC
            self?.navigationController?.pushViewController(vc, animated: true)
            
          }
        default:
          self?.showAlert(message: data.statusMessage ?? serverNotResponding )
        }
        
      case .failure(let err):
        debugPrint(err)
        self?.showAlert(message: serverNotResponding)
        
      }
      
    })
    
    
  }
  func loginValidationswithmobileNo()->Bool {
    
    guard mobileNumberTF.text?.trim() != "" else {self.showAlert(message: "Please enter mobile number");return false}
    
    guard mobileNumberTF.text?.trim().count == 10 else {self.showAlert(message: "Please enter valid mobile number");return false}
    return true
  }
    
  //MARK:- TextField Delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 10
        let currentString: NSString = (textField.text ?? "") as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
        
    }
    
}


