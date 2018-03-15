//
//  HomeHeroTableViewCell.swift
//  MarvelTheBest
//
//  Created by 范舟弛 on 2018/3/14.
//  Copyright © 2018年 范舟弛. All rights reserved.
//

import Foundation
//import Q

class HomeHeroTableViewCell: UITableViewCell {
    
    var heroId: Int? = nil
    
    let heroNameLabel: UILabel
    
    let heroDescLabel: UILabel
    
    let heroImageBackgroudView: UIImageView
    
    let gradientLayer: CAGradientLayer
    
    var dataTast: URLSessionDataTask? = nil
    
    let favButton: UIButton
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        heroId = nil
        
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
        heroNameLabel.font = ViewFactory.condensedBold(of: 24)
        heroNameLabel.textColor = UIColor.white
        
        heroDescLabel = UILabel()
        heroDescLabel.font = ViewFactory.condensedBold(of: 12)
        heroDescLabel.textColor = UIColor.white
        heroDescLabel.numberOfLines = 2
        
        heroImageBackgroudView = UIImageView()
        heroImageBackgroudView.contentMode = .scaleAspectFill
        heroImageBackgroudView.layer.cornerRadius = 3
        heroImageBackgroudView.layer.masksToBounds = true
        
        gradientLayer = CAGradientLayer()
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.colors = [UIColor.black.withAlphaComponent(0.7).cgColor, UIColor.black.withAlphaComponent(0.0).cgColor]
        
        heroImageBackgroudView.layer.addSublayer(gradientLayer)
        
        favButton = UIButton()
        
        favButton.setImage(UIImage(named: "favorite_4"),
                           for: .normal)
        favButton.setImage(UIImage(named: "favorite_3"),
                           for: .selected)
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        
        self.backgroundColor = UIColor.clear
        
        self.contentView.addSubview(heroImageBackgroudView)
        self.contentView.addSubview(heroNameLabel)
        self.contentView.addSubview(heroDescLabel)
        self.contentView.addSubview(favButton)
        
        NotificationCenter
            .default
            .addObserver(self,
                         selector: #selector(HomeHeroTableViewCell.favoriteManagerChangeFavNotification(_:)),
                         name: Notification.Name.FavoriteManagerChangeFavNotification,
                         object: nil)
    }
    
    @objc func favoriteManagerChangeFavNotification(_ notification: Notification) {
        guard let id = notification.userInfo?["id"] as? Int,
            id == heroId,
            let isFaved = notification.userInfo?["isFav"] as? Bool else {
            return
        }
        
        favButton.isSelected = isFaved
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if self.contentView.bounds.width < 80 {
            return
        }
        
        heroNameLabel.frame.origin = CGPoint(x: 40, y: 26)
        heroNameLabel.sizeToFit()
        
        let labelWidth = self.contentView.bounds.width - 80
        
        if heroNameLabel.bounds.width > labelWidth {
            heroNameLabel.frame.size.width = labelWidth
        }
        
        heroDescLabel.frame.origin = CGPoint(x: 40, y: heroNameLabel.frame.maxY + 5)
        heroDescLabel.frame.size = heroDescLabel.sizeThatFits(CGSize(width: labelWidth, height: CGFloat.greatestFiniteMagnitude))
        
        heroImageBackgroudView.frame = CGRect(x: 25,
                                              y: 10,
                                              width: self.contentView.bounds.width - 50,
                                              height: self.contentView.bounds.height - 20)
        
        gradientLayer.frame = CGRect(x: 0, y: 0, width: heroImageBackgroudView.bounds.width / 2.0, height: heroImageBackgroudView.bounds.height)
        
        favButton.frame = CGRect(x: heroImageBackgroudView.frame.maxX - 50,
                                 y: heroImageBackgroudView.frame.maxY - 44,
                                 width: 50,
                                 height: 44)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

extension HomeHeroTableViewCell: ImageLoader {
    func setImage(_ image: UIImage?) {
        heroImageBackgroudView.image = image
    }
    
    static func getPlaceHolderImage() -> UIImage? {
        return UIImage(named: "loading")
    }
}
