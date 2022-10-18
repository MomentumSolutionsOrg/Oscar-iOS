//
//  SlidersTableViewCell.swift
//  OSCAR
//
//  Created by Momentum Solutions Co. on 07/07/2021.
//

import UIKit

class SlidersTableViewCell: UITableViewCell {
    @IBOutlet weak var sliderImagesCollectionView: UICollectionView!
    @IBOutlet weak var sliderCollectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var pageController: UIPageControl!
    
    private var timer:Timer!
    private var currentPage = 0
    private var sliders = [Slider]() {
        didSet {
            //start timer
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        sliderCollectionViewHeightConstraint.constant = UIScreen.main.bounds.height * 0.25
        sliderImagesCollectionView.dataSource = self
        sliderImagesCollectionView.delegate = self
        sliderImagesCollectionView.registerCellNib(cellClass: SliderCollectionViewCell.self)
    }
    
    func startTimer() {
        timer =  Timer.scheduledTimer(timeInterval: 7.5, target: self, selector: #selector(self.scrollAutomatically), userInfo: nil, repeats: false)
    }

    @objc func scrollAutomatically(_ timer1: Timer) {
        currentPage += 1
        if currentPage == sliders.count * 50 {
            currentPage = 0
            sliderImagesCollectionView.scrollToItem(at: IndexPath(row: currentPage, section: 0), at: .centeredHorizontally, animated: false)
        }else {
            sliderImagesCollectionView.scrollToItem(at: IndexPath(row: currentPage, section: 0), at: .centeredHorizontally, animated: true)
        }
        
    }
    func configureCell(with sliders:[Slider]) {
        self.sliders = sliders
        pageController.numberOfPages = sliders.count
        sliderImagesCollectionView.reloadData()
        startTimer()
    }
    
    override func removeFromSuperview() {
        super.removeFromSuperview()
        timer.invalidate()
    }
}


extension SlidersTableViewCell: UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let viewController = viewContainingController() as? HomeVC {
            if let appLink = sliders[indexPath.row % sliders.count].appLink,
               !appLink.isEmpty {
                viewController.viewModel.parse(link: appLink)
            }else if let externalLink = sliders[indexPath.row % sliders.count].link,
                     !externalLink.isEmpty {
                viewController.viewModel.openExternal(link: externalLink)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
}

extension SlidersTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return
        return sliders.count * 50
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(indexPath: indexPath) as SliderCollectionViewCell
        let slider = sliders[indexPath.row % sliders.count]
        cell.configureCell(with: slider)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        pageController.currentPage = indexPath.row % sliders.count
        currentPage = indexPath.row
        timer.invalidate()
        startTimer()
    }
    
}
