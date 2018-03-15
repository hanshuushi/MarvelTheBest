//
//  TransitionContainer.swift
//  MarvelTheBest
//
//  Created by 范舟弛 on 2018/3/15.
//  Copyright © 2018年 范舟弛. All rights reserved.
//

import Foundation

class TransitionContainer: NSObject {
    let detailViewController: DetailViewController
    
    let homeViewController: HomeViewController
    
    let selectedCell: HomeHeroTableViewCell
    
    init?(detailViewController: DetailViewController, homeViewController: HomeViewController) {
        self.detailViewController = detailViewController
        self.homeViewController = homeViewController
        
        guard let indexPath = homeViewController.tableView.indexPathForSelectedRow,
            let cell = homeViewController.tableView.cellForRow(at: indexPath) as? HomeHeroTableViewCell else {
                return nil
        }
        
        self.selectedCell = cell
        
        super.init()
    }
}

extension TransitionContainer: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let selectedImageView = selectedCell.heroImageBackgroudView
        
        let imageViewFrame = selectedImageView.convert(selectedImageView.bounds,
                                                       to: transitionContext.containerView)
        
        
        let imageView = UIImageView(image: selectedImageView.image)
        
        imageView.alpha = 0.0
        
        transitionContext.containerView.addSubview(imageView)
        
        imageView.frame = imageViewFrame
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 3
        imageView.layer.masksToBounds = true
        
        UIView
            .animate(withDuration: 0.25,
                     animations: {
                        imageView.alpha = 1.0
                        
                        self.homeViewController.view.alpha = 0.0
                        
                        imageView.frame = CGRect(x: 0,
                                                 y: 0,
                                                 width: 392 * 163 / 83,
                                                 height: 392)
                        imageView.center.x = transitionContext.containerView.bounds.midX
            }) { (_) in
                transitionContext.containerView.addSubview(self.detailViewController.view)
                
                self.detailViewController.view.alpha = 0.0
                self.detailViewController.view.frame = transitionContext.containerView.bounds
                
                UIView
                    .animate(withDuration: 0.25,
                             animations: {
                                self.detailViewController.view.alpha = 1.0
                                
                                imageView.alpha = 0.0
                    },
                             completion: { (_) in
                                
                                self.homeViewController.view.alpha = 1.0
                                
                                transitionContext.completeTransition(true)
                    })
        }
    }
}
