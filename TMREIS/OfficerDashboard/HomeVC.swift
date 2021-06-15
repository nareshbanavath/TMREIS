//
//  HomeVC.swift
//  TMREIS
//
//  Created by deep chandan on 29/04/21.
//

import UIKit
import Floaty
enum Section
{
  case main
}
class HomeVC: UIViewController  {
  
  @IBOutlet weak var searchBarHeightConstraint: NSLayoutConstraint!
  {
    didSet
    {
      searchBarHeightConstraint.constant = 0
    }
  }
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var searchBar: UISearchBar!
  {
    didSet
    {
      searchBar.showsCancelButton = true
      searchBar.delegate = self
    }
  }
  var contactsArray : [ContactDetailsStruct.Contact]?
  var filteredContactArray : [ContactDetailsStruct.Contact]?
  var designation : [String]?
  var districts : [String]?
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.tableFooterView = UIView()
    tableView.delegate = self
    tableView.dataSource = self
    self.filteredContactArray = contactsArray
    //  print(filteredContactArray)

    tableView.reloadData()
    // self.addFilterButton()
    title = "Contacts"
    self.setupBackButton()
    designation = filteredContactArray?.map({$0.empDesignation}).uniqued() as? [String]
    districts = filteredContactArray?.map({$0.district}).uniqued() as? [String]
    addRightBarButtons()
    
  }
 
  //MARK:- helper methods
  @available(iOS 13.0, *)
  func makeDataSource() -> UITableViewDiffableDataSource<Section , ContactDetailsStruct.Contact>
  {
    let datasource = UITableViewDiffableDataSource<Section , ContactDetailsStruct.Contact>(tableView: tableView) { (tableView, IndexPath, contact) -> UITableViewCell? in
      return self.prepareTableViewCell(row: IndexPath.row)
    }
    return datasource
  }
  @available(iOS 13.0, *)
  func applySnapshot(array : [ContactDetailsStruct.Contact] , animatingDifferences : Bool = false)
  {
    var snapShot = NSDiffableDataSourceSnapshot<Section , ContactDetailsStruct.Contact>()
    snapShot.appendSections([.main])
    snapShot.appendItems(array)
    makeDataSource().apply(snapShot, animatingDifferences: animatingDifferences, completion: nil)
    
  }
  func prepareTableViewCell(row : Int) -> UITableViewCell
  {
    let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTBCell") as! HomeTBCell
    let item = filteredContactArray?[row]
    cell.empNameLb.text = item?.empName
    cell.designation.text = item?.empDesignation
    cell.usrInitialLetterLb.text = String(item?.empName?.prefix(1) ?? "")
    
    return cell
  }
  func addRightBarButtons()
  {
    let filterBtn = UIButton()
    filterBtn.tintColor = .white
    filterBtn.setImage(UIImage(named: "plus"), for: .normal)
    filterBtn.addTarget(self, action: #selector(filterBtnClicked(_:)), for: .touchUpInside)
    let filterBarBtn = UIBarButtonItem(customView: filterBtn)
    let searchButton = UIBarButtonItem.init(barButtonSystemItem: .search, target: self, action: #selector(searchBtnClicked(_:)))
    searchButton.tintColor = .white
    self.navigationItem.setRightBarButtonItems([searchButton , filterBarBtn], animated: true)
  }
  @objc func searchBtnClicked(_ sender : UIButton)
  {
    searchBarHeightConstraint.constant = 56
    UIView.animate(withDuration: 0.250) {
      self.view.layoutIfNeeded()
    }
  }
  @objc func filterBtnClicked(_ sender : UIButton)
  {
    let vc = self.storyboard?.instantiateViewController(withIdentifier: "FilterContactVC") as! FilterContactVC
    vc.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
    vc.definesPresentationContext = false
    vc.designationDataSource = designation
    vc.districtsDataSource = districts
    vc.completion = { [unowned self](filterKey , value) in
      switch filterKey {
      case .districts:
        self.filteredContactArray = self.contactsArray?.filter({$0.district == value})
      case .designation:
        self.filteredContactArray = self.contactsArray?.filter({$0.empDesignation == value})
      default:
        tableView.reloadData()
      }
      if #available(iOS 13.0, *) {
        applySnapshot(array: filteredContactArray ?? [] , animatingDifferences: true)
      } else {
        // Fallback on earlier versions
        tableView.reloadData()
      }
 
    }
    present(vc, animated: true, completion: nil)
  }
//  func addPlusButton(){
//    let floaty = Floaty()
//    floaty.buttonImage = UIImage(named: "plus")
//    floaty.itemTitleColor = .green
//    floaty.buttonColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
//    floaty.overlayColor = UIColor.white.withAlphaComponent(0.8)
//    floaty.plusColor = .white
//    floaty.addItem("", icon: UIImage(named: "addmember")!, handler: {[unowned self] item in
//      let vc = storyboards.Officer.instance.instantiateViewController(withIdentifier: "AddmemberVC") as! AddmemberVC
//      self.navigationController?.pushViewController(vc, animated: true)//            self.tableViewDataSource = self.reports?.filter { $0.pendingApprove == "2"}
//      //            self.tableView.reloadData()
//
//    })
//    floaty.addItem("", icon: UIImage(named: "broadcast")!, handler: {[unowned self]  item in
//      let vc = storyboards.Officer.instance.instantiateViewController(withIdentifier: "BroadcastVC") as! BroadcastVC
//      self.navigationController?.pushViewController(vc, animated: true)//
//      //            self.tableViewDataSource = self.reports?.filter { $0.pendingApprove == "1"}
//      //            // print(self.tableViewDataSource?.count)
//      //            self.tableView.reloadData()
//    })
//
//    floaty.items.forEach { (item) in
//      switch item.icon {
//      case   UIImage(named: "addmember"):
//        item.titleColor =  .green
//        // item.titleLabel.backgroundColor = .green
//        item.titleLabel.font = UIFont.systemFont(ofSize: 14.0)
//        item.icon = UIImage(named: "broadcast")
//        item.hasShadow = false
//        item.titleLabel.textAlignment = .right
//        item.buttonColor = .systemPink
//      case UIImage(named: "broadcast"):
//        item.titleColor = UIColor.darkGray
//        // item.titleLabel.backgroundColor = .green
//        item.titleLabel.font = UIFont.systemFont(ofSize: 14.0)
//        item.icon = UIImage(named: "broadcast")
//        item.hasShadow = false
//        item.titleLabel.textAlignment = .right
//        item.buttonColor = .systemPink
//
//      case .none:
//        print("")
//      case .some(_):
//        print("")
//      }
//    }
//    self.view.addSubview(floaty)
//  }
}
extension HomeVC : UITableViewDataSource , UITableViewDelegate
{
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return filteredContactArray?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    return prepareTableViewCell(row: indexPath.row)
  }
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard UserDefaultVars.RolesArray.contains("ROLE_ADMIN") else {return}
    let vc = self.storyboard?.instantiateViewController(withIdentifier: "SinglecontactDetailsVC") as! SinglecontactDetailsVC
    vc.contactDetails = filteredContactArray?[indexPath.row]
    //    vc.definesPresentationContext = false
    vc.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
    if #available(iOS 13.0, *) {
      vc.modalPresentationStyle = .automatic
    } else {
      // Fallback on earlier versions
    }
    vc.modalTransitionStyle = .coverVertical
    present(vc, animated: true, completion: nil)
  }
  
  
}
extension HomeVC:UISearchBarDelegate{
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        self.view.endEditing(true)
      searchBarHeightConstraint.constant = 0
        UIView.animate(withDuration: 0.250) {
            self.view.layoutIfNeeded()
        }
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
      guard !searchText.isEmpty  else { self.filteredContactArray = contactsArray; return }
      self.filteredContactArray = contactsArray?.filter({ user -> Bool in
        return user.empName?.lowercased().contains(searchText.lowercased()) ?? false || user.empDesignation?.lowercased().contains(searchText.lowercased()) ?? false
            })
            tableView.reloadData()
        }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }//
}

