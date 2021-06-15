//
//  DownloadMastersVC.swift
//  TMREIS
//
//  Created by naresh banavath on 28/05/21.
//

import UIKit

class DownloadMastersVC: UIViewController {
  @IBOutlet weak var districtAdmicBtn: UIButton!
  
  @IBOutlet weak var collegesBtn: UIButton!
  @IBOutlet weak var schoolsBtn: UIButton!
  @IBOutlet weak var dwcBtn: UIButton!
  @IBOutlet weak var recBtn: UIButton!
  @IBOutlet weak var headOfficeDwdBtn: UIButton!
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Download Masters"
    setupBackButton()
    setupUI()
    // Do any additional setup after loading the view.
  }

   func setupUI()
   {
    let dwBtns = [headOfficeDwdBtn , recBtn , dwcBtn , schoolsBtn ,collegesBtn , districtAdmicBtn]
    let entities : [CoreDataEntity] = [.Schools_Entity]
    for entity in entities
    {
      if CoreDataManager.manager.getEntityData(type: ContactDetailsStruct.self, entityName: entity) != nil
      {
        
      }
    }
    
    
    
    if let data = CoreDataManager.manager.getEntityData(type: ContactDetailsStruct.self, entityName: .Schools_Entity)
    {
      schoolsBtn.setTitle("Re Download", for: .normal)
    }
    else
    {
      schoolsBtn.setTitle("Download", for: .normal)
    }
   }
  @IBAction func downloadBtnClicked(_ sender: UIButton) {
    print(sender.tag)
    switch sender.tag
    {
    case 1 : break
      //Head Office Clicked
    
    case 2 : break
      // REC clicked
    case 3 : break
      //DWC Clicked
    case 4 :
      //Schools Clicked
      print("school Taped")
      getContactDetails(schoolTypeId: "1", entityName: .Schools_Entity)
    case 5 : break
      //Colleges Clicked
    case 6 : break
      //District Admin Clicked
    default :
      break
      
    }
  }
  
  //MARK:- Service Calls
  
  func getContactDetails(schoolTypeId : String , entityName : CoreDataEntity){
      guard Reachability.isConnectedToNetwork() else {self.showAlert(message: noInternet);return}
      NetworkRequest.makeRequest(type: ContactDetailsStruct.self, urlRequest: Router.getContactDetails(schoolTypeId: schoolTypeId)) { [weak self](result) in
          switch result
          {
          case .success(let contactDetails):
             
            guard contactDetails.statusCode == 200 || contactDetails.success == true else {
              self?.showAlert(message: contactDetails.statusMessage ?? "Something went wrong") {
                   // self?.backButtonPressed()
                }
                    return
            }
            guard let data = contactDetails.data else {return}
                   if (!(data.isEmpty)){
                    //store in coredata
                    CoreDataManager.manager.saveEntityData(data: contactDetails, entityName: entityName)
                  //  print(CoreDataManager.manager.getEntityData(type: ContactDetailsStruct.self, entityName: .Schools_Entity)!)
  
                  }
          case .failure(let err):
              print(err)
              DispatchQueue.main.async {
                self?.showAlert(message: err.localizedDescription )
              }
          }
      }
  }
}

struct ContactDetailsStruct: Codable {
    let success: Bool?
    let statusMessage: String?
    let statusCode: Int?
    let data: [Contact]?
    let paginated: Bool?
    
    enum CodingKeys: String, CodingKey {
        case success
        case statusMessage = "status_Message"
        case statusCode = "status_Code"
        case data, paginated
    }
    // MARK: - Datum
    struct Contact: Codable , Hashable {
    
      let emailID, empID, gender, empName: String?
      let mobileNo: String?
      let schoolName: String?
      let empDesignation, userID, photopath: String?
      let district: String?
      let employeeID: String?
      let bloodGroup: String?
      let schoolTypeName: String?
      let schoolTypeID: String?
      let erstDistName: String?

      enum CodingKeys: String, CodingKey {
          case emailID = "email_id"
          case empID = "empId"
          case gender
          case empName = "emp_name"
          case mobileNo = "mobile_no"
          case schoolName = "school_name"
          case empDesignation = "emp_designation"
          case userID = "userId"
          case photopath, district
          case employeeID = "employee_Id"
          case bloodGroup = "blood_group"
          case schoolTypeName = "school_type_name"
          case schoolTypeID = "school_type_id"
          case erstDistName = "erst_dist_name"
      }
    }
}
