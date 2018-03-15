//
//  HeroInfoTableViewCell.swift
//  MarvelTheBest
//
//  Created by 范舟弛 on 2018/3/15.
//  Copyright © 2018年 范舟弛. All rights reserved.
//

import Foundation

class HeroInfoTableViewCell: UITableViewCell, ImageLoader {
    let heroNameLabel: UILabel
    
    let heroDescLabel: UILabel
    
    let heroImageBackgroudView: UIImageView
    
    let gradientLayer: CAGradientLayer
    
    var dataTast: URLSessionDataTask? = nil
    
    let favButton: UIButton
    
    let triangleImage: UIImageView
    
    static func triangleImage(of size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContext(size)
        
        guard let ctx = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            
            return nil
        }
        
        let path = CGMutablePath()
        
        path.move(to: CGPoint(x: size.width, y: 0))
        path.addLine(to: CGPoint(x: size.width, y: size.height))
        path.addLine(to: CGPoint(x: 0, y: size.height))
        path.closeSubpath()
        
        ctx.addPath(path)
        ctx.setFillColor(red: 29.0 / 255.0,
                         green: 29.0 / 255.0,
                         blue: 29.0 / 255.0,
                         alpha: 1.0)
        
        ctx.fillPath()
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        cancelDownload()
        
        let targets = favButton.allTargets
        
        for target in targets {
            favButton.removeTarget(target,
                                   action: #selector(HomeHeroTableViewModel.favButtonPressed(button:)),
                                   for: UIControlEvents.touchUpInside)
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        heroNameLabel = UILabel()
        heroNameLabel.font = ViewFactory.condensedBold(of: 36)
        heroNameLabel.textColor = UIColor.white
        
        heroDescLabel = UILabel()
        heroDescLabel.font = ViewFactory.condensedBold(of: 12)
        heroDescLabel.textColor = UIColor.white
        heroDescLabel.numberOfLines = 0
        
        heroImageBackgroudView = UIImageView()
        heroImageBackgroudView.contentMode = .scaleAspectFill
        heroImageBackgroudView.clipsToBounds = true
        
        gradientLayer = CAGradientLayer()
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.colors = [UIColor.black.withAlphaComponent(0.0).cgColor, UIColor.black.withAlphaComponent(1.0).cgColor]
        
        heroImageBackgroudView.layer.addSublayer(gradientLayer)
        
        triangleImage = UIImageView()
        
        favButton = UIButton()
        
        favButton.setImage(UIImage(named: "favorite_1"),
                           for: .normal)
        favButton.setImage(UIImage(named: "favorite_2"),
                           for: .selected)
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        
        self.backgroundColor = UIColor.black
        
        self.contentView.addSubview(heroImageBackgroudView)
        self.contentView.addSubview(heroNameLabel)
        self.contentView.addSubview(heroDescLabel)
        self.contentView.addSubview(triangleImage)
        self.contentView.addSubview(favButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setImage(_ image: UIImage?) {
        heroImageBackgroudView.image = image
    }
    
    static func getPlaceHolderImage() -> UIImage? {
        return UIImage(named: "loading")
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        if size.width <= 50 {
            return CGSize.zero
        }
        
        let descHeight = heroDescLabel.sizeThatFits(size).height
        
        return CGSize(width: size.width - 50,
                      height: max(429, 357 + descHeight + 70) + 30)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if self.contentView.bounds.width <= 50 {
            return
        }
        
        heroNameLabel.frame.origin = CGPoint(x: 25, y: 302)
        heroNameLabel.sizeToFit()
        
        let labelWidth = self.contentView.bounds.width - 50
        
        if heroNameLabel.bounds.width > labelWidth {
            heroNameLabel.frame.size.width = labelWidth
        }
        
        heroDescLabel.frame.origin = CGPoint(x: 25, y: 357)
        heroDescLabel.frame.size = heroDescLabel.sizeThatFits(CGSize(width: labelWidth, height: CGFloat.greatestFiniteMagnitude))
        
        heroImageBackgroudView.frame = CGRect(x: 0,
                                              y: 0,
                                              width: 392 * 163 / 83,
                                              height: 392)
        heroImageBackgroudView.center.x = self.contentView.bounds.midX
        
        gradientLayer.frame = CGRect(x: 0, y: heroImageBackgroudView.bounds.height - 100, width: heroImageBackgroudView.bounds.width, height: 100)
        
        triangleImage.frame = CGRect(x: 0,
                                     y: self.contentView.bounds.height - 58,
                                     width: self.contentView.bounds.width,
                                     height: 58)
        triangleImage.image = HeroInfoTableViewCell.triangleImage(of: triangleImage.bounds.size)
        
        favButton.frame = CGRect(x: self.contentView.bounds.width - 79,
                                 y: self.contentView.bounds.height - 88,
                                 width: 58,
                                 height: 58)
    }
}
