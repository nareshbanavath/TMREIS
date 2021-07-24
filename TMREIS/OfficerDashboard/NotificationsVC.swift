//
//  NotificationsVC.swift
//  TMREIS
//
//  Created by Haritej on 02/05/21.
//

import UIKit

class NotificationsVC: UIViewController, UITableViewDataSource,DatePickeredTextFieldDelegate {

    @IBOutlet weak var txt_FromDate: DatePickeredTextField!
    {
        didSet{
            txt_FromDate.pickerDelegate = self
        }
    }
    @IBOutlet weak var txt_ToDate: DatePickeredTextField!
    {
        didSet{
            txt_ToDate.pickerDelegate = self
        }
    }
    @IBOutlet weak var tableView : UITableView!
    var tableViewDataSource : [NotificationStruct.Datum]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        self.title = "Notifications"
        setupBackButton()
   
    }
    func getNotifications()
    {
        guard Reachability.isConnectedToNetwork() else {self.showAlert(message: noInternet);return}
        NetworkRequest.makeRequest(type: NotificationStruct.self, urlRequest: Router.getNotifications(strDate: txt_FromDate.text ?? "", endDate: txt_ToDate.text ?? "")) { [weak self](result) in
            
            switch result
            {
            case .success(let data):
                guard data.statusCode == 200 else {self?.showAlert(message: data.statusMessage);return}
                self?.tableViewDataSource = data.data
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let err):
                print(err.localizedDescription)
                self?.showAlert(message: err.localizedDescription)
            
            }
        }
    }
    //Datepickered Delegate
    func didDoneBtnTapped(date: String, textField: UITextField) {
        print(date)
        switch textField {
        case txt_FromDate:
            txt_ToDate.text?.removeAll()
        default:
            getNotifications()
        }
    }
    //TableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableViewDataSource?.count == 0
        {
            tableView.setEmptyMessage("No records found")
        }
        else
        {
            tableView.restore()
        }
        return tableViewDataSource?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationsTBCell") as! NotificationsTBCell
        cell.Lb_EmpName.text = tableViewDataSource?[indexPath.row].empName
        cell.Lb_bodyText.text = tableViewDataSource?[indexPath.row].body
        return cell
    }

}
// MARK: - NotificationStruct
struct NotificationStruct: Codable {
    let success: Bool
    let statusMessage: String
    let statusCode: Int
    let data: [Datum]?
   

    enum CodingKeys: String, CodingKey {
        case success
        case statusMessage = "status_Message"
        case statusCode = "status_Code"
        case data
    }
    // MARK: - Datum
    struct Datum: Codable {
        let sentDate, empName, body, title: String
        let phoneNo: String
    }
}


