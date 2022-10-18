//
//  TabBarLoginViewController.swift
//  OSCAR
//
//  Created by Mostafa Samir on 09/08/2021.
//

import UIKit

class TabBarLoginViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    var topTitle = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        titleLabel.text = topTitle
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        let loginViewController = LoginVC()
        let navigationController = UINavigationController(rootViewController: loginViewController)
        navigationController.navigationBar.isHidden = true
        UIApplication.shared.keyWindow?.rootViewController = navigationController
    }
    

}
