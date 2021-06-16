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
    @IBOutlet weak var txt_Name: UITextField!
    @IBOutlet weak var txt_EmployeeId: UITextField!
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
    override func viewDidLoad() {
        super.viewDidLoad()
        getDesignationOfficeDetails()
        // Do any additional setup after loading the view.
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
    
    @IBAction func updateBtnAction(_ sender: UIButton) {
      //  guard validation() else {return}
        let parameters : [String : Any] = [
            "employeeName": txt_Name.text ?? "",
            "fathername": "",
            "employeeSurName": "",
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
            "bloodgroup": btn_BloodGroup.currentTitle ?? "",
            "photo":"",
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
        guard txt_Name.text?.trim().count != 0 else {self.showAlert(message: "Please Enter FirstName");return false}
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
