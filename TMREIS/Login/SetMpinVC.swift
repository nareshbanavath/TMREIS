//
//  SetMpinVC.swift
//  TMREIS
//
//  Created by deep chandan on 27/04/21.
//

import UIKit

class SetMpinVC: UIViewController {
    @IBOutlet weak var setMpinView: UIView!
    @IBOutlet weak var conformMpinView: UIView!
    
    lazy var mpinStackView : OTPStackView = {
        let txt = OTPStackView()
        txt.isSecureTextEntry = true
        txt.numberOfFields = 4
        return txt
    }()
    var confirmMpinStackView = OTPStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.navigationItem.hidesBackButton = true

        self.setupMPINTextfields()
    }
 
 
    func setupMPINTextfields()
    {
        setMpinView.backgroundColor  = .clear
        conformMpinView.backgroundColor = .clear
        setMpinView.addSubview(mpinStackView)
        mpinStackView.heightAnchor.constraint(equalTo: setMpinView.heightAnchor).isActive = true
        mpinStackView.centerXAnchor.constraint(equalTo: setMpinView.centerXAnchor).isActive = true
        mpinStackView.centerYAnchor.constraint(equalTo: setMpinView.centerYAnchor).isActive = true
        
        conformMpinView.addSubview(confirmMpinStackView)
        confirmMpinStackView.heightAnchor.constraint(equalTo: conformMpinView.heightAnchor).isActive = true
        confirmMpinStackView.centerXAnchor.constraint(equalTo: conformMpinView.centerXAnchor).isActive = true
        confirmMpinStackView.centerYAnchor.constraint(equalTo: conformMpinView.centerYAnchor).isActive = true
    }
    @IBAction func proceddBtnClick(_ sender: Any) {
        
            if isDataValid(){
                self.GenerateMpinWS()
            }
    }
    func GenerateMpinWS() {
    guard Reachability.isConnectedToNetwork() else {self.showAlert(message: noInternet);return}
      NetworkRequest.makeRequest(type:Mpinmodel.self, urlRequest: Router.genearteMpin(userName: UserDefaultVars.loginData?.data?.userName ?? "", mpin: mpinStackView.getOTP()), completion: { [weak self](result) in
            switch result{
            case  .success(let data):
               // self?.model = data
                let statusMsg = data.statusMessage
                // let mpin = data.mPin
                //  debugPrint(self?.model)
                //  debugPrint(data)
                if statusMsg == "Your MPin set/generated successfully" || data.statusCode == 200 {
                    
                    let vc = self?.storyboard?.instantiateViewController(withIdentifier: "UpdateMpinVC") as! UpdateMpinVC
                    self?.navigationController?.pushViewController(vc, animated: true)

                }  else if data.statusCode == 401 {
                    self?.showFailureAlert(message: "Session Expired , Please login again!",
                    okCompletion: {
//                        // resetDefaults()
//                        let vc = storyboards.Main.instance.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
//                        let navCOntroller = UINavigationController(rootViewController: vc)
//                        navCOntroller.navigationBar.isHidden = true
//                        self?.view.window?.rootViewController = navCOntroller
//                        self?.view.window?.becomeKey()
                    })
                }
                    else {
                    self?.showFailureAlert(message: data.statusMessage ?? serverNotResponding)
                }
            case .failure(let err):
                debugPrint(err)
                self?.showFailureAlert(message: serverNotResponding)
            }

        })

    }
    func isDataValid()->Bool {
      guard mpinStackView.getOTP().count >= 4 else { self.showAlert(message:"Please enter 4-Digit MPIN");return false}
      guard confirmMpinStackView.getOTP().count >= 4 else {self.showAlert(message:"Please Confirm 4 digit MPIN");return false
        }
      guard mpinStackView.getOTP() == confirmMpinStackView.getOTP() else
        {
            self.showAlert(message: "MPIN and Confirm MPIN not matched, Please Try again")
            return false
        }
        
        return true
    }
    
}
struct Mpinmodel : Codable {
    let employeeinfo : String?
    let mPin : String?
    let statusMessage : String?
    let statusCode : Int?

    enum CodingKeys: String, CodingKey {

        case employeeinfo = "employeeinfo"
        case mPin = "mPin"
        case statusMessage = "statusMessage"
        case statusCode = "statusCode"
    }
}
