//
//  ViewModel.swift
//  MarvelTheBest
//
//  Created by 范舟弛 on 2018/3/14.
//  Copyright © 2018年 范舟弛. All rights reserved.
//

import Foundation

protocol View {
    var view: UIView! {get}
}

protocol ViewModel: class {
    associatedtype V: View
    
    func bind(to view:V)
}

extension UIView: View {
    var view: UIView! {
        return self
    }
}

extension UIViewController: View {}
