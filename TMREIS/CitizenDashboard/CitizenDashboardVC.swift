//
//  CitizenDashboardVC.swift
//  TMREIS
//
//  Created by deep chandan on 27/04/21.
//

import UIKit

class CitizenDashboardVC: UIViewController {
        @IBOutlet weak var formView: UIView!
        override func viewDidLoad() {
        super.viewDidLoad()
     let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        formView.addGestureRecognizer(tap)
        formView.isUserInteractionEnabled = true
            self.navigationController?.isNavigationBarHidden = false
            self.title = "TMREIS"
            navigationItem.backButtonTitle = ""
          //  navigationItem.leftBarButtonItem?.tintColor = UIColor.red
            self.navigationController?.navigationBar.tintColor = UIColor.black
            self.navigationController?.navigationBar.backgroundColor = UIColor(red: 64.0/255.0, green: 156.0/255.0, blue: 106.0/255.0, alpha: 1.0)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        navigationItem.backButtonTitle = ""
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        navigationItem.backButtonTitle = ""

    }
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        // debugPrint("Hello World")
        let vc = storyboards.Dashboard.instance.instantiateViewController(withIdentifier: "CitizenDashboardFormVC") as! CitizenDashboardFormVC
        self.navigationController?.pushViewController(vc, animated: true)
      }

}
