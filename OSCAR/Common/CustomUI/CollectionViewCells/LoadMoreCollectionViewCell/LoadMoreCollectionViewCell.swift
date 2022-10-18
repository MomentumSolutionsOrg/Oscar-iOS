//
//  LoadMoreCollectionViewCell.swift
//  ExhibitSmart
//
//  Created by Momentum Solutions Co. on 22/06/2021.
//

import UIKit

class LoadMoreCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var indicator: UIActivityIndicatorView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        indicator.startAnimating()
    }

}
