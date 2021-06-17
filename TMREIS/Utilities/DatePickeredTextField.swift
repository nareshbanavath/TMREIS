//
//  DatePickeredTextField.swift
//  TMREIS
//
//  Created by deep chandan on 17/06/21.
//

import UIKit
class DatePickeredTextField : UITextField
{
    let datePicker = UIDatePicker()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    func setupDatePicker()
    {
        datePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        inputView = datePicker
        
        let toolBar = UIToolbar()
        let cancelBtn = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelBtnClicked))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneBtnClicked))
        toolBar.items = [cancelBtn , flexibleSpace , doneBtn]
        inputAccessoryView = toolBar
    }
    @objc func cancelBtnClicked()
    {
        self.resignFirstResponder()
    }
    @objc func doneBtnClicked()
    {
        debugPrint(datePicker.date)
        
        self.resignFirstResponder()
    }
}
