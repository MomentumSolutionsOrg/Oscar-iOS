//
//  HomeVC.swift
//  OSCAR
//  Created by Momentum Solutions Co. on 23/06/2021.
//

import DropDown
import BarcodeScanner
import Foundation

class HomeVC: BaseViewController {
    
    @IBOutlet weak var homeTableView: UITableView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var profileImage: CircleImageView!
    @IBOutlet weak var branchButton: UIButton!
    @IBOutlet weak var deliveryLocationLabel: UILabel!
    
    @IBOutlet weak var languageButton: UIButton!
    private let dropDown = DropDown()
    private(set) var viewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupViewmodel()
      
        viewModel.getAddresses()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        setupUserData()
      
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presentNotification()
    }


    func setupTableView() {
        homeTableView.delegate = self
        homeTableView.dataSource = self
        homeTableView.registerCellNib(cellClass: SlidersTableViewCell.self)
        homeTableView.registerCellNib(cellClass: BannerTableViewCell.self)
        homeTableView.registerCellNib(cellClass: PinterestTableViewCell.self)
        homeTableView.tableFooterView = UIView(frame: .zero)
        
    }
    @IBAction func barcodeButtonTapped(_ sender: Any) {
        let viewController = BarcodeScannerViewController()
        viewController.codeDelegate = self
        viewController.errorDelegate = self
        viewController.dismissalDelegate = self

        present(viewController, animated: true, completion: nil)
    }
    @IBAction func branchButtonTapped(_ sender: Any) {
        dropDown.show()
    }
    @IBAction func searchTapped(_ sender: Any) {
        push(SearchVC())
    }
    @IBAction func sideMenuButtonTapped(_ sender: Any) {
        navigationController?.pushViewController(SideMenuVC(), animated: true)
    }
    
    @IBAction func changeLanguage(_ sender: UIButton) {
        viewModel.changeLanguage()
    }
}

fileprivate extension HomeVC {
    func setupViewmodel() {
        setupViewModel(viewModel: viewModel)
        
        viewModel.branchesCompletion = { [weak self] in
            self?.dropDown.dataSource = self?.viewModel.branches.map { $0.title ?? "" } ?? []
            self?.branchButton.setTitle((self?.viewModel.selectedBranch?.title ?? "") + "  ⌄", for: .normal)
            self?.deliveryLocationLabel.text = self?.viewModel.deliveryLocation
        }
        
        viewModel.openSettingCompletion = { [weak self] in
            guard let self = self else {
                assertionFailure("SELF!")
                return
            }
            debugPrint("Location Access Denied")
            self.showSettingsAlert(title: "", message:"access_location_message".localized)
        }
        
        viewModel.barcodeSearchCompletion = { [weak self] productVC in
            if let productVC = productVC {
                self?.push(productVC)
            }else {
                self?.showToast(message: "product_not_found".localized)
            }
        }
        
        viewModel.updateTableViewCompletion = { [weak self] in
            self?.homeTableView.reloadData()
        }
        
        viewModel.productCompletion = { [weak self] productVC in
            if let productVC = productVC {
                self?.push(productVC)
            }
        }
        
        viewModel.allProductsCompletion = { [weak self] seeAllVC in
            if let seeAllVC = seeAllVC {
                self?.push(seeAllVC)
            }
        }
        
        viewModel.reloadApp = { [weak self] in
            self?.reloadApp()
        }
        
        viewModel.pushDepartments = { [weak self] in
            self?.tabBarController?.selectedIndex = 1
            if let tabBar = self?.tabBarController?.tabBar {
                self?.tabBarController?.tabBar(tabBar, didSelect: (tabBar.items!)[1])
            }
        }
        
        viewModel.pushContactUs = { [weak self] in
            self?.push(ContactUsViewController())
        }
        
        viewModel.pushAboutUS = { [weak self] in
            self?.push(AboutUsViewController())
        }
        viewModel.fetchImages()
        viewModel.fetchPinterestImages()
    }
    func setupView() {
        setupTableView()
        setupDropDown()
        if LanguageManager.shared.isArabicLanguage() {
            languageButton.setImage(#imageLiteral(resourceName: "arabic"), for: .normal)
        } else {
            languageButton.setImage(#imageLiteral(resourceName: "Group 119"), for: .normal)
        }
    }
    
    func setupDropDown() {
        if LanguageManager.shared.isArabicLanguage() {
            dropDown.layer.setAffineTransform(CGAffineTransform(scaleX: -1, y: 1))
            dropDown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
                    // Setup your custom UI components
                    cell.optionLabel.layer.setAffineTransform(CGAffineTransform(scaleX: -1, y: 1))
                }
        }
        dropDown.anchorView = branchButton
        dropDown.direction = .bottom
        dropDown.bottomOffset = CGPoint(x: branchButton.frame.minX, y:branchButton.bounds.height)
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in
            self?.viewModel.selectedBranch = self?.viewModel.branches[index]
            self?.branchButton.setTitle(item + "  ⌄", for: .normal)
        }
    }
    
    func setupUserData() {
        if let user = CurrentUser.shared.user {
            profileImage.backgroundColor = .clear
            userNameLabel.text = user.name
            profileImage.setImage(with: user.image ?? "")
        }
        profileImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(profileImageTapped)))
    }
    
    @objc func profileImageTapped() {
        if CurrentUser.shared.user == nil {
            let tabBarLoginVC = TabBarLoginViewController()
            tabBarLoginVC.topTitle = "Profile".localized
            push(tabBarLoginVC)
        } else {
            push(ProfileViewController())
        }
    }
    
    func reloadApp() {
        let transitionOption: UIView.AnimationOptions =  LanguageManager.shared.isArabicLanguage() ?  .transitionFlipFromRight : .transitionFlipFromLeft
        
        if #available(iOS 13.0, *) {
            guard let window = UIApplication.shared.keyWindowInConnectedScenes else {return}
            window.rootViewController = MainTabBarController()
            UIView.transition(with: window, duration: 0.6, options: transitionOption, animations: {})
            
        } else  {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
            appDelegate.window?.rootViewController = MainTabBarController()
            UIView.transition(with: appDelegate.window!, duration: 0.6, options: transitionOption, animations: {})
        }
    }
    
    func presentNotification() {
        
        do {
            let notificationObj = try UserDefaultsManager.shared.getObject(forKey: .notification, castTo: NotificationObject.self)
            print(notificationObj.image)
            //guard let notification = UserDefaultsManager.shared.getStringForKey(key: .notification), !notification.isEmpty else { return }
            let notificationVC = NotificationPopUpVC()
            notificationVC.modalPresentationStyle = .overCurrentContext
            notificationVC.delegate = self
            notificationVC.imageString = notificationObj.image
            notificationVC.titleString = notificationObj.title
            notificationVC.subTitleString = notificationObj.subTitle
            present(notificationVC, animated: false)
        } catch {
            print(error.localizedDescription)
        }
    }
}


