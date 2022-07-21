//
//  DDProgressHud.swift
//  DDSwiftToolProject
//
//  Created by Meet on 2020/4/27.
//  Copyright © 2020 houZhongXiang. All rights reserved.
//

import UIKit
import MBProgressHUD

/// 默认HUD显示时间
private let defaultHUDShowTime = 1.5

class DDMBProgressHUD {
    static var hud: MBProgressHUD?
    
    private class func createHUD(view: UIView? = DD_KeyWindow, isMask: Bool = false, isCoverNavi: Bool = true) -> MBProgressHUD? {
        guard let superView = view else { return nil }
        let HUD = MBProgressHUD.showAdded(to: superView, animated: true)
        let hudTop = isCoverNavi ? 0 : DD_NaviAndStatusTotalHeight
        HUD.frame = CGRect(x: 0, y: hudTop, width: DD_ScreenWidth, height: DD_ScreenHeight - hudTop)
        HUD.animationType = .zoom
        if isMask {
            HUD.backgroundView.color = UIColor(white: 0.0, alpha: 0.4)
        } else {
            HUD.bezelView.style = .solidColor
            HUD.backgroundView.color = UIColor.clear
            HUD.bezelView.backgroundColor = UIColor(white: 0.0, alpha: 0.9)
            HUD.contentColor = DD_WhiteColor
        }
        HUD.removeFromSuperViewOnHide = true
        HUD.show(animated: true)
        return HUD
    }
    
    private class func createHUD(message: String?, iconName: String?, view: UIView? = DD_KeyWindow) -> MBProgressHUD? {
        let HUD = createHUD(view: view, isMask: false, isCoverNavi: true)
        if let iconName = iconName {
            HUD?.mode = .customView
            HUD?.customView = UIImageView(image: DD_UIImage(iconName))
        } else {
            HUD?.mode = .text
        }
        HUD?.label.text = message
        HUD?.label.numberOfLines = 0
        return HUD
    }
}

extension DDMBProgressHUD {
    
    /// Tost弹窗
    /// - Parameters:
    ///   - message: 提示文字
    ///   - view: 加载到的视图
    ///   - isMask: 是否显示遮罩视图
    ///   - isCoverNavi: 是否覆盖导航
    ///   - showTime: 显示时长
    public class func showTipMessage(_ message: String?, view: UIView? = DD_KeyWindow, isMask: Bool = false, isCoverNavi: Bool = true, showTime: Double = defaultHUDShowTime, completeClosure: (() -> Void)? = nil) {
        
        showTipMessage(message, iconName: nil, view: view, isMask: isMask, isCoverNavi: isCoverNavi, showTime: showTime, completeClosure: completeClosure)
    }
    
    /// 显示图片加文字的弹窗
    /// - Parameters:
    ///   - message: 提示文字
    ///   - iconName: 图片名称
    ///   - view: 加载的视图
    ///   - isMask: 是否有遮罩
    ///   - isCoverNavi: 是否盖着导航
    ///   - showTime: 提示时长
    public class func showTipMessage(_ message: String?, iconName: String?, view: UIView? = DD_KeyWindow, isMask: Bool = false, isCoverNavi: Bool = true, showTime: Double = defaultHUDShowTime, completeClosure: (() -> Void)? = nil) {
        hiddenHUD()
        let HUD = createHUD(message: message, iconName: iconName, view: view)
        if completeClosure != nil {
            HUD?.completionBlock = completeClosure
        }
        HUD?.hide(animated: true, afterDelay: showTime)
    }
    
    /// 显示加载数据
    /// - Parameters:
    ///   - message: 提示内容
    ///   - view: 添加到的视图
    ///   - isMask: 是否显示遮罩视图
    ///   - isCoverNavi: 是否覆盖导航视图
    public class func showLoadingHUD(message:String? = "正在加载...", view : UIView? = DD_KeyWindow, isMask : Bool = false, isCoverNavi: Bool = true) {
        if let HUD = hud {
            HUD.hide(animated: false)
        }
        let HUD = createHUD(view: view, isMask: isMask, isCoverNavi: isCoverNavi)
        HUD?.mode = .indeterminate
        HUD?.label.text = message
        hud = HUD
    }
    
    /// 隐藏菊花
    public class func hiddenHUD(animated: Bool = false) {
        guard let HUD = hud else {
            return
        }
        HUD.hide(animated: animated)
//        hud = nil
    }
    
}
