//
//  String+Ext.swift
//  Expert
//
//  Created by Mostafa Samir on 30/05/2021.
//

import UIKit

extension String {
    
    var localized: String {
        guard let bundlePath = Bundle.main.path(forResource: LanguageManager.shared.getCurrentLanguage(), ofType: "lproj"),
              let bundle = Bundle(path: bundlePath) else {
            return NSLocalizedString(self, comment: "")
        }
        return NSLocalizedString(self, tableName: nil, bundle: bundle, comment: "")
     }
    
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return nil
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
    
    func widthWithConstrainedHeight(_ height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: height)

        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)

        return boundingBox.width
    }
    
    func strikeThrough()->NSMutableAttributedString {
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: self)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSMakeRange(0, attributeString.length))
        return attributeString
    }
    
    func checkEmailRegex()->Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
    
    func trim() -> String{
        return self.trimmingCharacters(in: .whitespaces)
        
    }
    func isEmptyText() -> Bool{
        return self.trimmingCharacters(in: .whitespaces).isEmpty
        
    }
    
    func validateRegex(regixFormat: String) -> Bool{
        let regixPred =  NSPredicate(format:"SELF MATCHES %@", regixFormat)
        return regixPred.evaluate(with: self)
    }
    
    func generateBarcode() -> UIImage? {
        let data = self.data(using: .ascii)

        if let filter = CIFilter(name: "CICode128BarcodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            //let transform = CGAffineTransform(scaleX: 3, y: 3)

            if let output = filter.outputImage {
                return UIImage(ciImage: output)
            }
        }
        return nil
    }
}
