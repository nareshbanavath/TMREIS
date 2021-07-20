//
//  DownloadMastersVC.swift
//  TMREIS
//
//  Created by naresh banavath on 28/05/21.
//

import UIKit

class DownloadMastersVC: UIViewController {
    @IBOutlet var dashContainerViews: [UIView]!
    {
        didSet{
            dashContainerViews.forEach { (view) in
                view.layer.cornerRadius = view.frame.width / 2
                if #available(iOS 13.0, *) {
                    view.backgroundColor = .systemGray5
                } else {
                    // Fallback on earlier versions
                    view.backgroundColor = UIColor.lightGray
                }
            }
        }
    }
    
  @IBOutlet weak var districtAdmicBtn: UIButton!
  
  @IBOutlet weak var collegesBtn: UIButton!
  @IBOutlet weak var schoolsBtn: UIButton!
  @IBOutlet weak var dwcBtn: UIButton!
  @IBOutlet weak var recBtn: UIButton!
  @IBOutlet weak var headOfficeDwdBtn: UIButton!
  @IBOutlet weak var vigilanceDwdBtn: UIButton!
    
    override func viewDidLoad() {
    super.viewDidLoad()
    title = "Download Masters"
    setupBackButton()
    setupUI()
    // Do any additional setup after loading the view.
  }

   func setupUI()
   {
    let dwBtns = [headOfficeDwdBtn , recBtn , dwcBtn , schoolsBtn ,collegesBtn , districtAdmicBtn , vigilanceDwdBtn ]
    let entities : [CoreDataEntity] =  [.HeadOfc_Entity,.RLC_Entity,.DMWO_Entity,.Schools_Entity,.Colleges_Entity,.DistrictAdmin_Entity,.VigilanceTeam_Entity]
    for (index ,entity) in entities.enumerated()
    {
      if CoreDataManager.manager.getEntityData(type: ContactDetailsStruct.self, entityName: entity) != nil
      {
        dwBtns[index]?.setTitle("Re Download", for: UIControl.State())
        dwBtns[index]?.setTitleColor(UIColor.systemOrange, for: UIControl.State())
      }else{
        dwBtns[index]?.setTitle("Download", for: UIControl.State())
      }
    }
//
//
//
//    if CoreDataManager.manager.getEntityData(type: ContactDetailsStruct.self, entityName: .Schools_Entity) != nil
//    {
//      schoolsBtn.setTitle("Re Download", for: .normal)
//      schoolsBtn.setTitleColor(.systemOrange, for: .normal)
//    }
//    else
//    {
//      schoolsBtn.setTitle("Download", for: .normal)
//    }
   }
  @IBAction func downloadBtnClicked(_ sender: UIButton) {
    debugPrint(sender.tag)
    switch sender.tag
    {
    case 1 :
      //Head Office Clicked
        debugPrint("Head Office Taped")
        getContactDetails(schoolTypeId: "2", entityName: .HeadOfc_Entity)
    
    case 2 :
      // RLC clicked
        debugPrint("RLC Taped")
        getContactDetails(schoolTypeId: "3", entityName: .RLC_Entity)
    case 3 :
      //DWC Clicked
        debugPrint("DWC Taped")
        getContactDetails(schoolTypeId: "4", entityName: .DMWO_Entity)
    case 4 :
      //Schools Clicked
        debugPrint("School tapped")
      getContactDetails(schoolTypeId: "1", entityName: .Schools_Entity)
    case 5 :
      //Colleges Clicked
        debugPrint("Colleges Taped")
        getContactDetails(schoolTypeId: "5", entityName: .Colleges_Entity)
    case 6 :
      //District Admin Clicked
        debugPrint("district Admin Taped")
        getContactDetails(schoolTypeId: "7", entityName: .DistrictAdmin_Entity)
    case 7 : 
      //Vigiliance
        debugPrint("Vigiliance Taped")
        getContactDetails(schoolTypeId: "6", entityName: .VigilanceTeam_Entity)
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
                  //  debugPrint(CoreDataManager.manager.getEntityData(type: ContactDetailsStruct.self, entityName: .Schools_Entity)!)
                   }else {
                    self?.showAlert(message: "No Records Found") {
                         // self?.backButtonPressed()
                      }
                   }
            self?.setupUI()
          case .failure(let err):
              debugPrint(err)
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
      let uuid = UUID()
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
        static func == (lhs: Contact, rhs: Contact) -> Bool {
              return lhs.uuid == rhs.uuid
          }

          func hash(into hasher: inout Hasher) {
              hasher.combine(uuid)
          }
        
    }
}
