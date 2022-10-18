//
//  UIFonts+Ext.swift
//  Expert
//
//  Created by Mostafa Samir on 30/05/2021.
//

import UIKit

struct AppFontName {
    static let regular = "NotoSans"
    static let bold = "NotoSans-Bold"
    //static let thin = "Poppins-Thin"
    //static let medium = "Poppins-Medium"
    //static let semiBold = "SegoeUI-Semibold"
    //static let light = "Poppins-Light"
}

extension UIFontDescriptor.AttributeName {
    static let nsctFontUIUsage = UIFontDescriptor.AttributeName(rawValue: "NSCTFontUIUsageAttribute")
}

extension UIFont {
    @objc class func poppinsRegular(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.regular, size: size)!
    }

    @objc class func poppinsBold(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.bold, size: size)!

    }
    
    @objc class func poppinsFontWithWeight(ofSize size: CGFloat, weight: UIFont.Weight) -> UIFont {
        
        switch weight {
//        case .light:
//            return UIFont(name: AppFontName.light, size: size)!
//        case .semibold:
//            return UIFont(name: AppFontName.semiBold, size: size)!
        case .bold:
            return UIFont(name: AppFontName.bold, size: size)!
//        case .medium:
//            return UIFont(name: AppFontName.medium, size: size)!
        default:
            return UIFont(name: AppFontName.regular, size: size)!
        }
    }

    @objc convenience init(myCoder aDecoder: NSCoder) {
        guard
            let fontDescriptor = aDecoder.decodeObject(forKey: "UIFontDescriptor") as? UIFontDescriptor,
            let fontAttribute = fontDescriptor.fontAttributes[.nsctFontUIUsage] as? String else {
            self.init(myCoder: aDecoder)
            return
        }
        var fontName = ""
        //print("*******"+fontAttribute)
        switch fontAttribute {
        case "CTFontRegularUsage":
            fontName = AppFontName.regular
        case "CTFontEmphasizedUsage", "CTFontBoldUsage":
            fontName = AppFontName.bold
//        case "CTFontMediumUsage":
//            fontName = AppFontName.semiBold
        case "CTFontLightUsage":
            fontName = AppFontName.regular
//        case "CTFontDemiUsage":
//            fontName = AppFontName.semiBold
//        case "CTFontThinUsage":
//            fontName = AppFontName.thin
        default:
            fontName = AppFontName.regular
        }
        self.init(name: fontName, size: fontDescriptor.pointSize)!
    }

    class func overrideInitialize() {
        guard self == UIFont.self else { return }

        if let systemFontMethod = class_getClassMethod(self, #selector(systemFont(ofSize:))),
            let mySystemFontMethod = class_getClassMethod(self, #selector(poppinsRegular(ofSize:))) {
            method_exchangeImplementations(systemFontMethod, mySystemFontMethod)
        }

        if let boldSystemFontMethod = class_getClassMethod(self, #selector(boldSystemFont(ofSize:))),
            let myBoldSystemFontMethod = class_getClassMethod(self, #selector(poppinsBold(ofSize:))) {
            method_exchangeImplementations(boldSystemFontMethod, myBoldSystemFontMethod)
        }
        
        if let mySystemFontMethod = class_getClassMethod(self, #selector(systemFont(ofSize:weight:))),
            let myFontMethod = class_getClassMethod(self, #selector(poppinsFontWithWeight(ofSize:weight:))) {
            method_exchangeImplementations(mySystemFontMethod, myFontMethod)
        }

        if let initCoderMethod = class_getInstanceMethod(self, #selector(UIFontDescriptor.init(coder:))), // Trick to get over the lack of UIFont.init(coder:))
            let myInitCoderMethod = class_getInstanceMethod(self, #selector(UIFont.init(myCoder:))) {
            method_exchangeImplementations(initCoderMethod, myInitCoderMethod)
        }
    }
}
