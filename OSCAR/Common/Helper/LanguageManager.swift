//
//  DataSnapshotExtension.swift
//  ExhibitSmart
//
//  Created by Asmaa Tarek on 17/05/2021.
//

import IQKeyboardManagerSwift

public enum Language: String {
    case arabic = "ar"
    case english = "en"
}

class LanguageManager {
    
    static let shared = LanguageManager()
    
    func getCurrentLanguage() -> String? {
        if let langs = UserDefaults.standard.object(forKey: "AppleLanguages") as? NSArray {
            return (langs[0] as? String ?? "en").split(separator: "-").first?.description
        } else {
            return "en"
        }
    }
    
    func isArabicLanguage() -> Bool {
        guard let language = getCurrentLanguage() else {return false}
        return language == "ar"
    }
    
    @discardableResult
    func changeLanguage(language: String) -> Bool {
        var isChanged = false
        if (getCurrentLanguage() ?? "en") != language {
            UserDefaults.standard.setValue([language], forKey: "AppleLanguages")
            UserDefaults.standard.synchronize()
            Bundle.swizzleLocalization()
            changeSemanticContentAttribute()
            isChanged = true
        }
        IQKeyboardManager.shared.toolbarDoneBarButtonItemText = "done".localized
        return isChanged
    }
    
    func changeSemanticContentAttribute() {
        if isArabicLanguage() {
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
            UIButton.appearance().semanticContentAttribute = .forceRightToLeft
            UITextView.appearance().semanticContentAttribute = .forceRightToLeft
            UITextField.appearance().semanticContentAttribute = .forceRightToLeft
            UITabBar.appearance().semanticContentAttribute = .forceRightToLeft
            UISearchBar.appearance().semanticContentAttribute = .forceRightToLeft
            UILabel.appearance().semanticContentAttribute = .forceRightToLeft
        } else {
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
            UIButton.appearance().semanticContentAttribute = .forceLeftToRight
            UITextView.appearance().semanticContentAttribute = .forceLeftToRight
            UITextField.appearance().semanticContentAttribute = .forceLeftToRight
            UITabBar.appearance().semanticContentAttribute = .forceLeftToRight
            UISearchBar.appearance().semanticContentAttribute = .forceLeftToRight
            UILabel.appearance().semanticContentAttribute = .forceLeftToRight
        }
    }
}

