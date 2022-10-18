//
//  AddressInformationViewController.swift
//  OSCAR
//
//  Created by Mostafa Samir on 02/08/2021.
//

import UIKit

class AddressInformationViewController: BaseViewController {
    
    @IBOutlet weak var titleTextField: GeneralTextField!
    @IBOutlet weak var nameTextField: GeneralTextField!
    @IBOutlet weak var phoneTextField: GeneralTextField!
    @IBOutlet weak var landlineTextField: GeneralTextField!
    @IBOutlet weak var streetTextField: GeneralTextField!
    @IBOutlet weak var buildingNumberTextField: GeneralTextField!
    @IBOutlet weak var floorNumberTextField: GeneralTextField!
    @IBOutlet weak var apartmentNumberTextField: GeneralTextField!
    @IBOutlet weak var areaTextField: GeneralTextField!
    @IBOutlet weak var cityTextField: GeneralTextField!
    @IBOutlet weak var setDefaultButton: UIButton!
    
    
    var viewModel: AddressesViewModel?
    private var isDefault = false {
        didSet {
            let image = isDefault ? #imageLiteral(resourceName: "checkImage") : #imageLiteral(resourceName: "emptyCheck")
            setDefaultButton.setImage(image, for: .normal)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupViewModel()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setData()
    }
    
    @IBAction func setAsDefaultButtonTapped(_ sender: Any) {
        isDefault.toggle()
    }
    @IBAction func backButtonTapped(_ sender: Any) {
        pop()
    }
    
    @IBAction func saveAddressButtonTapped(_ sender: Any) {
        if isValid() {
            if phoneTextField.text?.count == 11 {
                let parameters = AddressParameters(name: titleTextField.text ?? "",
                                                   address: streetTextField.text ?? "",
                                                   city: cityTextField.text ?? "",
                                                   phone: phoneTextField.text ?? "",
                                                   isDefault: isDefault ? "1" : "0",
                                                   area: areaTextField.text ?? "",
                                                   coordinates: Utils.defaultCoordinate(),
                                                   apartmentNumber: apartmentNumberTextField.text ?? "",
                                                   buildingNumber: buildingNumberTextField.text ?? "",
                                                   floorNumber: floorNumberTextField.text ?? "",
                                                   landline: landlineTextField.text)
                viewModel?.sendAddress(with: parameters)
            }else {
                showAlert(message: "phone_number_error".localized)
            }
            
        }else {
            showAlert(message: "fill_all_fields".localized)
        }
    }
    
}

fileprivate extension AddressInformationViewController {
    func setupViewModel() {
        guard let viewModel = viewModel else { return }
        setupViewModel(viewModel: viewModel)
    }
    func setupView() {
        titleTextField.textAlignment = .center
    }
    
    func setData() {
        guard let address = viewModel?.selectedAddress else { return }
        titleTextField.text = address.name
        nameTextField.text = address.name
        phoneTextField.text = address.phone
        streetTextField.text = address.address
        buildingNumberTextField.text = address.buildingNumber
        floorNumberTextField.text = address.floorNumber
        apartmentNumberTextField.text = address.apartmentNumber
        areaTextField.text = address.area
        cityTextField.text = address.city
        phoneTextField.delegate = self
        if viewModel?.addressType == .edit {
            isDefault = address.isDefault == 1
        }
    }
    
    func isValid() -> Bool {
        if titleTextField.text == "" ||
            phoneTextField.text == "" ||
            streetTextField.text == "" ||
            buildingNumberTextField.text == "" ||
            floorNumberTextField.text == "" ||
            apartmentNumberTextField.text == "" ||
            areaTextField.text == "" ||
            cityTextField.text == ""  {
            return false
        }else {
            return true
        }
    }
}

extension AddressInformationViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField {
        case phoneTextField:
            // get the current text, or use an empty string if that failed
            let currentText = textField.text ?? ""

            // attempt to read the range they are trying to change, or exit if we can't
            guard let stringRange = Range(range, in: currentText) else { return false }
            // add their new text to the existing text
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

            // make sure the result is under 11 characters
            return updatedText.count <= 11
        default:
            return true
        }
        
    }
}
