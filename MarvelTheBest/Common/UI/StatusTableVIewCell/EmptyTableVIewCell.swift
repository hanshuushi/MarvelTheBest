//
//  EmptyTableVIewCell.swift
//  MarvelTheBest
//
//  Created by 范舟弛 on 2018/3/15.
//  Copyright © 2018年 范舟弛. All rights reserved.
//

import Foundation

class EmptyTableVIewCell: UITableViewCell {
    let stackView: UIStackView
    
    let tagImageView: UIImageView
    
    let tagLabel: UILabel
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        tagImageView = UIImageView(image: UIImage(named: "noresults"))
        
        tagLabel = UILabel()
        
        tagLabel.text = "No Results Found"
        tagLabel.font = ViewFactory.condensedBold(of: 17)
        tagLabel.textColor = UIColor.white
        
        stackView = UIStackView(arrangedSubviews: [tagImageView, tagLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 15
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(stackView)
        
        self.backgroundColor = .clear
        self.selectionStyle = .none

        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addConstraints([NSLayoutConstraint(item: stackView,
                                                     attribute: .centerX,
                                                     relatedBy: .equal,
                                                     toItem: self.contentView,
                                                     attribute: .centerX,
                                                     multiplier: 1.0,
                                                     constant: 0),
                                  NSLayoutConstraint(item: stackView,
                                                     attribute: .centerY,
                                                     relatedBy: .equal,
                                                     toItem: self.contentView,
                                                     attribute: .centerY,
                                                     multiplier: 1.0,
                                                     constant: 0)])
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//        stackView.frame = self.contentView.bounds
//    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

