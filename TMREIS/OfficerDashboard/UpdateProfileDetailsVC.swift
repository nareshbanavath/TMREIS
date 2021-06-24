//
//  UpdateProfileDetailsVC.swift
//  TMREIS
//
//  Created by deep chandan on 16/06/21.
//

import UIKit
import DropDown

class UpdateProfileDetailsVC: UIViewController {

    @IBOutlet weak var profileImgView: ImagePickeredView!
    {
        didSet{
            profileImgView.parentViewController = self
        }
    }
    @IBOutlet weak var txt_Name: UITextField!
    @IBOutlet weak var txt_EmployeeId: UITextField!
    @IBOutlet weak var txt_MobileNumber: UITextField!
    {
        didSet{
            txt_MobileNumber.delegate = self
        }
    }
    @IBOutlet weak var txt_Email: UITextField!
    
    @IBOutlet weak var btn_Gender: UIButton!
    @IBOutlet weak var btn_Designation: UIButton!
    @IBOutlet weak var btn_Office: UIButton!
    
    @IBOutlet weak var btn_BloodGroup: UIButton!
    var designationArray : [DesignationMasterStruct.Datum] = []
    var officeLocArray : [OfficeLocationsDetailsStruct.Datum] = []
    var isCurrentUser : Bool = false
    var contactDetail : ContactDetailsStruct.Contact?
    var designationId : String?
    var officeLoCId : String?
    var updateID : Int!
    lazy var dropDown = DropDown()
    var photoPath = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Update Profile Details"
        setupBackButton()
        getDesignationOfficeDetails()
        
