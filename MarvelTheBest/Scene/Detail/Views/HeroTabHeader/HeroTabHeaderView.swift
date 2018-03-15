//
//  HeroTabHeaderView.swift
//  MarvelTheBest
//
//  Created by 范舟弛 on 2018/3/15.
//  Copyright © 2018年 范舟弛. All rights reserved.
//

import Foundation

class HeroTabHeader: UITableViewHeaderFooterView {
    
    let stackView: UIStackView
    
    var tabIndex: Int = 0 {
        didSet {
            tabIndexChanged?(tabIndex)
        }
    }
    
    var tabIndexChanged: ((Int) -> Void)? {
        didSet {
            tabIndexChanged?(tabIndex)
        }
    }
    
    let tagView: UIView
    
    override init(reuseIdentifier: String?) {
        let titles = ["COMICS", "EVENTS", "STORIES", "SERIES"]
        
        let buttons = titles.map({ HeroTabHeader.tabButton(of: $0) })
        
        stackView = UIStackView(arrangedSubviews: buttons)
        stackView.alignment = .fill
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        
        tagView = UIView()
        tagView.backgroundColor = UIColor(red: 240.0 / 255.0,
                                          green: 21.0 / 255.0,
                                          blue: 1.0 / 255.0,
                                          alpha: 1.0)
        
        super.init(reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(stackView)
        self.contentView.addSubview(tagView)
        
        self.contentView.backgroundColor = UIColor(red: 29.0 / 255.0, green: 29.0 / 255.0, blue: 29.0 / 255.0, alpha: 1.0)
        
        for (index, button) in buttons.enumerated() {
            button.tag = index
            button.addTarget(self,
                             action: #selector(HeroTabHeader.tabButtonPressed(sender:)),
                             for: .touchUpInside)
        }
    }
    
    @objc func tabButtonPressed(sender: UIButton) {
        
        UIView.animate(withDuration: 0.25) {
            self.tabIndex = sender.tag
            
            self.setNeedsLayout()
            self.layoutIfNeeded()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        stackView.frame = self.contentView.bounds.insetBy(dx: 26, dy: 0)
        
        if tabIndex < 0 && tabIndex > 4 {
            return
        }
        
        guard let targetView = stackView.arrangedSubviews[tabIndex] as? UIButton,
            let label = targetView.titleLabel else {
                return
        }
        
        let labelFrame = self.contentView.convert(label.bounds,
                                                  from: label)
        
        tagView.frame = CGRect(x: labelFrame.minX + (labelFrame.width - 16) / 2.0,
                               y: labelFrame.maxY + 9,
                               width: 16,
                               height: 4)
    }
    
    static func tabButton(of title: String) -> UIButton {
        let button = UIButton()
        
        button.setAttributedTitle(NSAttributedString(string: title,
                                                     attributes: [NSAttributedStringKey.font: ViewFactory.condensedBold(of: 15),
                                                                  NSAttributedStringKey.foregroundColor: UIColor.white]),
                                  for: .normal)
        
        return button
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
