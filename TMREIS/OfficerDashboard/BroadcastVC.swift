//
//  BroadcastVC.swift
//  TMREIS
//
//  Created by Haritej on 03/05/21.
//

import UIKit
import GrowingTextView
import DropDown
class BroadcastVC: UIViewController,UITextViewDelegate {
    //MARK:- Properties
    @IBOutlet weak var sendToContainerView: UIView!
    {
        didSet{
//            sendToContainerView.layer.shadowColor = UIColor.gray.cgColor
//            sendToContainerView.layer.shadowOffset = CGSize(width: 0, height: 0)
//            sendToContainerView.layer.shadowRadius = 0.7
//            sendToContainerView.layer.shadowOpacity = 0.7

        }
    }
    @IBOutlet weak var containerViewBottomAnchor: NSLayoutConstraint!
    {
        didSet
        {
            containerViewBottomAnchor.constant = -350
        }
    }
    @IBOutlet weak var charCountLb: UILabel!
    @IBOutlet weak var subjectTF: UITextField!
    @IBOutlet weak var textView: GrowingTextView!
    {
        didSet
        {
            textView.delegate = self
           
            textView.layer.cornerRadius = 5.0
            textView.layer.borderWidth = 1.0
            textView.layer.borderColor = UIColor.darkGray.cgColor
            textView.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var tableView: UITableView!
    {
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
            tableView.separatorStyle = .none
            tableView.tableFooterView = UIView()
            tableView.separatorColor = .clear
        }
    }
    var groups = ["Head Office" , "RLC" , "DMWO" , "School" , "College" , "District Administration" , "Vigilance Team"]
    var coreDataEntity : [CoreDataEntity] = [.HeadOfc_Entity , .RLC_Entity , .DMWO_Entity , .Schools_Entity , .Colleges_Entity , .DistrictAdmin_Entity , .VigilanceTeam_Entity]
    lazy var dropDown = DropDown()
    
    //MARK:- Life Cycle
    
    override func viewDidLoad(){
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        self.title = "Broadcast"
        setupBackButton()
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewdidTap))
//        tapGesture.delegate = self
//        self.view.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        subjectTF.layer.borderWidth = 1
        subjectTF.layer.borderColor = UIColor(named: "Logogreen")?.cgColor
        
        textView.layer.borderColor = UIColor(named: "Logogreen")?.cgColor
        textView.layer.borderWidth = 1.0;
        textView.layer.cornerRadius = 5.0;
    }
    
    
    @objc func viewdidTap()
    {
        containerViewBottomAnchor.constant = -350
        UIView.animate(withDuration: 0.250) {
            self.view.layoutIfNeeded()
        }
    }
    @IBAction func submitBtnClicked(_ sender: UIButton) {
        guard subjectTF.text?.trim() != "" else {self.showAlert(message: "You can't send message without subject");return}
        guard textView.text?.trim() != "" else {self.showAlert(message: "You can't send empty message");return}
        containerViewBottomAnchor.constant = 8
        UIView.animate(withDuration: 0.250) {
            self.view.layoutIfNeeded()
        }
    }
    
    //MARK:- Helper Methods
    
    func openActionSheet(entity : CoreDataEntity , labelName : String)
    {
        let entityData = CoreDataManager.manager.getEntityData(type: ContactDetailsStruct.self, entityName: entity)
        guard let entity = entityData else {self.showAlertOkCancel(message: "\(labelName) data not found, Do you want to Download")
            {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "DownloadMastersVC") as! DownloadMastersVC
            let navVc = UINavigationController(rootViewController: vc)
            self.view.window?.rootViewController = navVc
            self.view.window?.becomeKey()
            self.view.window?.makeKeyAndVisible()
        };return}
        let districts = entity.data?.compactMap({$0.erstDistName}).uniqued()
        let designations = entity.data?.compactMap({$0.empDesignation}).uniqued()
        var isDistrictClicked : Bool = true
       // dropDown.dataSource = ["Name" , "hdsafkl" , "dasmbdsanf" , "jkhasdfjkhasd"]
        dropDown.anchorView = tableView

        let activity = UIAlertController(title: "Choose Group", message: "Select a category to send notification", preferredStyle: .actionSheet)
        let districtAction = UIAlertAction(title: "District", style: .default) {[weak self] (action) in
            print("district clicked")
            isDistrictClicked = true
            self?.dropDown.dataSource = districts!
            self?.dropDown.show()
            
        }
        let designationAction = UIAlertAction(title: "Designation", style: .default) {[weak self] (action) in
            print("designation clicked")
            isDistrictClicked = false
            self?.dropDown.dataSource = designations!
            self?.dropDown.show()
        }
        activity.addAction(districtAction)
        activity.addAction(designationAction)
        activity.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) in
            activity.dismiss(animated: true, completion: nil)
        }))
        present(activity, animated: true, completion: nil)
        
        //TODO:- Selection Action
        dropDown.selectionAction = {[unowned self](index : Int , item : String) in
            print(item)
            self.dropDown.hide()
            var employeeIds : [String] = []
            if isDistrictClicked{
                let empIds = entity.data?.filter({$0.erstDistName == item}).compactMap({$0.empID})
                employeeIds = empIds ?? []
            }
            else {
                let empIds = entity.data?.filter({$0.empDesignation == item}).compactMap({$0.empID})
                employeeIds = empIds ?? []
            }
            sendNotification(arrayOfEmpids: employeeIds)
        }
    }
    //MARK:- Service Call
    func sendNotification(arrayOfEmpids : [String])
    {
        let parameters : [String : Any] = [
            "empId":arrayOfEmpids,
            "isSave":true,
            "fcmtoken":"",
            "deviceType":"IOS",
            "body": textView.text ?? "",
            "title":subjectTF.text ?? "",
            "photopath":""
        ]
        guard Reachability.isConnectedToNetwork() else {self.showAlert(message: noInternet);return}
        NetworkRequest.makeRequest(type: AddEmpContactStruct.self, urlRequest: Router.sendNotification(parameters: parameters)) { [weak self](result) in
            guard let self = self else {return}
            self.containerViewBottomAnchor.constant = -350
            switch result
            {
            
            case .success(let data):
                guard data.statusCode == 200 else {self.showAlert(message: data.statusMessage ?? serverNotResponding);return}
             
                self.showAlert(message: data.statusMessage ?? serverNotResponding){
                    self.subjectTF.text = nil
                    self.textView.text = nil
                    self.view.endEditing(true)
                    self.charCountLb.text = "0/350"
                }
            case .failure(let err):
                print(err.localizedDescription)
                self.showAlert(message: err.localizedDescription)
            }
        }
    }
   //MARK:- TextView Delegate & Datasource
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let max = 350
        let currentStr = textView.text! as NSString
        print(range)
        let newString = currentStr.replacingCharacters(in: range, with: text)
        
        
        if newString.count <= max{
            charCountLb.text = "\(newString.count)/350"}
        return newString.count <= max
    }
}
extension BroadcastVC : UITableViewDataSource , UITableViewDelegate , UIGestureRecognizerDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14.0 , weight: .medium)
        cell.textLabel?.text = groups[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(groups[indexPath.row])
        openActionSheet(entity: coreDataEntity[indexPath.row], labelName: groups[indexPath.row])
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0
    }
    
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
//        if touch.
//        {
//            return false
//        }
//        return true
//    }

}
