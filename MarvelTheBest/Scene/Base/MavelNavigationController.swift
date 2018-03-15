//
//  MavelNavigationController.swift
//  MarvelTheBest
//
//  Created by 范舟弛 on 2018/3/14.
//  Copyright © 2018年 范舟弛. All rights reserved.
//

import Foundation

class MavelNavigationController: CommonNavigationController {
    
    init() {
        super.init(rootViewController: HomeViewController())
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.barTintColor = UIColor.black
        self.navigationBar.isTranslucent = false
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.tintColor = UIColor.white
        
        self.setNavigationBarHidden(true, animated: false)
    }
    
    
    var currentTransitionContainner: UIViewControllerAnimatedTransitioning? = nil
}

extension MavelNavigationController {
    override func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationControllerOperation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == .push, let homeVC = fromVC as? HomeViewController, let detailVC = toVC as? DetailViewController {
            currentTransitionContainner = TransitionContainer(detailViewController: detailVC, homeViewController: homeVC)
            
            return currentTransitionContainner
        }
        
        currentTransitionContainner = nil
        
        return nil
    }
}

