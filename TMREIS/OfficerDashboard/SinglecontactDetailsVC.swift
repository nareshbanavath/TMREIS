//
//  SinglecontactDetailsVC.swift
//  TMREIS
//
//  Created by Haritej on 05/05/21.
//

import UIKit

class SinglecontactDetailsVC: UIViewController {
    
    //MARK:- Properties
    @IBOutlet weak var employeeName: UILabel!
    @IBOutlet weak var designationLb: UILabel!
    @IBOutlet weak var officeLb: UILabel!
    @IBOutlet weak var locationLb: UILabel!
    @IBOutlet weak var phoneNumberlb: UILabel!
    @IBOutlet weak var mailIdLb: UILabel!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    
    var contactDetails:ContactDetailsStruct.Contact?
    var editBtnCompletion : ((Bool)->())?
    //MARK:- LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        employeeName.text = contactDetails?.empName
        designationLb.text = contactDetails?.empDesignation
        officeLb.text = contactDetails?.schoolTypeName
        locationLb.text = contactDetails?.district
        phoneNumberlb.text  = contactDetails?.mobileNo
        mailIdLb.text = contactDetails?.emailID
        
        if UserDefaultVars.loginData?.data?.userType != "A" //Admin
        {
            deleteBtn.isHidden = true
            editBtn.isHidden = true
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func closeBtnClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func editBtnClicked(_ sender: UIButton) {
        dismiss(animated: true) {
            self.editBtnCompletion?(true)
        }
      
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UpdateProfileDetailsVC") as! UpdateProfileDetailsVC
//        vc.isCurrentUser = false
//        vc.contactDetail = contactDetails
//        let navVc = UINavigationController(rootViewController: vc)
//        self.view.window?.rootViewController = navVc
//        self.view.window?.becomeKey()
//        self.view.window?.makeKeyAndVisible()
        
    }
    
    @IBAction func deleteBtnClicked(_ sender: UIButton) {
        print(contactDetails?.empID , contactDetails?.userID)
        let empId = contactDetails?.empID ; let userId = contactDetails?.userID
        guard Reachability.isConnectedToNetwork() else {self.showAlert(message: noInternet);return}
        NetworkRequest.makeRequest(type: DeleteContactStruct.self, urlRequest: Router.deleteEmpContact(empId: empId ?? "", userId: userId ?? "")) { [weak self](result) in
            guard let self = self else {return}
            switch result
            {
            case .success(let data):
                guard data.statusCode == 200 else {self.showAlert(message: data.statusMessage ?? serverNotResponding);return}
                self.showAlert(message: data.statusMessage ?? "Status Message is nil") {
                    self.dismiss(animated: true, completion: nil)
                }
            case .failure(let err):
                self.showAlert(message: err.localizedDescription)
            }
        }
        
    }
    
    @IBAction func mailBtnClicked(_ sender: UIButton) {
    }
    
    @IBAction func callBtnClicked(_ sender: UIButton) {
        if let phoneNumber = contactDetails?.mobileNo
        {
            self.callToNumber(phoneNo: phoneNumber)
        }
    }
    
    @IBAction func smsBtnClicked(_ sender: UIButton) {
        if let phoneNumber = contactDetails?.mobileNo
        {
            self.smsToNumber(phoneNo: phoneNumber)
        }
    }
    
    @IBAction func whatsAppClicked(_ sender: UIButton) {
        if let phoneNumber = contactDetails?.mobileNo
        {
            self.openWhatsApp(phoneNo: phoneNumber)
        }
    }
    
    
}
struct DeleteContactStruct : Codable {
    let success: Bool?
    let statusMessage: String?
    let statusCode: Int?
    
    enum CodingKeys: String, CodingKey {
        case success
        case statusMessage = "status_Message"
        case statusCode = "status_Code"

    }
}
