//
//  CheckoutViewController.swift
//  OSCAR
//
//  Created by Mostafa Samir on 09/08/2021.
//

import UIKit
//import MPGSDK

class CheckoutViewController: BaseViewController {
    //MARK: - Address Outlets
    @IBOutlet weak var selectedAddressView: UIView!
    @IBOutlet weak var addressTitleLabel: UILabel!
    @IBOutlet weak var addressStreetLabel: UILabel!
    @IBOutlet weak var addressAreaLabel: UILabel!
    //MARK: - Payment Methods Outlets
    @IBOutlet weak var cashOnDeliveryLabel: UILabel!
    @IBOutlet weak var cashOnDeliveryCheckImageView: UIImageView!
    @IBOutlet weak var cardOnDeliveryLabel: UILabel!
    @IBOutlet weak var cardOnDeliveryCheckImageView: UIImageView!
    @IBOutlet weak var masterCardLabel: UILabel!
    @IBOutlet weak var masterCardImageView: UIImageView!
    //MARK: - Delivery Options Outlets
    
    @IBOutlet weak var deliveryTypesTableView: SelfSizedTableView! {
        didSet {
            setupDeliveryTableView()
        }
    }
    
    //MARK: - Promo Code Outlets
    @IBOutlet weak var promoCodeTextField: GeneralTextField!
    @IBOutlet weak var promoCodeDetailsStackView: UIStackView!
    @IBOutlet weak var promoCodeDiscountLabel: UILabel!
    @IBOutlet weak var promoCodeCalculationLabel: UILabel!
    //MARK: - Order Summary Outlets
    @IBOutlet weak var orderSummaryTableView: SelfSizedTableView! {
        didSet {
            setupTableView()
        }
    }
    @IBOutlet weak var deliveryFeesLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    var viewModel: CheckoutProcessViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupViews()
        setupViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchAddresses()
    }
    func setupViews() {
        viewModel.selectedPaymentType = {
            if CurrentUser.shared.defaultPaymentType == Constants.PaymentMethodTypes.cashOnDelivery.rawValue {
                return .cashOnDelivery
            }else {
                return .cardUponDelivery
            }
        }()
        
        switch viewModel.selectedPaymentType {
        case .cashOnDelivery:
            cashOnDeliveryLabel.textColor = UIColor.blueColor
            cashOnDeliveryCheckImageView.image = #imageLiteral(resourceName: "checkImage")
        case .cardUponDelivery:
            cardOnDeliveryLabel.textColor = UIColor.blueColor
            cardOnDeliveryCheckImageView.image = #imageLiteral(resourceName: "checkImage")
        case .visa:
            masterCardLabel.textColor = UIColor.blueColor
            masterCardImageView.image = #imageLiteral(resourceName: "checkImage")
        }
        deliveryFeesLabel.text = (viewModel.selectedDelivery?.cost ?? "20") + " " + "EGP".localized
        viewModel.selectedDeliveryType = .sameDay
        viewModel.scheduleDate = nil
        totalLabel.text = viewModel.total().description
    }
    
    func showPopUpForScheduleDelivery() {
        let alert = UIAlertController(title: "warning".localized, message: "price_may_change".localized, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK".localized, style: .cancel) { [weak self] _ in
            self?.openDatePicker()
        }
        alert.addAction(okAction)
        present(alert)
    }
    
    func openDatePicker() {
        let pickerViewController = SelectDateViewController()
        pickerViewController.pickerDelegate = self
        pickerViewController.modalPresentationStyle = .overCurrentContext
        present(pickerViewController)
    }
    
    @IBAction func cashOnDeliveryTapped(_ sender: Any) {
        cashOnDeliveryLabel.textColor = UIColor.blueColor
        cashOnDeliveryCheckImageView.image = #imageLiteral(resourceName: "checkImage")
        cardOnDeliveryLabel.textColor = UIColor.blackTextColor
        cardOnDeliveryCheckImageView.image = #imageLiteral(resourceName: "emptyCheck")
        masterCardLabel.textColor = UIColor.blackTextColor
        masterCardImageView.image = #imageLiteral(resourceName: "emptyCheck")
        viewModel.selectedPaymentType = .cashOnDelivery
    }
    @IBAction func cardOnDeliveryTapped(_ sender: Any) {
        cardOnDeliveryLabel.textColor = UIColor.blueColor
        cardOnDeliveryCheckImageView.image = #imageLiteral(resourceName: "checkImage")
        cashOnDeliveryLabel.textColor = UIColor.blackTextColor
        cashOnDeliveryCheckImageView.image = #imageLiteral(resourceName: "emptyCheck")
        masterCardLabel.textColor = UIColor.blackTextColor
        masterCardImageView.image = #imageLiteral(resourceName: "emptyCheck")
        viewModel.selectedPaymentType = .cardUponDelivery
    }
    @IBAction func masterCardTapped(_ sender: Any) {
        masterCardLabel.textColor = UIColor.blueColor
        masterCardImageView.image = #imageLiteral(resourceName: "checkImage")
        cardOnDeliveryLabel.textColor = UIColor.blackTextColor
        cardOnDeliveryCheckImageView.image = #imageLiteral(resourceName: "emptyCheck")
        cashOnDeliveryLabel.textColor = UIColor.blackTextColor
        cashOnDeliveryCheckImageView.image = #imageLiteral(resourceName: "emptyCheck")
        viewModel.selectedPaymentType = .visa
    }

    @IBAction func chooseAddressTapped(_ sender: Any) {
        let selectAddressViewController = SelectAddressViewController()
        selectAddressViewController.modalTransitionStyle = .crossDissolve
        selectAddressViewController.modalPresentationStyle = .overCurrentContext
        selectAddressViewController.addresses = viewModel.addresses
        selectAddressViewController.selectedAddress = viewModel.selectedAddress
        selectAddressViewController.delegate = self
        present(selectAddressViewController)
    }
    @IBAction func applyCodeTapped(_ sender: Any) {
        if let voucherName = promoCodeTextField.text,
           voucherName != "" {
            viewModel.validateVoucher(for: voucherName)
        }
    }
    @IBAction func checkoutButtonTapped(_ sender: Any) {
        if viewModel.isReadyToCheckout() {
            if viewModel.selectedPaymentType == .visa {
                //createSession()
            }else {
                viewModel.checkout()
            }
            
        } else if viewModel.selectedAddress == nil {
            showAlert(message: "select_your_address".localized)
        } else if viewModel.selectedDelivery == nil {
            showAlert(message: "choose_delivery_option".localized)
        }
    }
    @IBAction func backButtonTapped(_ sender: Any) {
        pop()
    }
}

