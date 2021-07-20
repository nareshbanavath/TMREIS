//
//  SchoolCollegeVC.swift
//  TMREIS
//
//  Created by deep chandan on 30/06/21.
//

import UIKit
class SchoolCollegeVC : UIViewController
{
    //MARK:- Properties
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
var filteredSchoolNameArray : [String]?
var districtDataSource : [String]?
var schoolNamesArray : [String] = []
var districtGroupedValues : [String? : [ContactDetailsStruct.Contact]]?
//DiffableDatasource start
@available(iOS 13.0, *)
typealias DataSource = UITableViewDiffableDataSource<Section ,String>
@available(iOS 13.0, *)
typealias SnapShot = NSDiffableDataSourceSnapshot<Section ,String>
@available(iOS 13.0, *)
public lazy var dataSource = makeDataSource()
//DiffableDatasource End
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Contact"
        addRightBarButtons()
        setupBackButton()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.separatorColor = .clear
        districtDataSource = contactsArray?.map({$0.district ?? ""}).uniqued()
        if let contaarray = contactsArray , contaarray.count > 0{
            //grouping by schoolName
            schoolNamesArray = groupBySchoolName(array: contaarray)
            filteredSchoolNameArray = schoolNamesArray
            reloadTableView()
        }
        //filteredContactArray = Dictionary(grouping: contactsArray!, by: {$0.district})
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
    func applySnapShot(array : [String] ,animating : Bool = true)
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
    func groupBySchoolName(array : [ContactDetailsStruct.Contact]) -> [String]
    {
        districtGroupedValues = Dictionary(grouping: array) { (element : ContactDetailsStruct.Contact) in
            return element.schoolName
        }
        var schoolNames : [String] = []
        districtGroupedValues?.keys.forEach({ (key) in
            if let key = key{
                schoolNames.append(key)
            }
        })
        return schoolNames
   
    }
    func reloadTableView()
    {
        if #available(iOS 13.0, *)
        {
            applySnapShot(array: filteredSchoolNameArray ?? [])
        }else{
            tableView.reloadData()
        }
    }
    func prepareTableViewCell(tableView : UITableView,row : Int) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SchoolCollegeCell") as! SchoolCollegeCell
        let item = filteredSchoolNameArray?[row]
        cell.districtLb.text = item
 
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
        vc.designationBtn.isHidden = true
        vc.districtsDataSource = districtDataSource
        vc.completion = { [unowned self](filterKey , value) in
            switch filterKey {
            case .districts:
                
                let filteredData = self.contactsArray?.filter({$0.district == value})
                let schoolNames = groupBySchoolName(array: filteredData ?? [])
                self.filteredSchoolNameArray = schoolNames
                reloadTableView()
            break
            case .designation:
            break
            default:
                self.filteredSchoolNameArray = schoolNamesArray
               // tableView.reloadData()
            break
            }
            if #available(iOS 13.0, *) {
                applySnapShot(array: filteredSchoolNameArray ?? [] , animating: true)
            } else {
                // Fallback on earlier versions
                tableView.reloadData()
            }
            
        }
        present(vc, animated: true , completion: nil)
    }
}
extension SchoolCollegeVC : UITableViewDelegate , UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredSchoolNameArray?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return prepareTableViewCell(tableView: tableView, row: indexPath.row)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let schoolName = filteredSchoolNameArray?[indexPath.row]
        let contactArray = districtGroupedValues?[schoolName]
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        vc.contactsArray = contactArray
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
extension SchoolCollegeVC : UISearchBarDelegate{
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        self.view.endEditing(true)
        searchBarHeightConstraint.constant = 0
        UIView.animate(withDuration: 0.250) {
            self.view.layoutIfNeeded()
        }
        self.filteredSchoolNameArray = schoolNamesArray
        if #available(iOS 13.0, *)
        {
            applySnapShot(array: filteredSchoolNameArray ?? [] , animating: true)
        }else {
            tableView.reloadData()
        }
 
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty  else { self.filteredSchoolNameArray = schoolNamesArray; if #available(iOS 13.0, *)
        {
            applySnapShot(array: filteredSchoolNameArray ?? [] , animating: true)
        }else {
            tableView.reloadData()
        }; return }

        self.filteredSchoolNameArray = schoolNamesArray.filter({ user -> Bool in
            return user.lowercased().contains(searchText.lowercased())
        })
        if #available(iOS 13.0, *)
        {
            applySnapShot(array: filteredSchoolNameArray ?? [] , animating: true)
        }else {
            tableView.reloadData()
        }

    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }//
}
