//
//  LoadingTableViewCell.swift
//  MarvelTheBest
//
//  Created by 范舟弛 on 2018/3/14.
//  Copyright © 2018年 范舟弛. All rights reserved.
//

import Foundation

class LoadingTableViewCell: UITableViewCell {
    
    let loadingView: LatteTime
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        loadingView = LatteTime()
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .clear
        
        self.contentView.addSubview(loadingView)
        
        loadingView.play()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        loadingView.center = self.contentView.center
    }
    
}
