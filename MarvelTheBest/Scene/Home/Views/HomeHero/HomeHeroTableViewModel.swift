//
//  HomeHeroTableViewModel.swift
//  MarvelTheBest
//
//  Created by 范舟弛 on 2018/3/14.
//  Copyright © 2018年 范舟弛. All rights reserved.
//

import Foundation

class HomeHeroTableViewModel: NSObject, ViewModel {
    
    let heroId: Int
    
    let heroName: String
    
    let heroDesc: String
    
    let heroImage: URL?
    
    var cellHeight: CGFloat {
        return 93
    }
    
    init(model: API.Character) {
        heroId      =   model.id
        heroName    =   model.name
        heroDesc    =   model.description
        heroImage   =   model.thumbnail.url
        
        super.init()
    }
    
    func bind(to view: HomeHeroTableViewCell) {
        view.heroId = heroId
        
        view.heroNameLabel.text = heroName
        
        view.heroDescLabel.text = heroDesc
        
        if let url = heroImage {
            view.download(from: url)
        } else {
            view.heroImageBackgroudView.image = HomeHeroTableViewCell.getPlaceHolderImage()
        }
        
        view.favButton.addTarget(self,
                                 action: #selector(HomeHeroTableViewModel.favButtonPressed(button:)),
                                 for: UIControlEvents.touchUpInside)
        
        view.favButton.isSelected = FavoriteManager.share.isFav(of: heroId)
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