extension HomeVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var banner: Slider?
        if viewModel.hasBanners {
            if viewModel.hasSliders {
                if indexPath.row > 0 {
                    banner = viewModel.banners[indexPath.row - 1]
                }
            } else {
                if indexPath.row >= 0,
                   indexPath.row < viewModel.banners.count {
                    banner = viewModel.banners[indexPath.row]
                }
            }
        }
        
        
        if let appLink = banner?.appLink,
           !appLink.isEmpty {
            viewModel.parse(link: appLink)
        }else if let externalLink = banner?.link,
                 !externalLink.isEmpty {
            viewModel.openExternal(link: externalLink)
        }
    }
}

extension HomeVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 1
        if viewModel.hasSliders {
            count += 1
        }
        if viewModel.hasBanners {
            count += viewModel.banners.count
            
        }
        
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if viewModel.hasSliders,
           indexPath.row == 0 {
            // return slider cell
            let cell = tableView.dequeue() as SlidersTableViewCell
            cell.configureCell(with: viewModel.sliders)
            return cell
        }
        
        if viewModel.hasBanners {
            if viewModel.hasSliders {
               if indexPath.row > 0,
                  indexPath.row <= viewModel.banners.count {
                // return banner cell
                let cell = tableView.dequeue() as BannerTableViewCell
                cell.configureCell(with: viewModel.banners[indexPath.row - 1])
                return cell
               }
            }else {
                if indexPath.row >= 0,
                   indexPath.row < viewModel.banners.count {
                 // return banner cell
                    let cell = tableView.dequeue() as BannerTableViewCell
                    cell.configureCell(with: viewModel.banners[indexPath.row])
                    return cell
                }
            }
        }
        
        // return Pinterest cell
        let cell = tableView.dequeue() as PinterestTableViewCell
        cell.configure(with: viewModel.pinterest, viewModel: viewModel)
        return cell

    }
}

extension HomeVC: NotificationPopUpDelegate {
    func dismissViewSelected() {
        dismiss()
        popToRoot()
        UserDefaultsManager.shared.removeObject(forKey: .notification)
        tabBarController?.selectedIndex = 0
    }
    
    func openLinkSelected() {
        dismiss()
        popToRoot()
        
    }
}