fileprivate extension CheckoutViewController {
    func setupViewModel() {
        setupViewModel(viewModel: viewModel)
        
        viewModel.getAddressesCompletion = { [weak self] in
            if let selectedAddress = self?.viewModel.selectedAddress {
                self?.selectedAddressView.isHidden = false
                self?.addressTitleLabel.text = selectedAddress.name
                self?.addressStreetLabel.text = selectedAddress.address
                self?.addressAreaLabel.text = selectedAddress.area
            }
        }
        
        viewModel.getDeliveryFeesCompletion = { [weak self] in
            guard let self = self else { return }
            self.deliveryFeesLabel.text = (self.viewModel.selectedDelivery?.cost ?? "20") + " " + "EGP".localized
//            self.sameDayPriceLabel.text =  self.viewModel.sameDayPrice + " " + "EGP".localized
//            self.schedulePriceLabel.text =  self.viewModel.schedulePrice + " " + "EGP".localized
//            self.sameDayPriceLabel.isHidden = false
//            self.schedulePriceLabel.isHidden = false
//            self.scheduleView.isHidden = !self.viewModel.hasSchedulePrice
            self.deliveryTypesTableView.reloadData()
        }
        
        viewModel.voucherCompletion = { [weak self] in
            guard let self = self else { return }
            guard let voucher = self.viewModel.voucher else { return }
            let discount = self.viewModel.calculateVoucherDiscount()
            self.promoCodeDetailsStackView.isHidden = false
            if voucher.voucherType == "%" {
                self.promoCodeDiscountLabel.text = (voucher.discountNumber?.description ?? "0") + "%off".localized
                self.promoCodeCalculationLabel.isHidden = false
                self.promoCodeCalculationLabel.text = discount.description + "EGP_off".localized
            }else {
                self.promoCodeDiscountLabel.text = discount.description + "EGP_off".localized
                self.promoCodeCalculationLabel.isHidden = true
            }
            
            self.totalLabel.text = self.viewModel.total().description
        }
    }
    
    func setupTableView() {
        orderSummaryTableView.delegate = self
        orderSummaryTableView.dataSource = self
        orderSummaryTableView.registerCellNib(cellClass: OrderSummaryTableViewCell.self)
    }
    
    func setupDeliveryTableView() {
        deliveryTypesTableView.delegate = self
        deliveryTypesTableView.dataSource = self
        deliveryTypesTableView.registerCellNib(cellClass: DeliveryTypeTableViewCell.self)
    }
}

