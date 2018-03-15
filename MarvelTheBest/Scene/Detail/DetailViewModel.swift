//
//  DetailViewModel.swift
//  MarvelTheBest
//
//  Created by 范舟弛 on 2018/3/15.
//  Copyright © 2018年 范舟弛. All rights reserved.
//

import Foundation

class DetailViewModel: NSObject, ViewModel {
    
    let heroId: Int
    
    init(heroId: Int) {
        self.heroId = heroId
        
        super.init()
        
        for i in 0..<4 {
            HttpRequest
                .get(url: "characters/\(self.heroId)/\(DetailViewModel.urlQueryKeys[i])",
                    params: ["limit": 3],
                    success: {
                        (model: API.DataContainer<API.CommonItem>) in
                        
                        self.statusCollection[i] = .success(model.results.map({ HeroTabItemViewModel(model: $0) }))
                        
                        if let observer = self.currentObserver, observer.0 == i {
                            observer.1(self.statusCollection[i])
                        }
                }) { (error) in
                    self.statusCollection[i] = .failed("\(error)")
                    
                    if let observer = self.currentObserver, observer.0 == i {
                        observer.1(self.statusCollection[i])
                    }
            }
        }
    }
    
    var statusCollection: [DetailViewControllerStatus] = [DetailViewControllerStatus].init(repeating: .loading,                                                                          count: 4)
    
    typealias Observer = (Int, (DetailViewControllerStatus) -> Void)
    
    var currentObserver: Observer?
    
    static let urlQueryKeys: [String] = ["comics", "stories", "events", "series"]
    
    func bind(to view: DetailViewController) {
        view.infoTableViewCell.favButton.addTarget(self,
                                                   action: #selector(DetailViewModel.favButtonPressed(button:)),
                                                   for: UIControlEvents.touchUpInside)
        
        view.headerView.tabIndexChanged = {
            [weak view] (tagIndex) in
            
            view?.status = self.statusCollection[tagIndex]
            
            self.currentObserver = (tagIndex, {
                status in
                
                view?.status = status
            })
        }
    }
    
    @objc func favButtonPressed(button: UIButton) {
        if !button.isSelected {
            FavoriteManager.share.favAction(of: heroId, and: true)
            
            button.isSelected = true
        } else {
            FavoriteManager.share.favAction(of: heroId, and: false)
            
            button.isSelected = false
        }
    }
}
