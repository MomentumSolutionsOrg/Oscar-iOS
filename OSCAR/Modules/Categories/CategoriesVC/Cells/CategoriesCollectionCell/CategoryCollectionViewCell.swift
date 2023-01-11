//
//  CategoryCollectionViewCell.swift
//  OSCAR
//
//  Created by Momentum Solutions Co. on 28/06/2021.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var subCategoryImage: RoundedImageView!
    @IBOutlet weak var subCategoryNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.cornerRadius = 15
    }
    
    func configure(with subcategory:ChildCategory?){
        subCategoryNameLabel.text = subcategory?.name
        self.subCategoryImage.setImage(with: subcategory?.image ?? "")
    }

}
