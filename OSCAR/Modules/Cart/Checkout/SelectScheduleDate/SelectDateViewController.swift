//
//  SelectDateVC.swift
//  Etbo5ly
//
//  Created by Mostafa Samir on 12/8/20.
//  Copyright © 2020 Mostafa Samir. All rights reserved.
//

import UIKit

protocol DatePickerDelegate:AnyObject {
    func didSelect(date: String, selectedDate: Date)
}

class SelectDateViewController: UIViewController {
    @IBOutlet weak var datePicker: UIDatePicker!
    weak var pickerDelegate:DatePickerDelegate?
    var minDate:Date?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupViews()
    }
    
    func setupViews() {
        let tapGesture = UITapGestureRecognizer(target:self, action: #selector(dismissSelf))
        view.addGestureRecognizer(tapGesture)
        
        datePicker.minimumDate = minDate ?? Date()
    }
    
    
    @IBAction func confirmButtonTapped(_ sender: Any) {
        let dateString = datePicker.date.convertDateToString(format: Constants.Format.fullDate)
        pickerDelegate?.didSelect(date: dateString, selectedDate: datePicker.date)
        dismissSelf()
    }
    
    @objc private func dismissSelf() {
        dismiss(animated: true, completion: nil)
    }
}
