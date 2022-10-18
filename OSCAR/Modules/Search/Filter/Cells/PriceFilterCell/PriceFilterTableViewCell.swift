//
//  PriceFilterTableViewCell.swift
//  OSCAR
//
//  Created by Momentum Solutions Co. on 08/07/2021.
//

import TTRangeSlider

class PriceFilterTableViewCell: UITableViewCell {
    @IBOutlet weak var rangeSlider: TTRangeSlider! {
        didSet{
            rangeSlider.delegate = self
        }
    }
    weak var delegate:FilterSelectionDelegate?
    
    func showHidePriceRange() {
        rangeSlider.isHidden.toggle()
    }
}

extension PriceFilterTableViewCell: TTRangeSliderDelegate {
    func rangeSlider(_ sender: TTRangeSlider!, didChangeSelectedMinimumValue selectedMinimum: Float, andMaximumValue selectedMaximum: Float) {
        delegate?.didSelectPrice(min: selectedMinimum.description, max: selectedMaximum.description)
    }
}
