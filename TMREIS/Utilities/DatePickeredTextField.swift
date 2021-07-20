//
//  DatePickeredTextField.swift
//  TMREIS
//
//  Created by deep chandan on 17/06/21.
//

import UIKit
protocol DatePickeredTextFieldDelegate : class {
    func didDoneBtnTapped(date : String , textField : UITextField)
}
class DatePickeredTextField : UITextField
{
    let datePicker = UIDatePicker()
    var pickerDelegate : DatePickeredTextFieldDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupDatePicker()
        if #available(iOS 13.0, *) {
            setupIcon()
        } else {
            // Fallback on earlier versions
        }
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
        toolBar.sizeToFit()
        let cancelBtn = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelBtnClicked))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneBtnClicked))
        toolBar.setItems([cancelBtn , flexibleSpace , doneBtn], animated: true)
        inputAccessoryView = toolBar
    }
    @available(iOS 13.0, *)
    func setupIcon()
    {
        let iconImageView = UIImageView(image: UIImage.init(systemName: "calendar"))
        iconImageView.tintColor = .black
        let iconContainerView = UIView(frame: CGRect(x: 10, y: 0, width: 30, height: 30))
        iconContainerView.addSubview(iconImageView)
       // iconContainerView.backgroundColor = .red
        iconImageView.frame = CGRect(x: 5, y: 5, width: 20, height: 20)
        self.leftViewMode = .always
        self.leftView = iconContainerView
    }
    @objc func cancelBtnClicked()
    {
        self.resignFirstResponder()
    }
    @objc func doneBtnClicked()
    {
      //  debugPrint(datePicker.date)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateTxt = formatter.string(from: datePicker.date)
        self.text = dateTxt
        pickerDelegate?.didDoneBtnTapped(date: dateTxt, textField: self)
        self.resignFirstResponder()
    }
}


