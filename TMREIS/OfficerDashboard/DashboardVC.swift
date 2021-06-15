//
//  DashboardVC.swift
//  TMREIS
//
//  Created by naresh banavath on 04/06/21.
//

import UIKit

class DashboardVC: UIViewController {
  
  @IBOutlet var dashBViews: [UIView]!
  @IBOutlet weak var nameLb: UILabel!
  @IBOutlet weak var designationLb: UILabel!
  
  @IBOutlet weak var placeLb: UILabel!
  
  
  @IBOutlet weak var headOfcView: UIView!
  @IBOutlet weak var recView: UIView!
  @IBOutlet weak var dwcView: UIView!
  @IBOutlet weak var schoolsView: UIView!
  @IBOutlet weak var collegesView: UIView!
  @IBOutlet weak var districtAdminView: UIView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    addmenuBtn()
    nameLb.text = UserDefaultVars.loginData?.data?.employeeName
    designationLb.text = UserDefaultVars.loginData?.data?.designation
    placeLb.text = UserDefaultVars.loginData?.data?.location
    dashBViews.forEach { (view) in
      view.layer.cornerRadius = view.bounds.height/2
    }
  //adding gestureRecogniser
    let headOfcRecogniser = UITapGestureRecognizer(target: self, action: #selector(headOfcViewClicked(_:)))
    headOfcView.addGestureRecognizer(headOfcRecogniser)
    
    let recRecogniser = UITapGestureRecognizer(target: self, action: #selector(recViewClicked(_:)))
    recView.addGestureRecognizer(recRecogniser)
    
    let dwcRecogniser = UITapGestureRecognizer(target: self, action: #selector(dwcViewClicked(_:)))
    dwcView.addGestureRecognizer(dwcRecogniser)
    
    let schoolsRecogniser = UITapGestureRecognizer(target: self, action: #selector(schoolsViewClicked(_:)))
    schoolsView.addGestureRecognizer(schoolsRecogniser)
    
    let collegesRecogniser = UITapGestureRecognizer(target: self, action: #selector(collegesViewClicked(_:)))
    collegesView.addGestureRecognizer(collegesRecogniser)
    
    let distAdminRecogniser = UITapGestureRecognizer(target: self, action: #selector(distAdminViewClicked(_:)))
    districtAdminView.addGestureRecognizer(distAdminRecogniser)
    //end of adding gesture recogniser
    
    
    
    // Do any additional setup after loading the view.
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    title = "TMREIS"
    self.navigationController?.navigationBar.barTintColor = UIColor(named: "Logogreen")
    self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
    self.navigationController?.navigationBar.isTranslucent = false
   // self.view.backgroundColor = .blue
    
  }
  func addmenuBtn()
  {
    let btn = UIButton()
    btn.setImage(UIImage(named: "open-menu 24"), for: .normal)
    btn.tintColor = .white
    btn.addTarget(self, action: #selector(menuBtnClicked(_:)), for: .touchUpInside)
    let barBtn = UIBarButtonItem(customView: btn)
    self.navigationItem.leftBarButtonItem = barBtn
    
  }
  //MARK:- Selector Methods
  @objc func headOfcViewClicked(_ gesture : UITapGestureRecognizer)
  {
    debugPrint("headOfcViewClicked")
  }
  @objc func recViewClicked(_ gesture : UITapGestureRecognizer)
  {
    debugPrint("recViewClicked")
  }
  @objc func dwcViewClicked(_ gesture : UITapGestureRecognizer)
  {
    debugPrint("dwcViewClicked")
  }
  @objc func schoolsViewClicked(_ gesture : UITapGestureRecognizer)
  {
    debugPrint("schoolsViewClicked")
    if let contactData = CoreDataManager.manager.getEntityData(type: ContactDetailsStruct.self, entityName: .Schools_Entity)
    {
      let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
      vc.contactsArray = contactData.data
      self.navigationController?.pushViewController(vc, animated: true)
    }else {
      self.showAlert(message: "Data not available for schools Please Download") {
        
      }
    }
  
  }
  @objc func collegesViewClicked(_ gesture : UITapGestureRecognizer)
  {
    debugPrint("collegesViewClicked")
  }
  @objc func distAdminViewClicked(_ gesture : UITapGestureRecognizer)
  {
    debugPrint("distAdminClicked")
  }
  @objc func menuBtnClicked(_ sender: UIButton) {
    sideMenuController?.revealMenu()
  }
}
