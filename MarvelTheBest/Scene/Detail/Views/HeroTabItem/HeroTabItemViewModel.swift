//
//  HeroTabItemViewModel.swift
//  MarvelTheBest
//
//  Created by 范舟弛 on 2018/3/15.
//  Copyright © 2018年 范舟弛. All rights reserved.
//

import Foundation

class HeroTabItemViewModel: ViewModel {
    
    let itemId: Int
    
    let itemName: String
    
    let itemDesc: String
    
    let itemImage: URL?
    
    let openURLString: String?
    
    init(model: API.CommonItem) {
        itemId      =   model.id
        itemName    =   model.title ?? ""
        itemDesc    =   model.description ?? ""
        itemImage   =   model.thumbnail?.url
        
        openURLString = model.resourceURI
    }
    
    func bind(to view: HeroTabItemTableViewCell) {
        view.set(name: itemName,
                 desc: itemDesc)
        
        if let url = itemImage {
            view.download(from: url)
        } else {
            view.itemImageView.image = HeroTabItemTableViewCell.getPlaceHolderImage()
        }
    }
}
