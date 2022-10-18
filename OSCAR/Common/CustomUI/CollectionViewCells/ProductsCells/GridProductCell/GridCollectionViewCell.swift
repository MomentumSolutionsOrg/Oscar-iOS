//
//  GridCollectionViewCell.swift
//  OSCAR
//
//  Created by Momentum Solutions Co. on 27/06/2021.
//

import UIKit

protocol ProductCellDelegate: AnyObject {
    func addToCart(product: Product?)
    func showToastCell(message: String)
}

extension ProductCellDelegate where Self : BaseViewController  {
    func addToCart(product: Product?) {
        guard let product = product else { return }
        self.showLoadingView()
        let parameters = AddToCartParameters(productId:product.id ?? "1",
                                             quantity: 1,
                                             weight: "")
        
        Api().fireRequestWithSingleResponse(urlConvertible: CheckoutProcessApi.addToCart(parameters: parameters), mappingClass: MessageModel.self).get { [weak self] response in
            self?.dismissLoadingView()
            Utils.checkCart()
            self?.showAlert(message: response.message ?? "")
        }.catch {  [weak self] error in
            self?.dismissLoadingView()
            self?.showAlert(message: error.localizedDescription)
        }
    }
    func showToastCell(message:String){
        self.showToast(message: message)
    }
}

class GridCollectionViewCell: UICollectionViewCell {
    
    //Request Logic
    private let api = Api()
    var updateLoadingStatus: (()->())?
    var updateError: ((String)->())?
    var state: State = .empty {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    
    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var discountLabel: UILabel!
    weak var delegate: ProductCellDelegate?
    @IBOutlet weak var addToCartButton: UIButton!
    @IBOutlet weak var outOfStockLabel: UILabel!
    private var product: Product?{
        didSet {
            isWishListed = product?.liked ?? false
        }
    }
    var isWishListed = false
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        outOfStockLabel.text = "out_of_stock".localized
    }
    
    func configureCell(with product:Product) {
        self.product = product
        print(product.liked)
        productImageView.setImage(with: product.images.first?.src ?? "")
        productNameLabel.text = product.name
        if product.discountPrice == "0" {
            discountLabel.text = ""
            productPriceLabel.text = "EGP".localized + " " + (product.regularPrice ?? "")
        } else {
            discountLabel.text = ("EGP".localized + " " + (product.regularPrice ?? ""))
            productPriceLabel.text = "EGP".localized + " " + (product.discountPrice ?? "")
        }
        if product.inStock == "1" {
            addToCartButton.isHidden = false
            outOfStockLabel.isHidden = true
        }else {
            addToCartButton.isHidden = true
            outOfStockLabel.isHidden = false
        }
        if product.liked ?? false {
            favButton.setImage(#imageLiteral(resourceName: "icon-favorite_24px"), for: .normal)
        }else {
            favButton.setImage(#imageLiteral(resourceName: "passion"), for: .normal)
        }
    }
    @IBAction func favButtonTapped(_ sender: Any) {
        if CurrentUser.shared.token != nil {
            isWishListed.toggle()
            if isWishListed {
                favButton.setImage(#imageLiteral(resourceName: "icon-favorite_24px"), for: .normal)
            }else {
                favButton.setImage(#imageLiteral(resourceName: "icon-action-favorite_24px"), for: .normal)
            }
            updateWishList()
        }else {
            delegate?.showToastCell(message: "login_first".localized)
        }
    }
    
    @IBAction func shareButtonTapped(_ sender: Any) {
        Utils.shareProduct(with: product?.id ?? "")
    }
    @IBAction func addToCartButtonTapped(_ sender: Any) {
        delegate?.addToCart(product: product)
    }
    
}
extension GridCollectionViewCell{
    func startRequest<M: Codable>(request: Requestable, mappingClass: M.Type,successCompletion: @escaping((M?) -> Void), showLoading: Bool = true) {
        if showLoading {
            state = .loading
        }
        api.fireRequestWithSingleResponse(urlConvertible: request, mappingClass: M.self).done {[weak self] success in
            self?.state = .populated
            successCompletion(success)
        }.catch {[weak self] error in
            self?.state = .error
            self?.updateError?((error as? MyError)?.message.localized ?? error.localizedDescription.description)
        }
    }
    //WishList Logic Handling
    func updateWishList() {
        if isWishListed {
            addToWishList()
        }else {
            removeFromWishList()
        }
    }
    
    private func addToWishList() {
        startRequest(request: WishListApi.addToWishList(productId: product?.id ?? ""), mappingClass: MessageModel.self) { response in
            print(response?.message ?? "no message")
        }
    }
    private func removeFromWishList() {
        startRequest(request: WishListApi.removeFromWishList(productIds: [product?.id ?? ""]), mappingClass: MessageModel.self) { response in
            print(response?.message ?? "no message")
        }
    }
}
