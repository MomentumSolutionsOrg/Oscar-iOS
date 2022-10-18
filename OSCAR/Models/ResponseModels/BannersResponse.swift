//
//  BannersResponse.swift
//  OSCAR
//
//  Created by Mostafa Samir on 03/08/2021.
//

import Foundation

struct BannersResponse: Codable {
    let banners: [Slider]?
    let imageSlider: [Slider]?
}
