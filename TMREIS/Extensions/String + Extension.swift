//
//  String + Extension.swift
//  TMREIS
//
//  Created by naresh banavath on 27/05/21.
//

import Foundation
extension String
{
  func trim() -> String{
    return self.trimmingCharacters(in: .whitespaces)
  }
}
