//
//  ProfileViewController.swift
//  OSCAR
//
//  Created by Asmaa Tarek on 27/06/2021.
//

import UIKit

class ProfileViewController: BaseViewController {
    
    // 0 name 1 email 2 phone
    @IBOutlet private var LabelsArray: [UILabel]!
    // 0 payment method 1  track orders 2 checklist
    @IBOutlet private var orderViews: [UIView]!
    @IBOutlet private weak var profileImage: CircleImageView!
    @IBOutlet private weak var tableView: SelfSizedTableView! {
        didSet {
            setupTableView()
        }
    }
    
    @IBOutlet weak var hotlineButton: UIButton! {
        didSet {
            hotlineButton.semanticContentAttribute = .forceRightToLeft
        }
    }
    
    @IBOutlet private weak var orderStack: UIStackView!
    
    private let viewModel = ProfileViewModel()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupStackView()
        setupTargets()
        setupViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        setData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction private func backButtonAction(_ sender: UIButton) {
        pop()
    }
    
    @IBAction private func moreButtonAction(_ sender: UIButton) {
        push(UpdateProfileViewController())
        
    }
    @IBAction private func cartAction(_ sender: UIButton) {
        tabBarController?.selectedIndex = 2
        if let tabBar = tabBarController?.tabBar {
            tabBarController?.tabBar(tabBar, didSelect: (tabBar.items!)[2])
        }
    }
    @IBAction func callHotlineButtonTapped(_ sender: Any) {
        if let url = URL(string: "tel://\(Constants.hotline)/\((LanguageManager.shared.getCurrentLanguage() ?? "en"))"),
           UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        viewModel.logout()
    }
}

fileprivate extension ProfileViewController {
    
    func setupViewModel() {
        setupViewModel(viewModel: viewModel)
        viewModel.logoutCompletion = { [weak self] in
            UserDefaultsManager.shared.removeLocalData()
            self?.setRootViewController(vc: LoginVC())
        }
    }
    func setupStackView() {
        orderStack.makeRoundCorner(borderColor: .clear, borderWidth: 0, cornerRadius: 10)
      
    }
    
    func setData() {
        if let user = CurrentUser.shared.user {
            // 0 name 1 email 2 phone
            LabelsArray[0].text = user.name
            LabelsArray[1].text = user.email
            LabelsArray[2].text = user.phone
            profileImage.setImage(with: user.image ?? "")
        }
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCellNib(cellClass: ProfileCell.self)
    }
    
    func setupTargets() {
        orderViews.forEach { orderView in
            orderView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(orderViewAction)))
        }
        
        profileImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showImagePickerTypeAlert)))
        
    }
    
    
    @objc func showImagePickerTypeAlert() {
        let alert = UIAlertController(title: "", message: "choose_source_type".localized, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "camera".localized, style: .default) {[weak self] _ in
            self?.openImagePicker(isCamera: true)
        }
        
        let photoAction = UIAlertAction(title: "photo".localized, style: .default) {[weak self] _ in
            self?.openImagePicker(isCamera: false)
        }
        let cancelAction = UIAlertAction(title: "cancel".localized, style: .default, handler: nil)
        
        alert.addAction(cameraAction)
        alert.addAction(photoAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    @objc func openImagePicker(isCamera: Bool) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = isCamera ? .camera : .photoLibrary
        present(imagePicker, animated: true)
    }
    
    func checkLastOrder() {
        showLoadingView()
        viewModel.getLastOrder { [weak self] order, error in
            guard let self = self else { return }
            self.dismissLoadingView()
            if let order = order {
                let vc = TrackOrderViewController()
                vc.viewModel.order = order
                self.push(vc)

            } else if let _ = error {
                self.showToast(message: "no_order_to_track".localized)
            }
        }
    }
    
    @objc func orderViewAction(_ gesture: UIGestureRecognizer) {
        switch  gesture.view {
        case orderViews[0]: // open checklist
                push(CheckListViewController())
        case orderViews[1]: // open track orders
            checkLastOrder()
        case orderViews[2]: //open payment
            push(PaymentMethodsViewController())
        default:
            break
        }
    }
}

extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    //push
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch viewModel.profileItems[indexPath.row] {
        case .address:
            push(MyAddressesViewController())
        case .barcode:
            let vc = BarcodeViewController()
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = .crossDissolve
            present(vc)
        case .orders:
            push(MyOrdersViewController())
        case .voucher:
            push(VouchersViewController())
        }
    }
}

extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.profileItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue() as ProfileCell
        cell.configureCell(item: viewModel.profileItems[indexPath.row])
        return cell
    }
}


extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {return}
        profileImage.image = selectedImage
        let profileImageData = selectedImage.jpegData(compressionQuality: 0.5)
        guard let user = CurrentUser.shared.user else { return }
        let params = UpdateProfileParameters(image: profileImageData,
                                             name: user.name,
                                             email: user.email)
        viewModel.updateProfile(with: params)
        picker.dismiss()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss()
    }
}
