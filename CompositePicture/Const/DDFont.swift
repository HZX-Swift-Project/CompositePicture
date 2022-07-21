//
//  DDFontConst.swift
//  DDSwiftToolProject
//
//  Created by Meet on 2020/4/27.
//  Copyright © 2020 houZhongXiang. All rights reserved.
//

import UIKit

/// 适配比例
let DD_Scale: CGFloat = UIScreen.main.bounds.size.width / 375.0

/// 自动适配
func Adapt(_ num: CGFloat) -> CGFloat {
    return num * DD_Scale
}
extension Int {
    var adapt: CGFloat {return DD_Scale * CGFloat(self)}
}
extension Float {
    var adapt: CGFloat {return DD_Scale * CGFloat(self)}
}
extension Double {
    var adapt: CGFloat {return DD_Scale * CGFloat(self)}
}

// MARK: ----------------- 常规字体
let DD_Regular10Font = UIFont.systemFont(ofSize: 10 * DD_Scale)
let DD_Regular11Font = UIFont.systemFont(ofSize: 11 * DD_Scale)
let DD_Regular12Font = UIFont.systemFont(ofSize: 12 * DD_Scale)
let DD_Regular13Font = UIFont.systemFont(ofSize: 13 * DD_Scale)
let DD_Regular14Font = UIFont.systemFont(ofSize: 14 * DD_Scale)
let DD_Regular15Font = UIFont.systemFont(ofSize: 15 * DD_Scale)
let DD_Regular16Font = UIFont.systemFont(ofSize: 16 * DD_Scale)
let DD_Regular17Font = UIFont.systemFont(ofSize: 17 * DD_Scale)
let DD_Regular18Font = UIFont.systemFont(ofSize: 18 * DD_Scale)
let DD_Regular19Font = UIFont.systemFont(ofSize: 19 * DD_Scale)
let DD_Regular20Font = UIFont.systemFont(ofSize: 20 * DD_Scale)

/// 系统regular字体大小 适配手机
/// - Parameter ofSize: 字体大小
/// - Returns: UIFont
func DD_RegularCustomFont(ofSize: CGFloat) -> UIFont {
    return UIFont.systemFont(ofSize: ofSize * DD_Scale)
}

// MARK: ----------------- 粗体
let DD_Bold10Font = UIFont.boldSystemFont(ofSize: 10 * DD_Scale)
let DD_Bold11Font = UIFont.boldSystemFont(ofSize: 11 * DD_Scale)
let DD_Bold12Font = UIFont.boldSystemFont(ofSize: 12 * DD_Scale)
let DD_Bold13Font = UIFont.boldSystemFont(ofSize: 13 * DD_Scale)
let DD_Bold14Font = UIFont.boldSystemFont(ofSize: 14 * DD_Scale)
let DD_Bold15Font = UIFont.boldSystemFont(ofSize: 15 * DD_Scale)
let DD_Bold16Font = UIFont.boldSystemFont(ofSize: 16 * DD_Scale)
let DD_Bold17Font = UIFont.boldSystemFont(ofSize: 17 * DD_Scale)
let DD_Bold18Font = UIFont.boldSystemFont(ofSize: 18 * DD_Scale)
let DD_Bold19Font = UIFont.boldSystemFont(ofSize: 19 * DD_Scale)
let DD_Bold20Font = UIFont.boldSystemFont(ofSize: 20 * DD_Scale)

/// 系统Bold字体大小 适配手机
/// - Parameter ofSize: 字体大小
/// - Returns: UIFont
func DD_BoldCustomFont(ofSize: CGFloat) -> UIFont {
    return UIFont.systemFont(ofSize: ofSize, weight: .black)
}

/// 自定义系统字重字体大小 适配手机
/// - Parameters:
///   - ofSize: 字体大小
///   - weight: 字体权重
/// - Returns: UIFont
func DD_CustomWeighFont(ofSize: CGFloat, weight: UIFont.Weight) -> UIFont {
    return UIFont.systemFont(ofSize: ofSize * DD_Scale, weight: weight)
}

/// 指定名称字体
/// - Parameter ofSize: 字体名称
/// - Returns: UIFont
func DD_CustomNameFont(name: String, ofSize: CGFloat) -> UIFont? {
    return UIFont.init(name: name, size: ofSize * DD_Scale);
}
