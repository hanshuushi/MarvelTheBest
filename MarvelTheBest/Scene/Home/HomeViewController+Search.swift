//
//  HomeViewController+Search.swift
//  MarvelTheBest
//
//  Created by 范舟弛 on 2018/3/15.
//  Copyright © 2018年 范舟弛. All rights reserved.
//

import Foundation

extension HomeViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.view.insertSubview(maskView, belowSubview: navigationView)
        
        maskView.frame = self.view.bounds
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "\n" {
            
            textField.resignFirstResponder()
            
            searchAction?(searchTextField.text ?? "")
            
            return false
        }
        
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        maskView.removeFromSuperview()
        
        return true
    }
}

extension HomeViewController {
    @objc func textFieldValueChanged(sender: UITextField) {
        let text = sender.text ?? ""
        
        rightButton.setAttributedTitle(NSAttributedString(string: text == "" ? "Cancel" : "Search",
                                                          attributes: [NSAttributedStringKey.font: ViewFactory.condensedBold(of: 15),
                                                                       NSAttributedStringKey.foregroundColor: UIColor.white]),
                                       for: .normal)
    }
    
    func viewDidLoadSearch() {
        /// navigation
        self.view.addSubview(navigationView)
        
        navigationView.backgroundColor = UIColor.black
        
        navigationView.addSubview(marvelImageView)
        
        navigationView.addSubview(searchTextField)
        
        searchTextField.addTarget(self,
                                  action: #selector(HomeViewController.textFieldValueChanged(sender:)),
                                  for: UIControlEvents.editingChanged)
        searchTextField.clearButtonMode = .always
        searchTextField.isHidden = true
        searchTextField.returnKeyType = .search
        searchTextField.enablesReturnKeyAutomatically = true
        searchTextField.leftViewMode = .always
        searchTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 28))
        searchTextField.font = ViewFactory.condensedBold(of: 15)
        searchTextField.textColor = UIColor.white
        searchTextField.delegate = self
        searchTextField.attributedPlaceholder = NSAttributedString(string: "Search The name of heros",
                                                                   attributes: [NSAttributedStringKey.font: ViewFactory.condensedBold(of: 15),
                                                                                NSAttributedStringKey.foregroundColor: UIColor.white.withAlphaComponent(0.2)])
        
        let line = UIView(frame: CGRect(x: 0, y: 40, width: UIScreen.main.bounds.width - 99, height: 2))
        
        searchTextField.addSubview(line)
        
        line.backgroundColor = UIColor.white
        
        searchTextField.rightView = rightButton
        
        rightButton.addTarget(self,
                              action: #selector(HomeViewController.rightButtonPressed(sender:)),
                              for: UIControlEvents.touchUpInside)
        rightButton.contentEdgeInsets = UIEdgeInsetsMake(0, 21, 0, 9)
        rightButton.setAttributedTitle(NSAttributedString(string: "Cancel",
                                                          attributes: [NSAttributedStringKey.font: ViewFactory.condensedBold(of: 15),
                                                                       NSAttributedStringKey.foregroundColor: UIColor.white]),
                                       for: .normal)
        
        marvelImageView.sizeToFit()
        marvelImageView.center = CGPoint(x: navigationView.center.x,
                                         y: navigationView.center.y + 10)
        
        searchTextField.rightViewMode = .always
        searchTextField.rightView = rightButton
        
        let searchImage = UIImage(named: "search")
        
        navigationView.addSubview(searchButton)
        
        searchButton.setImage(searchImage, for: .normal)
        searchButton.contentEdgeInsets = UIEdgeInsetsMake(0, 25, 0, 25)
        searchButton.sizeToFit()
        searchButton.center.y = marvelImageView.center.y
        searchButton.frame.origin.x = navigationView.bounds.width - searchButton.bounds.width
        searchButton.addTarget(self,
                               action: #selector(HomeViewController.showSearch),
                               for: UIControlEvents.touchUpInside)
        
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(HomeViewController.endEditGesture(_:)))
        
        maskView.addGestureRecognizer(tapGesture)
    }
    
    @objc func endEditGesture(_ gesture: UITapGestureRecognizer) {
        searchTextField.endEditing(true)
    }
    
    @objc func rightButtonPressed(sender: UIButton) {
        if (searchTextField.text ?? "") == "" {
            searchTextField.resignFirstResponder()
            
            hideSearch()
            
            return
        }
        
        searchAction?(searchTextField.text ?? "")
    }
    
    @objc func showSearch() {
        searchButton.isUserInteractionEnabled = false
        
        UIView
            .animate(withDuration: 0.25,
                     animations: {
                        self.marvelImageView.alpha = 0.0
                        
                        self.searchButton.center = CGPoint(x: 35, y: 48)
            }) { (_) in
                self.marvelImageView.isHidden = true
                self.marvelImageView.alpha = 1.0
                
                self.searchTextField.isHidden = false
                self.searchTextField.alpha = 0.0
                
                UIView
                    .animate(withDuration: 0.25,
                             animations: {
                                self.searchTextField.alpha = 1.0
                    }, completion: { (_) in
                        self.searchTextField.becomeFirstResponder()
                    })
        }
    }
    
    func hideSearch() {
        searchAction?("")
        
        UIView
            .animate(withDuration: 0.25,
                     animations: {
                        self.marvelImageView.alpha = 0.0
                        
                        self.searchButton.center.y = self.marvelImageView.center.y
                        self.searchButton.frame.origin.x = self.navigationView.bounds.width - self.searchButton.bounds.width
            }) { (_) in
                self.searchTextField.alpha = 0.0
                
                self.marvelImageView.isHidden = false
                self.marvelImageView.alpha = 0.0
                
                UIView
                    .animate(withDuration: 0.25,
                             animations: {
                                self.marvelImageView.alpha = 1.0
                    }, completion: { (_) in
                        self.searchTextField.isHidden = true
                        self.searchTextField.alpha = 1.0
                        
                        self.searchButton.isUserInteractionEnabled = true
                    })
        }
    }
}
