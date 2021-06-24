//
//  CitizenVC.swift
//  TMREIS
//
//  Created by deep chandan on 27/04/21.
//

import UIKit
import PKHUD
import Alamofire
class CitizenVC: UIViewController  , UITextFieldDelegate {
    
    var deviceIdIs:String?
    var getIdProofModel:LoginStruct?
    @IBOutlet weak var mobileNumberTF: UITextField!
    {
        didSet
        {
            mobileNumberTF.keyboardType = .phonePad
            mobileNumberTF.delegate = self
        }
    }
    @IBOutlet weak var passwordTF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
    }
    
    
    
    @IBAction func loginbtnClick(_ sender: Any) {
        UserDefaultVars.userType = "C"
        if loginValidationswithmobileNo(){
            self.citizenLogin()
        }
    }
    func citizenLogin(){
        //  UserDefaults.standard.set(mo.text, forKey:"mobileNumber")
        let username = mobileNumberTF.text?.AESEncryption()
        guard Reachability.isConnectedToNetwork() else {self.showAlert(message: noInternet);return}
        NetworkRequest.makeRequest(type: LoginStruct.self, urlRequest: Router.loginWithMobileNo(usertype: "C", mobileNumber: username ?? "", deviceId: UserDefaultVars.deviceID ?? "", IMEI: UserDefaultVars.deviceID ?? "",fcmToken: UserDefaultVars.loginData?.data?.fcmtoken ?? "" , deviceType: "IOS"), completion: { [weak self](result) in
            switch result{
            case  .success(let data):
                // resetDefaults()
                let statuscode = data.statusCode
                switch statuscode
                {
                case 200 :
                    UserDefaultVars.loginData = data
                    if data.data?.mpin == "00" //mpin not set
                    {
                        let vc = self?.storyboard?.instantiateViewController(withIdentifier: "OtpVC") as! OtpVC
                        vc.otp = data.data?.otpMobile
                        vc.mobileNumber = data.data?.userName
                        self?.navigationController?.pushViewController(vc, animated: true)
                    }
                    else //mpin set
                    {
                        let vc = self?.storyboard?.instantiateViewController(withIdentifier: "UpdateMpinVC") as! UpdateMpinVC
                        self?.navigationController?.pushViewController(vc, animated: true)
                        
                    }
                case 201: //error message
                    self?.showAlert(message: data.statusMessage ?? serverNotResponding )
                    
                default:
                    self?.showAlert(message: data.statusMessage ?? serverNotResponding
                    )
                }
                
            case .failure(let err):
                debugPrint(err)
                self?.showAlert(message: serverNotResponding)
                
            }
            
        })
        
        
    }
    func loginValidationswithmobileNo()->Bool {
        if  mobileNumberTF.text == ""{
            self.showAlert(message: "Please enter mobile number")
            
            return false
        }
        else if mobileNumberTF.text?.count != 10
        {
            self.showAlert(message: "Please enter valid mobile number")
            return false
        }
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



