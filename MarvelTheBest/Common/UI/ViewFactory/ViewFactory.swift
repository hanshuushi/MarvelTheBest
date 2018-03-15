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

class ViewFactory {
    static func condensedBold(of size: CGFloat) -> UIFont {
        return UIFont(name: "HelveticaNeue-CondensedBold", size: size)!
    }
    
    static func helveticaNeue(of size: CGFloat) -> UIFont {
        return UIFont(name: "HelveticaNeue", size: size)!
    }
    
}
