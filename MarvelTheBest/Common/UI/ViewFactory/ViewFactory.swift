//
//  ViewFactory.swift
//  MarvelTheBest
//
//  Created by 范舟弛 on 2018/3/15.
//  Copyright © 2018年 范舟弛. All rights reserved.
//

import Foundation


/*
 ["HelveticaNeue-UltraLightItalic", "HelveticaNeue-Medium", "HelveticaNeue-MediumItalic", "HelveticaNeue-UltraLight", "HelveticaNeue-Italic", "HelveticaNeue-Light", "HelveticaNeue-ThinItalic", "HelveticaNeue-LightItalic", "HelveticaNeue-Bold", "HelveticaNeue-Thin", "HelveticaNeue-CondensedBlack", "HelveticaNeue", "HelveticaNeue-CondensedBold", "HelveticaNeue-BoldItalic"]
*/

public let UIConfigTopOffset:CGFloat = {
    () in
    if UIScreen.main.bounds.height == 812 {
        return 24
    }
    
    return 0
}()

public let UIConfigStatusBarHeight:CGFloat = {
    () in
    if UIScreen.main.bounds.height == 812 {
        return 44
    }
    
    return 20
}()

public let UIConfigNavigationBarHeight:CGFloat = {
    () in
    if UIScreen.main.bounds.height == 812 {
        return 88
    }
    
    return 64
}()

public let UIConfigBottomBarHeight:CGFloat = {
    () in
    if UIScreen.main.bounds.height == 812 {
        return 83.5
    }
    
    return 49.5
}()

public let UIConfigTopMargin:CGFloat = {
    () in
    if UIScreen.main.bounds.height == 812 {
        return 24
    }
    
    return 0
}()

public let UIConfigBottomMargin:CGFloat = {
    () in
    if UIScreen.main.bounds.height == 812 {
        return 34
    }
    
    return 0
}()

class ViewFactory {
    static func condensedBold(of size: CGFloat) -> UIFont {
        return UIFont(name: "HelveticaNeue-CondensedBold", size: size)!
    }
    
    static func helveticaNeue(of size: CGFloat) -> UIFont {
        return UIFont(name: "HelveticaNeue", size: size)!
    }
    
}
