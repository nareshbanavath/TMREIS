//
//  OtpVC.swift
//  TMREIS
//
//  Created by deep chandan on 27/04/21.
//

import UIKit

class OtpVC: UIViewController {

    @IBOutlet weak var otpTF: UITextField!
    @IBOutlet weak var mobilenoLb: UILabel!
    var otp:String?
    var mobileNumber:String?
    var model:LoginStruct?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.navigationItem.hidesBackButton = true
        mobilenoLb.text = "Enter 6 digit OTP sent to ******\(String(describing: self.mobileNumber!.suffix(4)))"
    }
    @IBAction func resendotpBtnClick(_ sender: Any) {
        self.LoginWSwithUserName()
    }
    @IBAction func submitBtnClick(_ sender: Any) {
//        let vc = storyboards.Login.instance.instantiateViewController(withIdentifier: "SetMpinVC") as! SetMpinVC
//        self.navigationController?.pushViewController(vc, animated: true)
        if self.otpTF.text?.count == 6
        {
            if(self.otp == otpTF.text){
                //debugPrint (otpstackView.getOTP())

                let vc = storyboards.Login.instance.instantiateViewController(withIdentifier: "SetMpinVC") as! SetMpinVC
                self.navigationController?.pushViewController(vc, animated: true)
            } else{
                self.showAlert(message: "Entered otp is wrong")
            }
        }else{
            self.showAlert(message: "Please Enter 6 digit otp")
        }
    }
    //MARK:- Service Calls
    func LoginWSwithUserName() {
       // debugPrint(UserDefaultVars.username , password)
        guard let mobileNumberIs = mobileNumber?.AESEncryption() else {return}

    guard Reachability.isConnectedToNetwork() else {self.showAlert(message: noInternet);return}
      NetworkRequest.makeRequest(type: LoginStruct.self, urlRequest: Router.loginWithMobileNo(usertype: "C", mobileNumber: mobileNumberIs , deviceId: UserDefaultVars.deviceID ?? "", IMEI: UserDefaultVars.deviceID ?? "", fcmToken: UserDefaultVars.loginData?.data?.fcmtoken ?? "", deviceType: "IOS"), completion: { [weak self](result) in
               switch result{
               case  .success(let data):
                   self?.model = data
                   let statuscode = data.statusCode
                let mpin = data.data?.mpin
                let userName = data.data?.userName
                   UserDefaults.standard.set(userName, forKey:"userName")
                   if statuscode == 200 && mpin == "00" {
                    self?.showAlert(message: data.statusMessage ?? serverNotResponding)
                    self?.otp = data.data?.otpMobile
                   } else{
                    self?.showAlert(message: data.statusMessage ?? serverNotResponding)
                }
               case .failure(let err):
                   debugPrint(err)
                   self?.showAlert(message: serverNotResponding)

               }

           })

       }
}
