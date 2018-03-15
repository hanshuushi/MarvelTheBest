//
//  HeroTabItemTableViewCell.swift
//  MarvelTheBest
//
//  Created by 范舟弛 on 2018/3/15.
//  Copyright © 2018年 范舟弛. All rights reserved.
//

import Foundation

class HeroTabItemTableViewCell: UITableViewCell, ImageLoader {
    
    let itemImageView: UIImageView
    
    let itemLabel: UILabel
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        itemImageView = UIImageView()
        itemImageView.contentMode = .scaleAspectFill
        itemImageView.clipsToBounds = true
        
        itemLabel = UILabel()
        itemLabel.numberOfLines = 0
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        
        self.backgroundColor = UIColor.clear
        
        self.contentView.addSubview(itemImageView)
        self.contentView.addSubview(itemLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        itemImageView.frame = CGRect(x: 26,
                                     y: 18,
                                     width: 96,
                                     height: self.contentView.bounds.height - 36)
        
        itemLabel.frame.origin = CGPoint(x: 134, y: 26)
        itemLabel.frame.size = itemLabel.sizeThatFits(CGSize(width: self.contentView.bounds.width - 159,
                                                             height: CGFloat.greatestFiniteMagnitude))
        
        if itemLabel.frame.size.height > itemImageView.bounds.height - 16 {
            itemLabel.frame.size.height = itemImageView.bounds.height - 16
        }
    }
    
    func set(name: String, desc: String) {
        let attributedString = NSMutableAttributedString(string: name,
                                                         attributes: [NSAttributedStringKey.font: ViewFactory.helveticaNeue(of: 12), NSAttributedStringKey.foregroundColor: UIColor.white])
        
        if desc != "" {
            attributedString.append(NSAttributedString(string: "\n",
                                                       attributes: [NSAttributedStringKey.font: ViewFactory.helveticaNeue(of: 8), NSAttributedStringKey.foregroundColor: UIColor.white]))
            
            attributedString.append(NSAttributedString(string: desc,
                                                       attributes: [NSAttributedStringKey.font: ViewFactory.helveticaNeue(of: 12), NSAttributedStringKey.foregroundColor: UIColor.white.withAlphaComponent(0.7)]))
        }
        
        itemLabel.attributedText = attributedString
        itemLabel.lineBreakMode = .byTruncatingTail
        itemLabel.numberOfLines = 0
    }
    
    var dataTast: URLSessionDataTask? = nil
    
    func setImage(_ image: UIImage?) {
        itemImageView.image = image
    }
    
    static let grayImage: UIImage? = {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        
        guard let ctx = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            
            return nil
        }
        
        ctx.addPath(CGPath.init(rect: CGRect.init(x: 0, y: 0, width: 1, height: 1), transform: nil))
        ctx.setFillColor(red: 216.0 / 255.0, green: 216.0 / 255.0, blue: 216.0 / 255.0, alpha: 1.0)
        ctx.fillPath()
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image
    }()
    
    static func getPlaceHolderImage() -> UIImage? {
        return grayImage
    }
}
