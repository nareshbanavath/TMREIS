//
//  UIViewController + Extension.swift
//  TMREIS
//
//  Created by naresh banavath on 03/06/21.
//

import UIKit
extension UIViewController
{
    func isValidEmail(emailStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: emailStr)
    }
  func showFailureAlert(message : String , okCompletion : (()->())? = nil)
  {
    self.showAlert(message: message)
    {
      okCompletion?()
    }
  }
    func callToNumber(phoneNo : String)
    {
        if let url = NSURL(string: "telprompt://\(phoneNo)"), UIApplication.shared.canOpenURL(url as URL) {
            UIApplication.shared.open(url as URL)
        }else {
            self.showAlert(message: "telprompt not allowed in simulator")
        }
    }
    func smsToNumber(phoneNo : String)
    {
        if let url = URL(string: "sms://\(phoneNo)"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }else {
            self.showAlert(message: "Mobile Nuber is not valid")
        }
    }
    func openWhatsApp(phoneNo : String)
    {
        let phoneNumber =  "+91\(phoneNo)" // you need to change this number
        let appURL = URL(string: "https://api.whatsapp.com/send?phone=\(phoneNumber)")!
        if UIApplication.shared.canOpenURL(appURL) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
            }
            else {
                UIApplication.shared.openURL(appURL)
            }
        } else {
            // WhatsApp is not installed
        }
        
    }
}
 
extension Sequence where Element: Hashable {
    func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}
extension UITableView {
    
    func setEmptyMessage(_ message: String , textColor : UIColor = .darkGray , fontSize : Int = 15) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = textColor
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "TrebuchetMS", size: CGFloat(fontSize))
        messageLabel.sizeToFit()
        
        
        self.backgroundView = messageLabel
        self.separatorStyle = .none
    }
    
    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
    
}
