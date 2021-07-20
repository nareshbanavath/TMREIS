//
//  FilterContactVC.swift
//  TMREIS
//
//  Created by naresh banavath on 06/06/21.
//

import UIKit
import DropDown
enum FilterKey : String
{
  case designation
  case districts
  case clearFilter
}
class FilterContactVC: UIViewController {

    @IBOutlet weak var designationBtn: UIButton!
    var completion : ((FilterKey , _ value : String)->())?
  var designationDataSource : [String]?
  var districtsDataSource : [String]?
  let dropDown = DropDown()
    override func viewDidLoad() {
        super.viewDidLoad()
      let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewdidTap))
      view.addGestureRecognizer(tapGesture)
      
        // Do any additional setup after loading the view.
    }
    @objc func viewdidTap()
    {
      dismiss(animated: true, completion: nil)
    }
  @IBAction func designationBtnClicked(_ sender: UIButton) {
    dropDown.dataSource = designationDataSource ?? []
    dropDown.anchorView = sender
    dropDown.show()
    dropDown.selectionAction = {[unowned self](index , item) in
      dropDown.hide()
      debugPrint(item)
      self.completion?(.designation , item)
      self.dismiss(animated: true, completion: nil)
    }
  }
  @IBAction func districtBtnClicked(_ sender: UIButton) {
    dropDown.dataSource = districtsDataSource ?? []
    dropDown.anchorView = sender
    dropDown.show()
    dropDown.selectionAction = {[unowned self](index , item) in
      dropDown.hide()
      self.completion?(.districts , item)
      self.dismiss(animated: true, completion: nil)
      debugPrint(item)
    }
  }
  @IBAction func clearFilterBtnClicked(_ sender: UIButton) {
    self.completion?(.clearFilter , "")
    dismiss(animated: true, completion: nil)
  }
}
