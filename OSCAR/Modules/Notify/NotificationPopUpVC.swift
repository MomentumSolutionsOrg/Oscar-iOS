//
//  NotificationPopUpVC.swift
//  OSCAR
//
//  Created by Mostafa Samir on 05/01/2022.
//

import UIKit

protocol NotificationPopUpDelegate: AnyObject {
    func dismissViewSelected()
    func openLinkSelected()
}

class NotificationPopUpVC: BaseViewController {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var notificationImage: UIImageView!
    @IBOutlet weak var notificationTitle: UILabel!
    @IBOutlet weak var notificationBody: UILabel!
    
    weak var delegate: NotificationPopUpDelegate?
    var titleString: String?
    var subTitleString: String?
    var imageString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backView.addGestureRecognizer(UIGestureRecognizer(target: self, action: #selector(dismissView)))
        setUpView()
    }
    
    func setUpView(){
        notificationTitle.text = titleString
        notificationBody.text = subTitleString
        notificationImage.setImage(with: imageString ?? "")
    }
    
    @IBAction func dismissTapped(_ sender: Any)
    {
        delegate?.dismissViewSelected()

    }
    @IBAction func openLinkTapped(_ sender: Any)
    {
        delegate?.openLinkSelected()
    }
}
