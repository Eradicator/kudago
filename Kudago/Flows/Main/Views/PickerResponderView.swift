//
//  PickerResponderView.swift
//  Kudago
//
//  Created by Alexander Polyakov on 22/01/2020.
//  Copyright © 2020 Eradicator_kai. All rights reserved.
//

import UIKit

final class PickerResponderView: UITextField {
    var date = Date() {
        didSet {
            datePicker.date = date
        }
    }
    
    override var inputView: UIView? {
        get { return datePicker }
        set {}
    }
    
    override var inputAccessoryView: UIView? {
        get { return datePickerToolbar }
        set {}
    }
    
    private let minDate: Date
    private let maxDate: Date
    private let onDatePicked: (Date) -> ()
    init(minDate: Date, maxDate: Date, onDatePicked: @escaping (Date) -> ()) {
        self.minDate = minDate
        self.maxDate = maxDate
        self.onDatePicked = onDatePicked
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.minimumDate = minDate
        picker.maximumDate = maxDate
        return picker
    }()
    
    private lazy var datePickerToolbar: UIView = {
        let view = UIToolbar(frame: CGRect(x: 0, y: 0, width: 0, height: 48))
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTapAccessoryDone))
        let cancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapAccessoryCancel))
        let today = UIBarButtonItem(title: "Today", style: .plain, target: self, action: #selector(didTapAccessoryToday))
        view.items = [done, today, cancel]
        view.sizeToFit()
        return view
    }()

    @objc
    private func didTapAccessoryDone() {
        onDatePicked(datePicker.date)
        _ = resignFirstResponder()
    }
   
    @objc
    private func didTapAccessoryToday() {
        datePicker.date = Date()
    }
   
    @objc
    private func didTapAccessoryCancel() {
        _ = resignFirstResponder()
    }
}