// MARK: - Delegates Conformation
extension CheckoutViewController: SelectAddressDelegate {
    func didSelect(address: Address) {
        dismiss()
        viewModel.selectedAddress = address
        selectedAddressView.isHidden = false
        addressTitleLabel.text = address.name
        addressStreetLabel.text = address.address
        addressAreaLabel.text = address.area
    }
    
    func addAddressTapped() {
        dismiss()
        // todo open add address
        let vc = AddressInformationViewController()
        let addressViewModel = AddressesViewModel()
        addressViewModel.sendAddressCompletion = { [weak self] in
            if let self = self {
                self.navigationController?.popToViewController(self, animated: true)
                self.viewModel.fetchAddresses()
            }
        }
        vc.viewModel = addressViewModel
        push(vc)
    }
    
    func addOnMapTapped() {
        dismiss()
        // todo open add address
        let vc = ChooseOnMapViewController()
        let addressViewModel = AddressesViewModel()
        addressViewModel.sendAddressCompletion = { [weak self] in
            if let self = self {
                self.navigationController?.popToViewController(self, animated: true)
                self.viewModel.fetchAddresses()
            }
        }
        vc.viewModel = addressViewModel
        push(vc)
    }
}

extension CheckoutViewController: DatePickerDelegate {
    func didSelect(date: String, selectedDate: Date) {
//        scheduleDateLabel.text = date
//        scheduleDateLabel.isHidden = false
//        scheduleTimeLabel.text = selectedDate.convertDateToString(format: Constants.Format.timeFormat)
//        scheduleTimeLabel.isHidden = false
        viewModel.scheduleDate = selectedDate
        dismiss()
    }
}


// MARK: - TableView Delegate & DataSource Conformation

extension CheckoutViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableView {
        case deliveryTypesTableView:
            viewModel.selectedDelivery = viewModel.deliveryFees[indexPath.row]
            if viewModel.selectedDeliveryType == .schedule {
                if viewModel.scheduleDate == nil {
                    showPopUpForScheduleDelivery()
                }else {
                    openDatePicker()
                }
            }
            tableView.reloadData()
        default:
            break
        }
    }
}

extension CheckoutViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case deliveryTypesTableView:
            return viewModel.deliveryFees.count
        default:
            return viewModel.cartProducts.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case deliveryTypesTableView:
            let cell = tableView.dequeue() as DeliveryTypeTableViewCell
            let selection = viewModel.isSelectedFee(at: indexPath)
            cell.configureCell(with: viewModel.deliveryFees[indexPath.row],
                               selection: selection,
                               scheduleDate: viewModel.scheduleDate)
            return cell
        default:
            let cell = tableView.dequeue() as OrderSummaryTableViewCell
            cell.configure(with: viewModel.cartProducts[indexPath.row])
            return cell
        }
        
    }
    
}
