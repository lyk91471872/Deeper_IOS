//
//  ColorHelper.swift
//  Deeper
//
//  Created by 罗宇康 on 2017/8/24.
//  Copyright © 2017年 lyk91471872. All rights reserved.
//

import Foundation
import UIKit

class ColorHelper {
    static func covertColor (_ Color_Value:NSString)->UIColor{
        var  Str :NSString = Color_Value.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines).uppercased() as NSString
        if Color_Value.hasPrefix("#"){
            Str=(Color_Value as NSString).substring(from: 1) as NSString
        }
        let StrRed = (Str as NSString ).substring(to: 2)
        let StrGreen = ((Str as NSString).substring(from: 2) as NSString).substring(to: 2)
        let StrBlue = ((Str as NSString).substring(from: 4) as NSString).substring(to: 2)
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        Scanner(string:StrRed).scanHexInt32(&r)
        Scanner(string: StrGreen).scanHexInt32(&g)
        Scanner(string: StrBlue).scanHexInt32(&b)
        return UIColor(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: 1)
    }
}
