//
//  PinterestTableViewCell.swift
//  OSCAR
//
//  Created by Momentum Solutions Co. on 07/07/2021.
//

import UIKit

class PinterestTableViewCell: UITableViewCell {
    @IBOutlet weak var pinterestCollectionView: UICollectionView! {
        didSet {
            pinterestCollectionView.registerCellNib(cellClass: BannersCollectionViewCell.self)
            pinterestCollectionView.delegate = self
            pinterestCollectionView.dataSource = self
                    if let layout = pinterestCollectionView.collectionViewLayout as? PinterestLayout {
                      layout.delegate = self
                    }
            pinterestCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            
            pinterestCollectionView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        }
    }
    @IBOutlet weak var pinterestCollectionHeight: NSLayoutConstraint!
    
    private var photos = [Slider]()
    private var viewModel = HomeViewModel.init()
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let collection = object as? UICollectionView else { return }
        
        if collection == pinterestCollectionView {
            pinterestCollectionHeight.constant = pinterestCollectionView.contentSize.height
        }
    }
    
    override func removeFromSuperview() {
        super.removeFromSuperview()
        pinterestCollectionView.removeObserver(self, forKeyPath: "contentSize")
    }
    
    
    func configure(with sliders: [Slider], viewModel: HomeViewModel) {
        self.photos = sliders
        self.viewModel = viewModel
        self.pinterestCollectionView.reloadData()
    }
}

//
extension PinterestTableViewCell: UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSize = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right )) / 2
        return CGSize(width: itemSize, height: itemSize)
    }
}

extension PinterestTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(indexPath: indexPath) as BannersCollectionViewCell
        cell.setup(with: photos[indexPath.row])
        print("----\(photos[indexPath.row])")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let banner = photos[indexPath.item]
        
        if let appLink = banner.appLink,
           !appLink.isEmpty {
            viewModel.parse(link: appLink)
        }else if let externalLink = banner.link,
                 !externalLink.isEmpty {
            viewModel.openExternal(link: externalLink)
        }
    }


}

extension PinterestTableViewCell: PinterestLayoutDelegate {
  func collectionView(
      _ collectionView: UICollectionView,
      heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
         
          if let height = photos[indexPath.item].height {
              return height/UIScreen.main.scale
          } else {
              return 0
          }
      }
}
