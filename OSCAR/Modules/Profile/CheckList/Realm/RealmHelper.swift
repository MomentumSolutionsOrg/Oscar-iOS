//
//  RealmHelper.swift
//  OSCAR
//
//  Created by Mostafa Samir on 08/08/2021.
//

import RealmSwift

class RealmHelper{
    private lazy var realm:Realm = {
        return try! Realm()
    }()
    static let shared = RealmHelper()
    //MARK:- Cart Methods
    func add(checkList: CheckList, checkListItems: [CheckListItem]){
        if !checkList.title.isEmpty {
            try! realm.write {
                realm.add(checkList)
                CurrentUser.shared.checkListCount += 1
            }
        }
        
    }
    
    func deleteItem(item: CheckList) {
        guard let realmItem = realm.objects(CheckList.self).filter({ $0.id == item.id }).first else { return }
        try! realm.write {
            for item in realmItem.items {
                realm.delete(item)
            }
            realm.delete(realmItem)
        }
    }
    
    func deleteAll(){
        let checkLists = realm.objects(CheckList.self)
        try! realm.write {
            for checklist in checkLists {
                realm.delete(checklist)
            }
        }
    }
    
    func edit(checkList: CheckList, with item: CheckListItem?, pinned: Bool? = nil) {
        guard let realmItem = realm.objects(CheckList.self).filter({ $0.id == checkList.id }).first else { return }
        if !checkList.title.isEmpty {
            try! realm.write {
                realmItem.title = checkList.title
                if let pinned = pinned {
                    realmItem.isPinned = pinned
                }
                if let item = item {
                    realmItem.items.append(item)
                }
            }
        }
    }
    
    func changeCheck(for item: CheckListItem, inside checkList: CheckList) {
        guard let toEditChecklist = realm.objects(CheckList.self).filter({ $0.id == checkList.id }).first else { return }
        try! realm.write {
            toEditChecklist.items.first(where: { $0.id == item.id })?.isChecked.toggle()
        }
    }
    
    func getCheckLists()-> Results<CheckList> {
        return realm.objects(CheckList.self)
    }
    
    func getCheckList(with id:Int)-> CheckList? {
        return realm.objects(CheckList.self).filter{ $0.id == id }.first
    }
    
    func isExisting(item: CheckList) ->Bool {
        if (realm.objects(CheckList.self).filter({ $0.id == item.id }).first != nil){
            return true
        } else {
            return false
        }
    }
    
    
    //MARK:- Favorite Methods
    //    func addtoFav(item:FavoriteModel){
    //        if (realm.objects(FavoriteModel.self).filter({ $0.id == item.id }).first == nil){
    //            try! realm.write {
    //                realm.add(item)
    //            }
    //        }
    //    }
    
    //    func removefromFav(item:FavoriteModel) {
    //        if let it = realm.objects(FavoriteModel.self).filter({ $0.id == item.id }).first {
    //            try! realm.write {
    //                realm.delete(it)
    //            }
    //        }
    //    }
    
    //    func getFavorites()-> Results<FavoriteModel> {
    //        return realm.objects(FavoriteModel.self)
    //    }
    //
    //    func isFavorite(item:FavoriteModel)->Bool{
    //        if (realm.objects(FavoriteModel.self).filter({ $0.id == item.id }).first != nil){
    //            return true
    //        } else {
    //            return false
    //        }
    //    }
}
