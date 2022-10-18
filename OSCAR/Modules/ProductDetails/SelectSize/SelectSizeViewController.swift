//
//  SelectSizeViewController.swift
//  OSCAR
//
//  Created by Mostafa Samir on 03/08/2021.
//

import UIKit

protocol SizeSelectionDelegate: AnyObject {
    func didSelect(size: String, unit: String, weight: Int)
}

class SelectSizeViewController: UIViewController {
    @IBOutlet weak var sizesTableView: UITableView! {
        didSet {
            sizesTableView.delegate = self
            sizesTableView.dataSource = self
            sizesTableView.layer.cornerRadius = 15
            sizesTableView.clipsToBounds = true
        }
    }
    weak var delegate: SizeSelectionDelegate?
    var sizes = ["250", "500", "750", "1.00", "1.25", "1.5", "1.75", "2.00", "2.25", "2.5"]
    var weightsGrams = [250, 500, 750, 1000, 1250, 1500, 1750, 2000, 2250, 2500]
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func gestureRecognized(_ sender: Any) {
        dismiss()
    }
}


extension SelectSizeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let isKg = indexPath.row >= 3
        delegate?.didSelect(size: sizes[indexPath.row],
                            unit: isKg ? "Kg" : "g",
                            weight: weightsGrams[indexPath.row])
    }
}

extension SelectSizeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sizes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let isKg = indexPath.row >= 3
        
        let cell = UITableViewCell()
        cell.textLabel?.text = sizes[indexPath.row] + " " + (isKg ? "Kg" : "g")
        return cell
    }
    
}
