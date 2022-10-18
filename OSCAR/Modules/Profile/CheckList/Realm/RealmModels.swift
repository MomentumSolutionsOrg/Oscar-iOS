//
//  RealmModels.swift
//  OSCAR
//
//  Created by Mostafa Samir on 08/08/2021.
//

import Foundation
import RealmSwift

class CheckList: Object {
    @objc dynamic var id: Int
    @objc dynamic var title: String
    @objc dynamic var isPinned: Bool
    var items: List<CheckListItem>
    
    init(title: String) {
        id = CurrentUser.shared.checkListCount + 1
        self.title = title
        isPinned = false
        self.items = List<CheckListItem>()
    }
    
    required override init() {
        self.id = 0
        self.title = ""
        self.isPinned = false
        self.items = List<CheckListItem>()
    }
}

class CheckListItem: Object {
    @objc dynamic var id: Int
    @objc dynamic var title: String
    @objc dynamic var isChecked: Bool
    @objc dynamic var isTextFieldHidden = true
    
    init(title: String, checkList: CheckList) {
        if RealmHelper.shared.isExisting(item: checkList) {
            self.id = Int(((RealmHelper.shared.getCheckList(with: checkList.id)?.items.count ?? 0) + 1).description + checkList.id.description) ?? 1
        }else {
            self.id = 1
        }
        
        self.title = title
        self.isChecked = false
    }
    
    required override init() {
        self.id = 0
        self.title = ""
        self.isChecked = false
    }
}
