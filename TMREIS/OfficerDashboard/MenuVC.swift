//
//  MenuVC.swift
//  TMREIS
//
//  Created by deep chandan on 29/04/21.
//

import UIKit
import SideMenuSwift
import SafariServices
class MenuVC: UIViewController {
    @IBOutlet weak var tableView:UITableView!
    var menuArray : [TBLViewItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        sideMenuController?.delegate = self
        setupArrayForMenuItems()
        self.tableView.contentInset = UIEdgeInsets(top: -50, left: 0, bottom: 0, right: 0)

       // menuArray = menuArray.filter({$0.count != 0})
        tableView.reloadData()
        
    }
    
    func setupArrayForMenuItems(){
        self.menuArray = [
            //Services
            TBLViewItem(labelName: "Home", iconName: "home", storyBoardName: "Officer", vcName: "HomeVC"),
            TBLViewItem(labelName: "Notifications", iconName: "comment", storyBoardName: "Officer", vcName: "NotificationsVC"),
            TBLViewItem(labelName: "Download Masters", iconName: "dataStore", storyBoardName: "Officer", vcName: "DownloadMastersVC"),
            TBLViewItem(labelName: "Add contact", iconName: "addmember", storyBoardName: "Officer", vcName: "AddmemberVC"),
            TBLViewItem(labelName: "Edit Profile", iconName: "edit", storyBoardName: "Officer", vcName: "UpdateProfileDetailsVC"),
            TBLViewItem(labelName: "Privacy Policy", iconName: "privacy", storyBoardName: "Officer", vcName: "PrivacySwipeVC"),
            TBLViewItem(labelName: "Broadcast", iconName: "broadcast", storyBoardName: "Officer", vcName: "BroadcastVC"),
            TBLViewItem(labelName: "Logout", iconName: "logout", storyBoardName: "Officer", vcName: "HomeVC")
        ]
        if UserDefaultVars.loginData?.data?.userType != "A" || !UserDefaultVars.RolesArray.contains("ROLE_ADMIN")
        {
            for _ in 0..<3{
                menuArray.remove(at: 3)
            }
        }
    }
    func pushViewController(item : TBLViewItem)
    {
        let VC = UIStoryboard(name: item.storyBoardName, bundle: nil).instantiateViewController(withIdentifier: item.vcName)
        let navController = UINavigationController(rootViewController: VC)
        navController.navigationBar.titleTextAttributes = [NSMutableAttributedString.Key.foregroundColor : UIColor.white]
        navController.navigationBar.isTranslucent = false
        sideMenuController?.setContentViewController(to: navController)
    }
}
//MARK:- TableView Delegate & Datasource
extension MenuVC : UITableViewDelegate , UITableViewDataSource{


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       // debugPrint(menuArray.count)
        return menuArray.count

}
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell") as! MenuCell
        
        let cellItem = menuArray[indexPath.row]
        cell.lb.text = cellItem.labelName
        cell.icon.image = UIImage(named: cellItem.iconName)
        


        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       let item = menuArray[indexPath.row]
        if item.labelName == "Home"
        {
            if let vc = UIStoryboard(name: "Officer", bundle: nil).instantiateInitialViewController()
            {
                self.view.window?.rootViewController = vc
                self.view.window?.makeKeyAndVisible()
            }
        }
        if item.labelName == "Edit Profile"
        {
            let VC = UIStoryboard(name: item.storyBoardName, bundle: nil).instantiateViewController(withIdentifier: item.vcName) as! UpdateProfileDetailsVC
            VC.isCurrentUser = true
            let navController = UINavigationController(rootViewController: VC)
            navController.navigationBar.titleTextAttributes = [NSMutableAttributedString.Key.foregroundColor : UIColor.white]
            navController.navigationBar.isTranslucent = false
            sideMenuController?.setContentViewController(to: navController)
        } else if item.labelName == "Logout"
        {
            self.showAlert(message: "Do you want to logout from app?", completion: {
                self.resetDefaults()
                 let vc = storyboards.Login.instance.instantiateViewController(withIdentifier: "SigninSwipeupVC")
                let navVc = UINavigationController(rootViewController: vc)
                self.view.window?.rootViewController  = navVc
//                UserDefaults.standard.set(self.serverVersion,forKey: "serverVersion")
//                 UserDefaults.standard.set(self.lastUpdatedDate,forKey: "lastUpdateddate")
                
            })
        }
        else{
              pushViewController(item: item)
        }
        self.sideMenuController?.hideMenu()
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 40))
//        view.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
//        let label = UILabel(frame: CGRect(x: 15.0, y: 0.0, width: view.frame.size.width - 10, height: view.frame.size.height))
//        label.font = UIFont.systemFont(ofSize: 17.0, weight: .semibold)
//        label.text = menuArray[section][0].labelName
//        view.addSubview(label)
//        return view
//    }
//    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
//        if #available(iOS 13.0, *) {
//            view.backgroundColor = UIColor.systemGray6
//        } else {
//            // Fallback on earlier versions
//            view.backgroundColor = UIColor(red: 242/255, green: 242/255, blue: 247/255, alpha: 1.0)
//        }
//    }
    
}
//MARK:- SideMenu & Safari Delegate
extension MenuVC : SFSafariViewControllerDelegate, SideMenuControllerDelegate
{
    func safariViewController(_ controller: SFSafariViewController, didCompleteInitialLoad didLoadSuccessfully: Bool) {
        // debugPrint(didLoadSuccessfully)
    }
    func sideMenuControllerWillRevealMenu(_ sideMenuController: SideMenuController) {
       // self.bgImgView.setupBackgroundImage()
       // self.setupProfile()
    }
    struct TBLViewItem
    {
       // let sectionName : String
        let labelName : String
        let iconName : String
        let storyBoardName : String
        let vcName : String
    }
}
