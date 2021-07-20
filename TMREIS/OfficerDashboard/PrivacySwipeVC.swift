//
//  PrivacySwipeVC.swift
//  TMREIS
//
//  Created by deep chandan on 30/06/21.
//

import Foundation
import UIKit
import SwipeMenuViewController

class PrivacySwipeVC: UIViewController , SwipeMenuViewDelegate , SwipeMenuViewDataSource {
    
    @IBOutlet weak var swipeMenuView: SwipeMenuView!
    let swipeTitle : [String] = ["Privacy Policy" , "Terms and Conditions" , "Copyright Policy"]
    var swipeControllers: [UIViewController]?
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "TMREIS"
        self.setupBackButton()
        swipeControllers = [prepareWebVC(urlStr: "https://www.cgg.gov.in/mgov-privacy-policy/?depot_name=Centre%20for%20Good%20Governance%20(CGG),%20Govt.%20of%20Telangana") ,prepareWebVC(urlStr: "https://www.cgg.gov.in/mgov-terms-conditions/?depot_name=Centre%20for%20Good%20Governance%20(CGG),%20Govt.%20of%20Telangana&capital=Hyderabad,%20Telangana"),prepareWebVC(urlStr: "https://www.cgg.gov.in/mgov-copyright-policy/?depot_name=Centre%20for%20Good%20Governance%20(CGG),%20Govt.%20of%20Telangana&depot_email=info@cgg.gov.in") ]
        swipeMenuSetup()
        
    }
    func prepareWebVC(urlStr : String) -> UIViewController
    {
        let vc = WebViewController()
        vc.urlStr = urlStr
        return vc
    }
    func swipeMenuSetup()
     {
        swipeMenuView.delegate = self
        swipeMenuView.dataSource = self
         var options: SwipeMenuViewOptions             = .init()
         options.tabView.style                         =  .segmented
         options.tabView.addition = .underline
         options.tabView.additionView.underline.height = 1.0
         options.tabView.additionView.backgroundColor = .white //underline color
         options.tabView.itemView.textColor            = UIColor.white
        options.tabView.backgroundColor = UIColor.red
         options.tabView.itemView.selectedTextColor = .white
         options.tabView.itemView.font = UIFont.systemFont(ofSize: 11 , weight : .medium)
        // options.tabView.
        
       //  options.tabView.itemView.selectedTextColor    = UIColor.blue
        swipeMenuView.reloadData(options: options, default: 0)
     }
    
    func swipeMenuView(_ swipeMenuView: SwipeMenuView, viewControllerForPageAt index: Int) -> UIViewController {
        return (swipeControllers?[index])!
       
    }
    
    func swipeMenuView(_ swipeMenuView: SwipeMenuView, titleForPageAt index: Int) -> String {
        return swipeTitle[index]

    }
    
    func numberOfPages(in swipeMenuView: SwipeMenuView) -> Int {
        return swipeTitle.count

    }

}
