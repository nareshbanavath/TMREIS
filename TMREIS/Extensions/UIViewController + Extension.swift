//
//  UIViewController + Extension.swift
//  TMREIS
//
//  Created by naresh banavath on 03/06/21.
//

import UIKit
extension UIViewController
{
  func showFailureAlert(message : String , okCompletion : (()->())? = nil)
  {
    self.showAlert(message: message)
    {
      okCompletion?()
    }
  }
}
 
extension Sequence where Element: Hashable {
    func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}
