//
//  LoginVC.swift
//  TMREIS
//
//  Created by deep chandan on 27/04/21.
//

import UIKit
import SwipeMenuViewController

class SigninSwipeupVC: UIViewController{
  @IBOutlet weak var swipemenuView: SwipeMenuView!
  var options : SwipeMenuViewOptions = .init()
  var swipeTitles = ["CITIZEN" , "OFFICER"]
  //var isCitizen:Bool = true
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationController?.isNavigationBarHidden = true
    let fcmKey = "frfdtk1Kc4Y:APA91bF3hhY6xO2POWpga"
    UserDefaults.standard.set(fcmKey , forKey: "fcmKey")
    
    
  //  UserDefaultVars.fcmToken = fcmKey
    
    self.swipeMenuSetup()
  }
  func swipeMenuSetup()
  {
    swipemenuView.delegate = self
    swipemenuView.dataSource = self
    options.tabView.style = .segmented
    options.tabView.margin                          = 0.0
    swipemenuView.layer.borderColor = UIColor.black.cgColor
    swipemenuView.layer.borderWidth = 0.5
    //  options.tabView.additionView.backgroundColor    = UIColor(named: ThemeConstant.bgColor.getTheme())!
    options.tabView.backgroundColor                 = UIColor.groupTableViewBackground
    options.tabView.itemView.textColor              = UIColor.darkGray
    options.tabView.itemView.selectedTextColor      = UIColor.black
    options.tabView.itemView.font = UIFont.systemFont(ofSize: CGFloat(12.0))
    options.tabView.height = 40
    options.tabView.isSafeAreaEnabled = false
    
    swipemenuView.reloadData(options: options, default: 0, isOrientationChange: false)
    
  }
  
}
extension SigninSwipeupVC:SwipeMenuViewDelegate,SwipeMenuViewDataSource{
  func swipeMenuView(_ swipeMenuView: SwipeMenuView, viewControllerForPageAt index: Int) -> UIViewController {
    switch index {
    case 0:
      let vc = storyboards.Login.instance.instantiateViewController(withIdentifier: "CitizenVC") as! CitizenVC
      addChild(vc)
      
      return vc
    default:
      let vc = storyboards.Login.instance.instantiateViewController(withIdentifier: "OfficerVC") as! OfficerVC
      
      addChild(vc)
      return vc
    }
  }
  
  
  func swipeMenuView(_ swipeMenuView: SwipeMenuView, titleForPageAt index: Int) -> String {
    return swipeTitles[index]
  }
  
  func numberOfPages(in swipeMenuView: SwipeMenuView) -> Int {
    return swipeTitles.count
  }
  func swipeMenuView(_ swipeMenuView: SwipeMenuView, didChangeIndexFrom fromIndex: Int, to toIndex: Int) {
    if toIndex == 1
    {
      
    }
  }
  
}

// MARK: - OfficerLoginStruct
struct LoginStruct: Codable {
  let success: Bool
  let statusMessage: String?
  let statusCode: Int
  let data: DataClass?
  let paginated: Bool
  
  enum CodingKeys: String, CodingKey {
    case success
    case statusMessage = "status_Message"
    case statusCode = "status_Code"
    case data, paginated
  }
  // MARK: - DataClass
  struct DataClass: Codable {
    let employeeID, employeeName, designation, mobileNumber: String?
    let gender: String?
    let otpMobile: String?
    let userID: Int?
    let userName, userType: String?
    let photopath: String?
    let bloodgroup: String?
    let services: String?
    let location, token, fcmtoken, emailid: String?
    let empID: Int?
    let mpin: String?
    
    enum CodingKeys: String, CodingKey {
      case employeeID = "employeeId"
      case employeeName, designation, mobileNumber, gender, otpMobile
      case userID = "userId"
      case userName, userType, photopath, bloodgroup, services, location, token, fcmtoken, emailid
      case empID = "empId"
      case mpin
    }
  }
}
