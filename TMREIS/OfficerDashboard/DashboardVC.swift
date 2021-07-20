//
//  DashboardVC.swift
//  TMREIS
//
//  Created by naresh banavath on 04/06/21.
//

import UIKit
import Floaty
class DashboardVC: UIViewController {
    
    //MARK:- Properties
    @IBOutlet weak var scrollContainerView: UIView!
    {
        didSet{
            scrollContainerView.layer.cornerRadius = 10.0
        }
    }
    @IBOutlet weak var profileImgView: UIImageView!
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
    @IBOutlet weak var vigilanceView: UIView!
    
    //MARK:- Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        addmenuBtn()
       
       
        dashBViews.forEach { (view) in
            view.layer.cornerRadius = 7
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
        
        let vigilanceRecogniser = UITapGestureRecognizer(target: self, action: #selector(vigilanceViewTaped(_:)))
        vigilanceView.addGestureRecognizer(vigilanceRecogniser)
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
        
        nameLb.text = UserDefaultVars.loginData?.data?.employeeName
        designationLb.text = UserDefaultVars.loginData?.data?.designation
        placeLb.text = UserDefaultVars.loginData?.data?.location
        if let photoStr = UserDefaultVars.loginData?.data?.photopath , photoStr != ""
        {
            profileImgView.image = photoStr.convertBase64StringToImage()
        }
        if UserDefaultVars.loginData?.data?.userType == "A"
        {
            addFilterButton()
        }
        
        
    }
    //MARK:- IBAction Btns
    
    @IBAction func EditBtnClicked(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UpdateProfileDetailsVC") as! UpdateProfileDetailsVC
        let currentusrData = UserDefaultVars.loginData?.data
        vc.isCurrentUser = true
        self.navigationController?.pushViewController(vc, animated: true)
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
        navigateToContactVc(dataNotAvailableMsg: "Head Office", entity: .HeadOfc_Entity)
    }
    @objc func recViewClicked(_ gesture : UITapGestureRecognizer)
    {
        debugPrint("recViewClicked")
        navigateToContactVc(dataNotAvailableMsg: "RLC", entity: .RLC_Entity)
    }
    @objc func dwcViewClicked(_ gesture : UITapGestureRecognizer)
    {
        debugPrint("dwcViewClicked")
        navigateToContactVc(dataNotAvailableMsg: "DMWO", entity: .DMWO_Entity)
    }
    @objc func schoolsViewClicked(_ gesture : UITapGestureRecognizer)
    {
        debugPrint("schoolsViewClicked")
        navigateToSchoolCollegeVC(dataNotAvailableMsg: "Schools", entity: .Schools_Entity)
        
    }
    @objc func collegesViewClicked(_ gesture : UITapGestureRecognizer)
    {
        debugPrint("collegesViewClicked")
        navigateToSchoolCollegeVC(dataNotAvailableMsg: "Colleges", entity: .Colleges_Entity)
    }
    @objc func distAdminViewClicked(_ gesture : UITapGestureRecognizer)
    {
        debugPrint("distAdminClicked")
        navigateToContactVc(dataNotAvailableMsg: "District Administration", entity: .DistrictAdmin_Entity)
    }
    @objc func vigilanceViewTaped(_ gesture : UITapGestureRecognizer)
    {
        debugPrint("vigilance tapped")
        navigateToContactVc(dataNotAvailableMsg: "Vigilance Team", entity: .VigilanceTeam_Entity)
    }
    @objc func menuBtnClicked(_ sender: UIButton) {
        sideMenuController?.revealMenu()
    }
    //MARK:- HelperMethods
    func navigateToContactVc(dataNotAvailableMsg : String ,entity : CoreDataEntity)
    {
        if let contactData = CoreDataManager.manager.getEntityData(type: ContactDetailsStruct.self, entityName: entity)
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
            vc.contactsArray = contactData.data
            self.navigationController?.pushViewController(vc, animated: true)
        }else {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "DownloadMastersVC") as! DownloadMastersVC
            let navVc = UINavigationController(rootViewController: vc)
            self.showAlert(message: "Data not available for \(dataNotAvailableMsg) Please Download") {
                self.sideMenuController?.setContentViewController(to: navVc)
            }
        }
    }
    func navigateToSchoolCollegeVC(dataNotAvailableMsg : String ,entity : CoreDataEntity){
        if let contactData = CoreDataManager.manager.getEntityData(type: ContactDetailsStruct.self, entityName: entity)
        {
           // print(contactData)
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SchoolCollegeVC") as! SchoolCollegeVC
            vc.contactsArray = contactData.data
            self.navigationController?.pushViewController(vc, animated: true)
        }else {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "DownloadMastersVC") as! DownloadMastersVC
            let navVc = UINavigationController(rootViewController: vc)
            self.showAlert(message: "Data not available for \(dataNotAvailableMsg) Please Download") {
                self.sideMenuController?.setContentViewController(to: navVc)
            }
        }
    }
    func addFilterButton()
    {

        let floaty = Floaty()
        floaty.buttonImage = UIImage(named: "plus")
        floaty.itemTitleColor = .green
        floaty.buttonColor = UIColor(named: "LogoPink") ?? UIColor.orange
        floaty.overlayColor = UIColor.white.withAlphaComponent(0.8)
        floaty.plusColor = .white
        floaty.addItem("Add Contact", icon: UIImage(named: "addmember")!, handler: {[unowned self] item in
            print("add contact clicked")
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddmemberVC") as! AddmemberVC
            let navVC = UINavigationController(rootViewController: vc)
            self.view.window?.rootViewController = navVC
            self.view.window?.makeKeyAndVisible()
        })
        floaty.addItem("Broadcast", icon: UIImage(named: "broadcast")!, handler: {[unowned self]  item in
           print("broadcastclicked")
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "BroadcastVC") as! BroadcastVC
            let navVC = UINavigationController(rootViewController: vc)
            self.view.window?.rootViewController = navVC
            self.view.window?.makeKeyAndVisible()
        })
        self.view.addSubview(floaty)
        floaty.items.forEach { (item) in
            item.titleColor = UIColor.white
            // item.titleLabel.backgroundColor = .green
            item.titleLabel.font = UIFont.systemFont(ofSize: 14.0)
          //  item.icon = UIImage(named: "approvedIcon")
            item.hasShadow = false
            item.titleLabel.textAlignment = .right
            item.buttonColor = UIColor(named: "LogoPink")!

        }
    }
  
}
