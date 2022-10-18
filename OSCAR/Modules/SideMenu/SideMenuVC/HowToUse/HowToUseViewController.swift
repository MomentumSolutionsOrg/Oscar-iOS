//
//  HowToUseViewController.swift
//  OSCAR
//
//  Created by Mostafa Samir on 13/12/2021.
//

import DropDown
import BarcodeScanner
import SwiftyOverlay
import UIKit

class HowToUseViewController: BaseViewController, SkipOverlayDelegate{
    
    @IBOutlet weak var homeTableView: UITableView!
    @IBOutlet weak var sideMenuBtn: UIButton!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var profileImage: CircleImageView!
    @IBOutlet weak var branchButton: UIButton!
    @IBOutlet weak var deliveryLocationLabel: UILabel!
    @IBOutlet weak var scanCodeBtn: UIButton!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var languageButton: UIButton!
    
    @IBOutlet weak var homeBtn: UIButton!
    @IBOutlet weak var categoryBtn: UIButton!
    @IBOutlet weak var cartBtn: UIButton!
    @IBOutlet weak var dealsBtn: UIButton!
    @IBOutlet weak var favouriteBtn: UIButton!
    
    private let dropDown = DropDown()
    let viewModel = HomeViewModel()
    var overlay: GDOverlay!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
        setupViewmodel()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        homeBtn.titleLabel?.text = ""
        categoryBtn.titleLabel?.text = ""
        cartBtn.titleLabel?.text = ""
        dealsBtn.titleLabel?.text = ""
        favouriteBtn.titleLabel?.text = ""
        cartBtn.makeRoundCorner(borderColor: UIColor.white, borderWidth: 0.5, cornerRadius: cartBtn.frame.width/2)
        viewModel.getAddresses()
        setupUserData()
    }

    override func viewDidAppear(_ animated: Bool) {
        overlay = GDOverlay()
        
        /////appereance customizations
        overlay.arrowColor = UIColor.red
        overlay.arrowWidth = 2.0
        overlay.lineType = LineType.line_bubble
        overlay.showBorder = false
        overlay.boxBorderColor = UIColor.clear
        overlay.highlightView = false
        overlay.delegate = self

        overlay.delegate = self
        self.onSkipSignal()

    }
    
    func setupTableView() {
        homeTableView.delegate = self
        homeTableView.dataSource = self
        homeTableView.registerCellNib(cellClass: SlidersTableViewCell.self)
        homeTableView.registerCellNib(cellClass: BannerTableViewCell.self)
        homeTableView.registerCellNib(cellClass: PinterestTableViewCell.self)
        homeTableView.tableFooterView = UIView(frame: .zero)
        
    }
    var i = 0
    func onSkipSignal(){
        self.i += 1
        
        if i == 1{
            let attribStr = NSAttributedString(string: "Profile\nالملف الشخصي", attributes: [
                            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20),
                            NSAttributedString.Key.foregroundColor: UIColor.white
                            ])
            overlay.drawOverlay(to: self.profileImage, desc: attribStr, isCircle: false)
        }else if i == 2{
            let attribStr = NSAttributedString(string: "Main Menu\nالقائمة الرئيسية", attributes: [
                            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20),
                            NSAttributedString.Key.foregroundColor: UIColor.white
                            ])
            overlay.drawOverlay(to: self.sideMenuBtn, desc: attribStr, isCircle: false)
        }else if i == 3{
            let attribStr = NSAttributedString(string: "Branch\nالفرع", attributes: [
                            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20),
                            NSAttributedString.Key.foregroundColor: UIColor.white
                            ])
            overlay.drawOverlay(to: self.branchButton, desc: attribStr, isCircle: false)
        }else if i == 4{
            let attribStr = NSAttributedString(string: "Search\nبحث", attributes: [
                            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20),
                            NSAttributedString.Key.foregroundColor: UIColor.white
                            ])
            overlay.drawOverlay(to: self.searchBtn, desc: attribStr, isCircle: false)
        }else if i == 5{
            let attribStr = NSAttributedString(string: "Scan & Go\nالمسح والذهاب", attributes: [
                            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20),
                            NSAttributedString.Key.foregroundColor: UIColor.white
                            ])
            overlay.drawOverlay(to: self.scanCodeBtn, desc: attribStr, isCircle: false)
        }else if i == 6{
            let attribStr = NSAttributedString(string: "Shopping Cart\nعربة التسوق", attributes: [
                            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20),
                            NSAttributedString.Key.foregroundColor: UIColor.white
                            ])
            overlay.drawOverlay(to: self.cartBtn, desc: attribStr, isCircle: false)
        }else if i == 7{
            let attribStr = NSAttributedString(string: "Home Button\nزر الصفحة الرئيسية", attributes: [
                            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20),
                            NSAttributedString.Key.foregroundColor: UIColor.white
                            ])
            overlay.drawOverlay(to: self.homeBtn, desc: attribStr, isCircle: false)
        }else if i == 8{
            let attribStr = NSAttributedString(string: "Categories\nالفئات", attributes: [
                            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20),
                            NSAttributedString.Key.foregroundColor: UIColor.white
                            ])
            overlay.drawOverlay(to: self.categoryBtn, desc: attribStr, isCircle: false)
        }else if i == 9{
            let attribStr = NSAttributedString(string: "Offers\nالعروض", attributes: [
                            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20),
                            NSAttributedString.Key.foregroundColor: UIColor.white
                            ])
            overlay.drawOverlay(to: self.dealsBtn, desc: attribStr, isCircle: false)
        }else if i == 10{
            let attribStr = NSAttributedString(string: "Favorites\nالمفضل", attributes: [
                            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20),
                            NSAttributedString.Key.foregroundColor: UIColor.white
                            ])
            overlay.drawOverlay(to: self.favouriteBtn, desc: attribStr, isCircle: false)
        }else if i == 11{
            pop()
        }
    }
