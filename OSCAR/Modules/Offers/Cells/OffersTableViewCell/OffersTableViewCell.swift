//
//  OffersTableViewCell.swift
//  OSCAR
//
//  Created by Mostafa Samir on 02/08/2021.
//

import UIKit

class OffersTableViewCell: UITableViewCell {
    @IBOutlet weak var productCollectionView: UICollectionView! {
        didSet {
            setupCollectionView()
        }
    }
    @IBOutlet weak var seeAllButton: UnderlineButton!
    @IBOutlet weak var offerNameLabel: UILabel!
    
    private var products = [Product]() {
        didSet {
            productCollectionView.reloadData()
        }
    }
    private var offerId = "member"
    
    private var index = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(with offer: Offer, indexPath: IndexPath ) {
        self.products = offer.products ?? []
        self.index = indexPath.row
        self.offerNameLabel.text = offer.offerName
        self.offerId = offer.offerId ?? "member"
//        switch indexPath.row {
//        case 0:
//            offerNameLabel.text = "members".localized
//        case 1:
//            offerNameLabel.text = "magazines".localized
//        case 2:
//            offerNameLabel.text = "weekends".localized
//        default:
//            break
//        }
    }
    
    
    private func setupCollectionView() {
        productCollectionView.delegate = self
        productCollectionView.dataSource = self
        productCollectionView.registerCellNib(cellClass: OfferProductCollectionViewCell.self)
    }
    @IBAction func seeAllButtonTapped(_ sender: Any) {
        if let viewController = viewContainingController() as? OffersViewController {
            viewController.seeAllProducts(for: self.offerId)
        }
    }
    
}

extension OffersTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let viewController = viewContainingController() as? OffersViewController {
            viewController.getProduct(at: indexPath.row, for: index)
        }
    }
}

extension OffersTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = products.suffix(3).count
        if count == 0 {
            collectionView.setEmptyView(message: "no_offers_available".localized)
            seeAllButton.isHidden = true
        }else {
            collectionView.restore()
            seeAllButton.isHidden = false
        }
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(indexPath: indexPath) as OfferProductCollectionViewCell
        cell.configureCell(with: products[indexPath.row])
        return cell
    }
}

extension OffersTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.bounds.height
        let width: CGFloat = (collectionView.bounds.width / 3 ) - 12
        if indexPath.row == 1 {
            return CGSize(width: width, height: height)
        }else {
            return CGSize(width: width, height: height * 0.9)
        }
    }
}
