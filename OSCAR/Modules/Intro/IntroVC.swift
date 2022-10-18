//
//  IntroVC.swift
//  OSCAR
//
//  Created by Mostafa Samir on 13/12/2021.
//

import UIKit

class IntroVC: UIViewController {

    @IBOutlet weak var sliderCollection: UICollectionView!
    @IBOutlet weak var pageView: UIPageControl!
    
    var counter = 0
    var introImage: [UIImage] = [
        UIImage(named: "App Intro.001.jpeg")!,
        UIImage(named: "App Intro.002.jpeg")!,
        UIImage(named: "App Intro.003.jpeg")!,
        UIImage(named: "App Intro.004.jpeg")!,
        UIImage(named: "App Intro.005.jpeg")!,
        UIImage(named: "App Intro.006.jpeg")!,
        UIImage(named: "App Intro.007.jpeg")!,
        UIImage(named: "App Intro.008.jpeg")!,
        UIImage(named: "App Intro.009.jpeg")!,
        UIImage(named: "App Intro.010.jpeg")!,
        UIImage(named: "App Intro.011.jpeg")!,
        UIImage(named: "App Intro.012.jpeg")!
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    override func viewDidAppear(_ animated: Bool) {
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: "isAppAlreadyLaunchedOnce")
    }
    func setupView(){
        self.sliderCollection.delegate = self
        self.sliderCollection.dataSource = self
        self.sliderCollection.registerCellNib(cellClass: IntroCell.self)
        pageView.numberOfPages = introImage.count
        pageView.currentPage = 0
    }
    @IBAction func skipPressed(_ sender: Any) {
        let howToUseObj = HowToUseVideoVC()
        howToUseObj.flag = 5
        push(howToUseObj)
    }
    @IBAction func nextPressed(_ sender: Any) {
        if counter < introImage.count {
            let index = IndexPath.init(item: counter, section: 0)
            self.sliderCollection.isPagingEnabled = false
            self.sliderCollection.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            pageView.currentPage = counter
            counter += 1
                } else {
                    let howToUseObj = HowToUseVideoVC()
                    howToUseObj.flag = 5
                    push(howToUseObj)
            }
    }
}

// MARK: - UICollectionViewDataSource
extension IntroVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
      }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return introImage.count
      }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(indexPath: indexPath) as IntroCell
        cell.sliderImage.image = introImage[indexPath.row]
        return cell
      }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height + 10)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: 0.0, height: 0.0)
    }
}
//// MARK: - UIPageViewControllerDataSource
//extension IntroVC:  UIPageViewControllerDataSource{
//    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
//        <#code#>
//    }
//    
//    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
//        <#code#>
//    }
//    
//    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
//        return introImage.count
//    }
//
//    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
//        return 0
//    }
//}
