//
//  SinglecontactDetailsVC.swift
//  TMREIS
//
//  Created by Haritej on 05/05/21.
//

import UIKit

class SinglecontactDetailsVC: UIViewController {
  
  @IBOutlet weak var employeeName: UILabel!
  @IBOutlet weak var designationLb: UILabel!
  
  @IBOutlet weak var officeLb: UILabel!
  
  @IBOutlet weak var locationLb: UILabel!
  
  @IBOutlet weak var phoneNumberlb: UILabel!
  
  @IBOutlet weak var mailIdLb: UILabel!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    
  
  
  
  var contactDetails:ContactDetailsStruct.Contact?
    override func viewDidLoad() {
        super.viewDidLoad()
      employeeName.text = contactDetails?.empName
      designationLb.text = contactDetails?.empDesignation
      officeLb.text = contactDetails?.schoolTypeName
      locationLb.text = contactDetails?.district
      phoneNumberlb.text  = contactDetails?.mobileNo
      mailIdLb.text = contactDetails?.emailID
      
        // Do any additional setup after loading the view.
    }
  
  @IBAction func closeBtnClicked(_ sender: UIButton) {
    self.dismiss(animated: true, completion: nil)
  }
  
  @IBAction func editBtnClicked(_ sender: UIButton) {
  }
  
  @IBAction func deleteBtnClicked(_ sender: UIButton) {
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
