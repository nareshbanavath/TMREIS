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
    func convertBase64StringToImage() -> UIImage {
        let imageData = Data.init(base64Encoded: self, options: .ignoreUnknownCharacters)
        let image = UIImage(data: imageData!)
        return image!
    }

}
extension UIImage
{
    func convertImageToBase64String () -> String {
        return self.jpegData(compressionQuality: 1)?.base64EncodedString() ?? ""
    }
}
