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
  }
  
  @IBAction func smsBtnClicked(_ sender: UIButton) {
  }
  
  @IBAction func whatsAppClicked(_ sender: UIButton) {
  }
  
  
}