//    @IBAction private func backButtonAction(_ sender: UIButton) {
//        pop()
//    }
//    @IBAction func barcodeButtonTapped(_ sender: Any) {
//        let viewController = BarcodeScannerViewController()
//        viewController.codeDelegate = self
//        viewController.errorDelegate = self
//        viewController.dismissalDelegate = self
//
//        present(viewController, animated: true, completion: nil)
//    }
//    @IBAction func branchButtonTapped(_ sender: Any) {
//        dropDown.show()
//    }
//    @IBAction func searchTapped(_ sender: Any) {
//        push(SearchVC())
//    }
//    @IBAction func sideMenuButtonTapped(_ sender: Any) {
//        navigationController?.pushViewController(SideMenuVC(), animated: true)
//    }
//
//    @IBAction func changeLanguage(_ sender: UIButton) {
//        viewModel.changeLanguage()
//    }
}

fileprivate extension HowToUseViewController {
    func setupViewmodel() {
        setupViewModel(viewModel: viewModel)
        
        viewModel.branchesCompletion = { [weak self] in
            self?.dropDown.dataSource = self?.viewModel.branches.map { $0.title ?? "" } ?? []
            self?.branchButton.setTitle((self?.viewModel.selectedBranch?.title ?? "") + "  ⌄", for: .normal)
            self?.deliveryLocationLabel.text = self?.viewModel.deliveryLocation
        }
        
        viewModel.openSettingCompletion = { [weak self] in
            debugPrint("Location Access Denied")
            self?.showSettingsAlert(title: "", message:"access_location_message".localized)
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
        //profileImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(profileImageTapped)))
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
}


extension HowToUseViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        var banner: Slider?
//        if viewModel.hasBanners {
//            if viewModel.hasSliders {
//               if indexPath.row > 0,
//                  indexPath.row <= viewModel.banners.count {
//                banner = viewModel.banners[indexPath.row - 1]
//               }
//            }else {
//                if indexPath.row >= 0,
//                   indexPath.row < viewModel.banners.count {
//                    banner = viewModel.banners[indexPath.row]
//                }
//            }
//        }
//
//        if let appLink = banner?.appLink,
//           !appLink.isEmpty {
//            viewModel.parse(link: appLink)
//        }else if let externalLink = banner?.link,
//                 !externalLink.isEmpty {
//            viewModel.openExternal(link: externalLink)
//        }
    }
}

extension HowToUseViewController: UITableViewDataSource {
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
        cell.configure(with: viewModel.pinterest,viewModel: viewModel)
        return cell
    }
    
    
}
