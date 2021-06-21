//
//  AddmemberVC.swift
//  TMREIS
//
//  Created by Haritej on 03/05/21.
//

import UIKit
import DropDown

class AddmemberVC: UIViewController {

    @IBOutlet weak var txt_EmployeeId: UITextField!
    @IBOutlet weak var txt_LastName: UITextField!
    @IBOutlet weak var txt_FirstName: UITextField!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var txt_MobileNumber: UITextField!
    @IBOutlet weak var txt_Email: UITextField!
    @IBOutlet weak var btn_Gender: UIButton!
    @IBOutlet weak var btn_Designation: UIButton!
    @IBOutlet weak var btn_Office: UIButton!
    
    @IBOutlet weak var btn_BloodGroup: UIButton!
    var designationArray : [DesignationMasterStruct.Datum] = []
    var officeLocArray : [OfficeLocationsDetailsStruct.Datum] = []
    
    var designationId : String?
    var officeLoCId : String?
    lazy var dropDown = DropDown()
    //MARK:- Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        self.title = "Add Contact"
        getDesignationOfficeDetails()
        
        setupBackButton()
    }
    override func viewWillAppear(_ animated: Bool) {
        mainView.layer.cornerRadius = 5
        mainView.layer.borderWidth = 0.5
        mainView.layer.borderColor = UIColor(named: "Logogreen")?.cgColor
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true

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
        }
    }
    
    //MARK:- IBAction
    
    @IBAction func bloodGroupBtnAction(_ sender: UIButton) {
        let dataSource = ["Select","A+" , "A-" , "B+" , "B-" , "O+" , "O-" , "AB+" , "AB-"]
        dropDown.dataSource = dataSource
        dropDown.anchorView = sender
        dropDown.show()
        dropDown.selectionAction = { [unowned self](index : Int , item : String) in
            debugPrint(item)
            sender.setTitle(item, for: UIControl.State())
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
            sender.setTitle(item, for: UIControl.State())
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
            sender.setTitle(item, for: UIControl.State())
            self.designationId = designationArray[index - 1].desgID
            
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
            sender.setTitle(item, for: UIControl.State())
            self.officeLoCId = officeLocArray[index - 1].schoolID
            dropDown.hide()
        }
    }
    
    @IBAction func addMemberBtnAction(_ sender: UIButton) {
      //  guard validation() else {return}
        let parameters : [String : Any] = [
            "employeeName": txt_FirstName.text ?? "",
            "fathername": "",
            "employeeSurName": txt_LastName.text ?? "",
            "mothername": "",
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
            "photopath":"",
            "id":NSNull(),
            "employeeId":txt_EmployeeId.text ?? ""
            ]
        print(parameters)
        NetworkRequest.makeRequest(type: AddEmpContactStruct.self, urlRequest: Router.addEmpContact(parameters: parameters)) { [weak self](result) in
            guard let self = self else {return}
            switch result
            {
            case .success(let data):
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
        guard txt_FirstName.text?.trim().count != 0 else {self.showAlert(message: "Please Enter FirstName");return false}
        guard txt_LastName.text?.trim().count != 0 else {self.showAlert(message: "Please Enter LastName");return false}
        guard txt_EmployeeId.text?.trim().count != 0 else {self.showAlert(message: "Please Enter Employee Id");return false}
        guard txt_MobileNumber.text?.trim().count != 0 else {self.showAlert(message: "Please Enter MobileNumber");return false}
        guard txt_Email.text?.trim().count != 0 else {self.showAlert(message: "Please Enter Email");return false}
        guard btn_BloodGroup.currentTitle != "Select" else {self.showAlert(message: "Please Select Blood Group");return false}
        guard btn_Gender.currentTitle != "Select" else {self.showAlert(message: "Please Select Gender");return false}
        guard btn_Designation.currentTitle != "Select" else {self.showAlert(message: "Please Select Designation");return false}
        guard btn_Office.currentTitle != "Select" else {self.showAlert(message: "Please Select Office");return false}
        return true
    }
}



///
// MARK: - OfficeDetailsStruct
struct OfficeLocationsDetailsStruct: Codable {
    let success: Bool?
    let statusMessage: String?
    let statusCode: Int?
    let data: [Datum]?
 

    enum CodingKeys: String, CodingKey {
        case success
        case statusMessage = "status_Message"
        case statusCode = "status_Code"
        case data
    }
    // MARK: - Datum
    struct Datum: Codable {
        let officeType: String?
        let address, schoolID, schoolName, officeTypeID: String?
        let email: String?
        let phoneno: String?

        enum CodingKeys: String, CodingKey {
            case officeType = "office_type"
            case address
            case schoolID = "school_id"
            case schoolName = "school_name"
            case officeTypeID = "office_type_id"
            case email, phoneno
        }
    }
    //
    //
    //
    //enum OfficeType: String, Codable {
    //    case college = "College"
    //    case dmwo = "DMWO"
    //    case headOffice = "Head Office"
    //    case rlc = "RLC"
    //    case school = "School"
    //    case vigilance = "Vigilance"
    //}
    //
    //enum Phoneno: String, Codable {
    //    case empty = " "
    //}
}



// MARK: - DesignationMasterStruct
struct DesignationMasterStruct: Codable {
    let success: Bool?
    let statusMessage: String?
    let statusCode: Int?
    let data: [Datum]?
  

    enum CodingKeys: String, CodingKey {
        case success
        case statusMessage = "status_Message"
        case statusCode = "status_Code"
        case data
    }
    
    // MARK: - Datum
    struct Datum: Codable {
        let desgName, desgID: String

        enum CodingKeys: String, CodingKey {
            case desgName = "desg_name"
            case desgID = "desg_id"
        }
    }
}

struct AddEmpContactStruct : Codable {
    let success: Bool?
    let statusMessage: String?
    let statusCode: Int?
    
    enum CodingKeys: String, CodingKey {
        case success
        case statusMessage = "status_Message"
        case statusCode = "status_Code"

    }
}
