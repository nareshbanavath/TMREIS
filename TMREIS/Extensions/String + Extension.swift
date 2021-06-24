//
//  String + Extension.swift
//  TMREIS
//
//  Created by naresh banavath on 27/05/21.
//

import UIKit
extension String
{
  func trim() -> String{
    return self.trimmingCharacters(in: .whitespaces)
  }
}
extension String {
    func convertBase64StringToImage() -> UIImage? {
        let imageData = Data.init(base64Encoded: self, options: .ignoreUnknownCharacters)
        let image = UIImage(data: imageData!)
        return image
    }
    var isPhoneNumber: Bool {

        let PHONE_REGEX = "^[6-9][0-9]{9}$";
           let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
           let result =  phoneTest.evaluate(with: self)
           return result
    }
}
extension UIImage
{
    func convertImageToBase64String () -> String {
        return self.jpegData(compressionQuality: 1)?.base64EncodedString() ?? ""
    }
}
