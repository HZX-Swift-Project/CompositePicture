//
//  DDColor.swift
//  CompositePicture
//
//  Created by Meet on 2022/7/19.
//

import UIKit

// MARK: ---------------------- 背景颜色
/// 透明颜色
let DD_ClearColor = UIColor.clear
/// 白色背景
let DD_WhiteColor = UIColor.white
/// 黑色字体
let DD_BlackColor = UIColor.black
/// 默认的背景颜色
let DD_DefaultBgColor = UIColor.color(hex: "eceded")
/// 蓝色背景
let DD_BlueColor = UIColor.color(hex: "839cd0")
/// 灰色背景1
let DD_GrayBgColor = UIColor.color(hex: "dbdbdb")
/// 灰色背景2
let DD_LightGrayBgColor = UIColor.color(hex: "edeeee")
// MARK: ---------------------- 字体颜色
/// 一级标题
let DD_LevelOneColor = UIColor.color(hex: "333333")
/// 二级标题
let DD_LevelTwoColor = UIColor.color(hex: "666666")
/// 三级标题
let DD_LevelThreeColor = UIColor.color(hex: "999999")
/// 黑色字体
let DD_BlackTextColor = UIColor.color(hex: "333333")
/// 灰色字体
let DD_GrayTextColor = UIColor.color(hex: "888888")
/// 浅灰色字体
let DD_LigntGrayTextColor = UIColor.color(hex: "9e9e9f")

// MARK: ---------------------- 线条颜色
/// 线条颜色
let DD_GrayLineColor = UIColor.color(hex: "dbdcdc")

// MARK: ---------------------- 边框颜色
/// 边框颜色
let DD_GrayBoarderColor = UIColor.color(hex: "E0E0E0")

/// 随机颜色图片
let DD_randomColorImage = getRandomColorImage()

/// 随机颜色数组
private let DD_randomColorArray = [UIColor.color(hex: "9e9e9f"),
                           UIColor.color(hex: "b4b29b"),
                           UIColor.color(hex: "b4b4b5"),
                           UIColor.color(hex: "fbd6a0"),
                           UIColor.color(hex: "b4b4b5"),
                           UIColor.color(hex: "b6ccd9"),
                           UIColor.color(hex: "c8c8c9"),
                           UIColor.color(hex: "97a47d"),
                           UIColor.color(hex: "dbdcdc"),
                           UIColor.color(hex: "ce736d")]

/// 返回指定数组随机的颜色图片
/// - Returns: 颜色图片
private func getRandomColorImage() -> UIImage {
    let color = DD_randomColorArray[Int(arc4random()) % DD_randomColorArray.count]
    return UIImage.color(color)
}

