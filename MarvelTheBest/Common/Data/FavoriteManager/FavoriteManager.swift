//
//  FavoriteManager.swift
//  MarvelTheBest
//
//  Created by 范舟弛 on 2018/3/15.
//  Copyright © 2018年 范舟弛. All rights reserved.
//

import Foundation


extension Notification.Name {
    static var FavoriteManagerChangeFavNotification = Notification.Name("FavoriteManagerChangeFavNotification")
}


class FavoriteManager: NSObject {
    static let share: FavoriteManager = FavoriteManager()
    
    var favoriteList: Set<Int>
    
    let queue: DispatchQueue
    
    func isFav(of characterId: Int) -> Bool {
        return favoriteList.contains(characterId)
    }
    
    func favAction(of characterId: Int, and isFav: Bool) {
        NotificationCenter
            .default
            .post(name: .FavoriteManagerChangeFavNotification,
                  object: nil,
                  userInfo: ["id": characterId,
                             "isFav": isFav])
        
        if isFav {
            if !self.isFav(of: characterId) {
                favoriteList.insert(characterId)
                
                queue.async {
                    UserDefaults.standard.setValue(NSArray(array: self.favoriteList.sorted()),
                                                   forKey: "MyFavorite")
                    UserDefaults.standard.synchronize()
                }
            }
        } else {
            if self.isFav(of: characterId) {
                favoriteList.remove(characterId)
                
                queue.async {
                    UserDefaults.standard.setValue(NSArray(array: self.favoriteList.sorted()),
                                                   forKey: "MyFavorite")
                    UserDefaults.standard.synchronize()
                }
            }
        }
    }
    
    override init() {
        if let list = UserDefaults.standard.value(forKey: "MyFavorite") as? [Int] {
            favoriteList = Set<Int>(list)
        } else {
            favoriteList = Set<Int>()
        }
        
        queue = DispatchQueue(label: "com.latte.marvel.favorite",
                              attributes: .concurrent)

        super.init()
    }
}
