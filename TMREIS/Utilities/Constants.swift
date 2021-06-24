//
//  Constants.swift
//  TMREIS
//
//  Created by deep chandan on 27/04/21.
//

import Foundation
import UIKit
import CommonCrypto
struct UserDefaultVars {
    static var RolesArray : [String] = []
    static var userType = "O"
    static var deviceID = UIDevice.current.identifierForVendor?.uuidString
    static var loginData : LoginStruct?
    static var fcmToken = ""
    
}
let serverNotResponding = "Server Not Responding"
let noInternet = "Please check your internet connection"
extension UIViewController {
    func showAlert(message: String , completion : (()->())? = nil)
    {
        let alert = UIAlertController(title: "TMRIES", message:message, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            completion?()
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    func showAlertOkCancel(message: String , completion : (()->())? = nil)
    {
        let alert = UIAlertController(title: "TMRIES", message:message, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            completion?()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alert.addAction(cancelAction)
        alert.addAction(okAction)
       
        self.present(alert, animated: true, completion: nil)
    }
    
    func resetDefaults() {
        
        let defaults = UserDefaults.standard
        //deleteAllData("LocationMaster")
       // deleteAllData("PTMSMaster")
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
//            if key != UserDefaultVars.empRefID//delete all userdefault values except locationMasterData
//            {
//                defaults.removeObject(forKey: key)
//            }
            
        }
        
    }
   
    
    
}
extension String{
    
        func AESEncryption(key: String = "GGC@Virtu000AesC") -> String? {
            
            let keyData: NSData! = (key as NSString).data(using: String.Encoding.utf8.rawValue) as NSData?
            
            let data: NSData! = (self as NSString).data(using: String.Encoding.utf8.rawValue) as NSData?
            
            let cryptData    = NSMutableData(length: Int(data.length) + kCCBlockSizeAES128)!
            
            let keyLength              = size_t(kCCKeySizeAES128)
            let operation: CCOperation = UInt32(kCCEncrypt)
            let algoritm:  CCAlgorithm = UInt32(kCCAlgorithmAES)
            let options:   CCOptions   = UInt32(kCCOptionECBMode + kCCOptionPKCS7Padding)
            
            var numBytesEncrypted :size_t = 0
            
            
            let cryptStatus = CCCrypt(operation,
                                      algoritm,
                                      options,
                                      keyData.bytes, keyLength,
                                      nil,
                                      data.bytes, data.length,
                                      cryptData.mutableBytes, cryptData.length,
                                      &numBytesEncrypted)
            
            if UInt32(cryptStatus) == UInt32(kCCSuccess) {
                cryptData.length = Int(numBytesEncrypted)
                
                var bytes = [UInt8](repeating: 0, count: cryptData.length)
                cryptData.getBytes(&bytes, length: cryptData.length)
                
                var hexString = ""
                for byte in bytes {
                    hexString += String(format:"%02x", UInt8(byte))
                }

                let encryption = hexString.hexadecimal?.base64EncodedString()
                return encryption
               // return hexString
            }
            
            return nil
        }
    }
extension String {

    /// Create `Data` from hexadecimal string representation
    ///
    /// This creates a `Data` object from hex string. Note, if the string has any spaces or non-hex characters (e.g. starts with '<' and with a '>'), those are ignored and only hex characters are processed.
    ///
    /// - returns: Data represented by this hexadecimal string.

    var hexadecimal: Data? {
        var data = Data(capacity: self.count / 2)

        let regex = try! NSRegularExpression(pattern: "[0-9a-f]{1,2}", options: .caseInsensitive)
        regex.enumerateMatches(in: self, range: NSRange(startIndex..., in: self)) { match, _, _ in
            let byteString = (self as NSString).substring(with: match!.range)
            let num = UInt8(byteString, radix: 16)!
            data.append(num)
        }

        guard data.count > 0 else { return nil }

        return data
    }

}
extension UIViewController{
func setupBackButton()
{
    let btn1 = UIButton(type: .custom)
    //  btn1.backgroundColor = UIColor.blue
    btn1.setImage(UIImage(named: "left-arrow"), for: .normal)
    btn1.tintColor = .white
    btn1.frame = CGRect(x: 0, y: 0, width: 25, height: 10)
    btn1.imageEdgeInsets = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 8)
    btn1.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
    self.navigationController?.navigationBar.barTintColor = UIColor.init(red: 68/255, green: 153/255, blue: 102/255, alpha: 1)
    self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    self.navigationController?.navigationBar.isTranslucent = false

    self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btn1)
  //  setupNavigationColor()
    
}
    @objc func backButtonPressed()
    {
        dismiss(animated: true, completion: nil)
        guard let navController = self.navigationController else {return}
        if navController.viewControllers.count == 1
        {
            //go to dashBoard
            guard let vc = UIStoryboard(name: "Officer", bundle: nil).instantiateInitialViewController()else{return}
            self.view.window?.rootViewController = vc
            self.view.window?.becomeKey()
            self.view.window?.makeKeyAndVisible()
        }
        else{
            navController.popViewController(animated: true)
        }
        
    }
}