        if isCurrentUser
        {
            profileImgView.superview?.isHidden = false
            btn_Designation.isEnabled = false
            btn_Office.isEnabled = false
            btn_Designation.setTitleColor(UIColor.gray, for: UIControl.State())
            btn_Office.setTitleColor(UIColor.gray, for: UIControl.State())
            
            let currentUsrData = UserDefaultVars.loginData?.data
          //  print(currentUsrData)
            if let photoPath = currentUsrData?.photopath , photoPath != ""
            {
                profileImgView.image = photoPath.convertBase64StringToImage()
                self.photoPath = photoPath
            }
            else{
                photoPath = ""
            }
           
            txt_Name.text = currentUsrData?.employeeName
            if let empId = currentUsrData?.empID
            {
                txt_EmployeeId.text = String(empId)
            }
            txt_MobileNumber.text = currentUsrData?.mobileNumber
            txt_Email.text = currentUsrData?.emailid
            let bloodGroup = currentUsrData?.bloodgroup == "" || currentUsrData?.bloodgroup == nil ? "Select" : currentUsrData?.bloodgroup
            let gender = currentUsrData?.gender == "" || currentUsrData?.gender == nil ? "Select" : currentUsrData?.gender
            btn_BloodGroup.setTitle(bloodGroup , for: UIControl.State())
            btn_Gender.setTitle(gender == "Select" ? "Select" : (gender == "M" ? "Male" : "Female"), for: UIControl.State())
            btn_Designation.setTitle(currentUsrData?.designation, for: UIControl.State())
            btn_Office.setTitle(currentUsrData?.location, for: UIControl.State())
        }
        else
        {
            profileImgView.superview?.isHidden = true
            btn_Designation.isEnabled = true
            btn_Office.isEnabled = true
            btn_Designation.setTitleColor(UIColor.black, for: UIControl.State())
            btn_Office.setTitleColor(UIColor.black, for: UIControl.State())
            
          //  profileImgView.image = contactDetail?.photopath?.convertBase64StringToImage()
            txt_Name.text = contactDetail?.empName
            txt_EmployeeId.text = contactDetail?.empID
            txt_MobileNumber.text = contactDetail?.mobileNo
            txt_Email.text = contactDetail?.emailID
            let gender = contactDetail?.gender == "" || contactDetail?.gender == nil ? "Select" : contactDetail?.gender
            btn_BloodGroup.setTitle(contactDetail?.bloodGroup == "" ? "Select" : contactDetail?.bloodGroup , for: UIControl.State())
            btn_Gender.setTitle(gender == "Select" ? "Select" : (gender == "M" ? "Male" : "Female"), for: UIControl.State())
            btn_Designation.setTitle(contactDetail?.empDesignation, for: UIControl.State())
            btn_Office.setTitle(contactDetail?.schoolName, for: UIControl.State())
            
         

        }

        
        // Do any additional setup after loading the view.
    }
    
    func settingOfficeDesignationIDs()
    {
        guard btn_Office.currentTitle != "Select" , btn_Designation.currentTitle != "Select" else {return}
        let office = btn_Office.currentTitle
        let designation = btn_Designation.currentTitle
       
        officeLocArray.forEach { (ofcLoc) in
            if ofcLoc.schoolName == office
            {
                self.officeLoCId = ofcLoc.schoolID
            }
        }
        designationArray.forEach { (desg) in
            if desg.desgName == designation
            {
                self.designationId = desg.desgID
            }
        }
       
    }
    //MARK:- Service Calls
    func getDesignationOfficeDetails()
    {
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        guard Reachability.isConnectedToNetwork() else {self.showAlert(message: noInternet);return}
        NetworkRequest.makeRequest(type: DesignationMasterStruct.self, urlRequest: Router.getDesignationMasterDetails) { [weak self](result) in
            dispatchGroup.leave()
            switch result
            {
            case .success(let data):
                //debugPrint(data.data?.count)
                self?.designationArray = data.data ?? []
            case .failure(let err):
                debugPrint(err.localizedDescription)
            }
        }
        dispatchGroup.enter()
        guard Reachability.isConnectedToNetwork() else {self.showAlert(message: noInternet);return}
        NetworkRequest.makeRequest(type: OfficeLocationsDetailsStruct.self, urlRequest: Router.getOfficeLocationDetails) { [weak self](result) in
            dispatchGroup.leave()
            switch result
            {
            case .success(let data):
               // debugPrint(data.data?.count)
                self?.officeLocArray = data.data ?? []
            case .failure(let err):
                debugPrint(err.localizedDescription)
            }
        }
        
        dispatchGroup.notify(queue: .main){
            print("All Tasks Finished")
            self.settingOfficeDesignationIDs()
        }
    }
    
    //MARK:- IBAction
    
    @IBAction func bloodGroupBtnAction(_ sender: UIButton) {
        let dataSource = ["Select","A+" , "A-" , "B+" , "B-" , "O+" , "O-" , "AB+" , "AB-"]
        dropDown.dataSource = dataSource
        dropDown.anchorView = sender
        dropDown.show()
        dropDown.selectionAction = { [unowned self](index : Int , item : String) in
           // debugPrint(item)
            sender.setTitle("  \(item)", for: UIControl.State())
            dropDown.hide()
        }
    }
    @IBAction func genderBtnAction(_ sender: UIButton) {
        let dataSource = ["Select","Male" , "Female"]
        dropDown.dataSource = dataSource
        dropDown.anchorView = sender
        dropDown.show()
        dropDown.selectionAction = { [unowned self](index : Int , item : String) in
            debugPrint(item)
            sender.setTitle("  \(item)", for: UIControl.State())
            dropDown.hide()
        }
    }
    @IBAction func designationBtnAction(_ sender: UIButton) {
        var dataSource = designationArray.map({$0.desgName})
        dataSource.insert("Select", at: 0)
        dropDown.dataSource = dataSource
        dropDown.anchorView = sender
        dropDown.show()
        dropDown.selectionAction = { [unowned self](index : Int , item : String) in
            debugPrint(item)
            sender.setTitle("  \(item)", for: UIControl.State())
            if index != 0{
            self.designationId = designationArray[index - 1].desgID
            }
            
            dropDown.hide()
        }
        
    }
    @IBAction func officeBtnAction(_ sender: UIButton) {
        var dataSource = officeLocArray.map({$0.schoolName ?? ""})
        dataSource.insert("Select", at: 0)
        dropDown.dataSource = dataSource
        dropDown.anchorView = sender
        dropDown.show()
        dropDown.selectionAction = { [unowned self](index : Int , item : String) in
            debugPrint(item)
            sender.setTitle("  \(item)", for: UIControl.State())
            if index != 0{
            self.officeLoCId = officeLocArray[index - 1].schoolID
            }
            dropDown.hide()
        }
    }
    
    @IBAction func updateBtnAction(_ sender: UIButton) {
        guard validation() else {return}
        if isCurrentUser
        {
            updateID = UserDefaultVars.loginData?.data?.empID
        }
        else {
            updateID = Int(contactDetail?.empID ?? "0")
        }
        let parameters : [String : Any] = [
            "employeeName": txt_Name.text ?? "",
            "employeeEmail":txt_Email.text ?? "",
            "gender":btn_Gender.currentTitle == "Male" ? "M" : "F",
            "phoneNumber":txt_MobileNumber.text ?? "",
            "designation": [
                "id": Int(designationId ?? "0")!
            ],
            
            "officeMaster": [
                "id": Int(officeLoCId ?? "0")!
            ],
            "bloodGroup": btn_BloodGroup.currentTitle ?? "",
            "photopath": self.photoPath,
            "id":updateID ?? NSNull(),
            "employeeId":txt_EmployeeId.text ?? ""
        ]
       // print(parameters)
        NetworkRequest.makeRequest(type: LoginStruct.self, urlRequest: Router.updateEmpContact(parameters: parameters)) { [weak self](result) in
            guard let self = self else {return}
            switch result
            {
            case .success(let data):
                guard data.statusCode == 200 else {
                    self.showAlert(message: data.statusMessage ?? serverNotResponding);return
                }
            
                UserDefaultVars.loginData = data
                self.showAlert(message: data.statusMessage ?? serverNotResponding)
                {
                 
                    self.backButtonPressed()
                }
            case .failure(let err):
                DispatchQueue.main.async {
                    self.showAlert(message: err.localizedDescription)
                }
            }
        }
    }
    func validation() -> Bool
    {
        guard txt_Name.text?.trim().count != 0 else {self.showAlert(message: "Please Enter Name");return false}
        guard txt_EmployeeId.text?.trim().count != 0 else {self.showAlert(message: "Please Enter Employee Id");return false}
        guard txt_MobileNumber.text?.trim().count != 0 else {self.showAlert(message: "Please Enter MobileNumber");return false}
        guard txt_Email.text?.trim().count != 0 else {self.showAlert(message: "Please Enter Email");return false}
        guard self.isValidEmail(emailStr: txt_Email.text!) else {self.showAlert(message: "Please Enter Valid Email");return false}
        guard btn_BloodGroup.currentTitle?.trim() != "Select" else {self.showAlert(message: "Please Select Blood Group");return false}
        guard btn_Gender.currentTitle?.trim() != "Select" else {self.showAlert(message: "Please Select Gender");return false}
        guard btn_Designation.currentTitle?.trim() != "Select" else {self.showAlert(message: "Please Select Designation");return false}
        guard btn_Office.currentTitle?.trim() != "Select" else {self.showAlert(message: "Please Select Office");return false}
        return true
    }

    
}
extension UpdateProfileDetailsVC : UITextFieldDelegate
{
    
  //MARK:- TextField Delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 10
        let currentString: NSString = (textField.text ?? "") as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
        
    }
}
