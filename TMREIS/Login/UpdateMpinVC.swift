//
//  UpdateMpinVC.swift
//  TMREIS
//
//  Created by deep chandan on 27/04/21.
//

import UIKit

class UpdateMpinVC: UIViewController {
    @IBOutlet weak var nameLb: UILabel!
    @IBOutlet weak var mpinView: UIView!
    let mpinstackView = OTPStackView()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        setupMpinStackView()
     
    }
    func setupMpinStackView()
    {
        mpinView.backgroundColor = .clear
        mpinView.addSubview(mpinstackView)
        mpinstackView.heightAnchor.constraint(equalTo: mpinView.heightAnchor).isActive = true
        mpinstackView.centerXAnchor.constraint(equalTo: mpinView.centerXAnchor).isActive = true
        mpinstackView.centerYAnchor.constraint(equalTo: mpinView.centerYAnchor).isActive = true
    }

    @IBAction func notuBtnClick(_ sender: Any) {
        let  vc = storyboards.Login.instance.instantiateViewController(withIdentifier: "SigninSwipeupVC") as! SigninSwipeupVC
        self.navigationController?.pushViewController(vc, animated: true)
        resetDefaults()
    }
    @IBAction func forgotmpinClick(_ sender: Any) {
       // self.forgotMpinWS()
    }
    
    @IBAction func mpinValidateBtnClick(_ sender: Any) {
        self.validateMpinWS()
      //  debugPrint(UserDefaultVars.isCitizen)
//
//        if UserDefaultVars.isCitizen == true {
//            self.validateMpinWS()
////            let vc = storyboards.Dashboard.instance.instantiateViewController(withIdentifier: "CitizenDashboardVC") as! CitizenDashboardVC
////            self.navigationController?.pushViewController(vc, animated: true)
//    } else {
//
//        guard let vc = UIStoryboard(name: "Officer", bundle: nil).instantiateInitialViewController()else{return}
//
//        self.view.window?.rootViewController = vc
//        self.view.window?.becomeKey()
//        self.view.window?.makeKeyAndVisible()
//    }
    }
    func validateMpinWS(){
       let mpin = self.mpinstackView.getOTP().AESEncryption()
       guard Reachability.isConnectedToNetwork() else {self.showAlert(message: noInternet);return}
      let userID = String(UserDefaultVars.loginData?.data?.userID ?? 0)
      NetworkRequest.makeRequest(type: mpinValidation.self, urlRequest: Router.validateMpin(userId: userID , mpin: mpin ?? "", fcmToken: UserDefaultVars.loginData?.data?.fcmtoken ?? "")) { [weak self](result) in

            switch result{
            case .success(let data):
               // self?.mpinmodel = data
                debugPrint(data)
              UserDefaultVars.RolesArray = data.data.role
                 let statusCode = data.statusCode
                switch statusCode {
                case 200:
                    UserDefaultVars.RolesArray = data.data.role
                    if UserDefaultVars.userType == "C" { // Citezen
                        let vc = storyboards.Dashboard.instance.instantiateViewController(withIdentifier: "CitizenDashboardVC") as! CitizenDashboardVC
                        self?.navigationController?.pushViewController(vc, animated: true)
                } else {
                    guard let vc = UIStoryboard(name: "Officer", bundle: nil).instantiateInitialViewController()else{return}
                    self?.view.window?.rootViewController = vc
                    self?.view.window?.becomeKey()
                    self?.view.window?.makeKeyAndVisible()
                }
                case 201:
                    //  debugPrint("worklog not submitted")
                    self?.showAlert(message: data.statusMessage )
                case 401:
                    self?.showAlert(message: "Session Expired , Please login again!", completion: {
                        let vc = storyboards.Main.instance.instantiateViewController(withIdentifier: "SigninSwipeupVC") as! SigninSwipeupVC
                        let navCOntroller = UINavigationController(rootViewController: vc)
                        navCOntroller.navigationBar.isHidden = true
                        self?.view.window?.rootViewController = navCOntroller
                        self?.view.window?.becomeKey()
                         self?.view.window?.makeKeyAndVisible()
                    })

                default:
                    debugPrint("default")
                    self?.showAlert(message: serverNotResponding)

                }
            // debugPrint(attendanceInfo)
            case .failure(let _err):
                debugPrint(_err)
                self?.showAlert(message: serverNotResponding)
            }
        }
    }
//    func forgotMpinWS(){
 //   guard Reachability.isConnectedToNetwork() else {self.showFailureAlert(message: noInternet);return}
//        NetworkRequest.makeRequest(type:Mpinmodel.self, urlRequest: Router.forgotMpin(userName: UserDefaultVars.username, mpin: UserDefaultVars.mpin), completion: { [weak self](result) in
//            switch result{
//            case  .success(let data):
//                self?.model = data
//                let statusCode = data.statusCode
//                debugPrint(data)
//                if statusCode == 200 {
//                    let refreshAlert = UIAlertController(title: "Virtuo", message:data.statusMessage ?? "", preferredStyle: UIAlertController.Style.alert)
//
//                    refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
//                      let vc = self?.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
//                        self?.navigationController?.pushViewController(vc, animated: true)
//                        
//                    }))
//                 self?.present(refreshAlert, animated: true, completion: nil)
//                 
//
//                } else if data.statusCode == 401 {
//                    self?.showFailureAlert(message: "Session Expired , Please login again!",
//                    okCompletion: {
//                        // resetDefaults()
//                        let vc = storyboards.Main.instance.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
//                        let navCOntroller = UINavigationController(rootViewController: vc)
//                        navCOntroller.navigationBar.isHidden = true
//                        self?.view.window?.rootViewController = navCOntroller
//                        self?.view.window?.becomeKey()
//                    })
//                }else {
//                    self?.showFailureAlert(message:data.statusMessage ?? serverNotResponding)
//              }
//            case .failure(let _err):
//                 debugPrint(_err)
//                self?.showFailureAlert(message: "server not responding")
//            }
//
//        })
//    }

}
struct mpinValidation : Codable {
    let success: Bool
       let statusMessage: String
       let statusCode: Int
       let data: DataClass
       let paginated: Bool

       enum CodingKeys: String, CodingKey {
           case success
           case statusMessage = "status_Message"
           case statusCode = "status_Code"
           case data, paginated
       }
    // MARK: - DataClass
    struct DataClass: Codable {
        let role: [String]
    }
   }

 
