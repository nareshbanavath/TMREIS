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
    
    //DiffableDatasource start
    @available(iOS 13.0, *)
    typealias DataSource = UITableViewDiffableDataSource<Section ,ContactDetailsStruct.Contact>
    @available(iOS 13.0, *)
    typealias SnapShot = NSDiffableDataSourceSnapshot<Section ,ContactDetailsStruct.Contact>
    @available(iOS 13.0, *)
    public lazy var dataSource = makeDataSource()
    //DiffableDatasource End
    var randomColors : [UIColor] = [.systemRed , .systemBlue , .systemOrange ,.systemGreen , .systemPink]
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.separatorColor = .clear
        self.filteredContactArray = contactsArray
        //  debugPrint(filteredContactArray)
        if #available(iOS 13.0, *) {
            applySnapShot(array: contactsArray ?? [] , animating: false)
        } else {
            // Fallback on earlier versions
            tableView.reloadData()
        }
        // tableView.reloadData()
        // self.addFilterButton()
        title = "Contacts"
        self.setupBackButton()
        designation = filteredContactArray?.map({$0.empDesignation}).uniqued() as? [String]
        districts = filteredContactArray?.map({$0.district}).uniqued() as? [String]
        addRightBarButtons()
        
    }
    
    //MARK:- helper methods
    @available(iOS 13.0, *)
    func makeDataSource() -> DataSource
    {
        let dataSource = DataSource(tableView: tableView) { (tableView, indexPath, contact) -> UITableViewCell? in
            return self.prepareTableViewCell(tableView : tableView,row: indexPath.row)
        }
        return dataSource
    }
    @available(iOS 13.0 , *)
    func applySnapShot(array : [ContactDetailsStruct.Contact] ,animating : Bool = true)
    {
        var snapShot = SnapShot()
        snapShot.appendSections([.main])
        snapShot.appendItems(array)
        dataSource.apply(snapShot, animatingDifferences: animating)
        if array.count == 0
        {
            tableView.setEmptyMessage("No Records Found" , textColor: .white)
        }else {
            tableView.restore()
        }
    }
    func prepareTableViewCell(tableView : UITableView,row : Int) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTBCell") as! HomeTBCell
        let item = filteredContactArray?[row]
        cell.empNameLb.text = item?.empName
        cell.designation.text = "\(item?.empDesignation ?? "") , \(item?.district ?? "")"
        cell.usrInitialLetterLb.text = String(item?.empName?.uppercased().prefix(1) ?? "")
        cell.usrInitialLetterLb.backgroundColor = randomColors[row % 5]
        
        return cell
    }
    func addRightBarButtons()
    {
        let filterBtn = UIButton()
        filterBtn.tintColor = .white
        filterBtn.setImage(UIImage(named: "filterIcon"), for: .normal)
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
                self.filteredContactArray = contactsArray
               // tableView.reloadData()
            }
            if #available(iOS 13.0, *) {
                applySnapShot(array: filteredContactArray ?? [] , animating: true)
            } else {
                // Fallback on earlier versions
                tableView.reloadData()
            }
            
        }
        present(vc, animated: true, completion: nil)
    }

}
extension HomeVC : UITableViewDataSource , UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredContactArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return prepareTableViewCell(tableView: tableView, row: indexPath.row)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SinglecontactDetailsVC") as! SinglecontactDetailsVC
        vc.contactDetails = filteredContactArray?[indexPath.row]
        vc.editBtnCompletion = {[unowned self] (flag) in
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "UpdateProfileDetailsVC") as! UpdateProfileDetailsVC
            vc.isCurrentUser = false
            vc.contactDetail = filteredContactArray?[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
        //    vc.definesPresentationContext = false
      
        if #available(iOS 13.0, *) {
            vc.view.backgroundColor = UIColor.clear
            vc.modalPresentationStyle = .automatic
        } else {
            // Fallback on earlier versions
          
            vc.modalPresentationStyle = .fullScreen
            vc.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
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
        self.filteredContactArray = contactsArray
        if #available(iOS 13.0, *)
        {
            applySnapShot(array: filteredContactArray ?? [] , animating: true)
        }else {
            tableView.reloadData()
        }
 
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty  else { self.filteredContactArray = contactsArray; if #available(iOS 13.0, *)
        {
            applySnapShot(array: filteredContactArray ?? [] , animating: true)
        }else {
            tableView.reloadData()
        }; return }
        
        self.filteredContactArray = contactsArray?.filter({ user -> Bool in
            return user.empName?.lowercased().contains(searchText.lowercased()) ?? false || user.empDesignation?.lowercased().contains(searchText.lowercased()) ?? false
        })
        if #available(iOS 13.0, *)
        {
            applySnapShot(array: filteredContactArray ?? [] , animating: true)
        }else {
            tableView.reloadData()
        }
 
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }//
}

