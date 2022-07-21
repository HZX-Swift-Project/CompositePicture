//
//  DDDevice.swift
//  CompositePicture
//
//  Created by Meet on 2022/7/19.
//

import UIKit
import Kingfisher

/// 屏幕宽度
let DD_ScreenWidth = UIScreen.main.bounds.width
/// 屏幕高度
let DD_ScreenHeight = UIScreen.main.bounds.height
/// 判断是否是iPhone
let DD_IsiPhone = (DD_CurrentDeviceModel == UIUserInterfaceIdiom.phone)
/// 刘海屏
let DD_IsHasLiuHai = judgeHasLiuHai()
/// 状态栏高度
let DD_StatusBarHeight = getDeviceStatusBarHeight()
/// 导航栏高度
let DD_NavigationBarHeight: CGFloat  = 44.0
/// 导航栏和状态栏高度总和
let DD_NaviAndStatusTotalHeight = (DD_StatusBarHeight + DD_NavigationBarHeight)
/// tabBar高度
let DD_TabBarHeight: CGFloat = DD_IsHasLiuHai ? 49 + 34 : 49
/// home indicator
let DD_BottomSafeAreaHeight: CGFloat = DD_IsHasLiuHai ? 34 : 0
/// 安全区域的高度
let DD_SafeAreaHeight: CGFloat = (DD_ScreenHeight - DD_BottomSafeAreaHeight)
/// 当前设备的图片比例 2倍图 3倍图
let DD_imageScale = UIScreen.main.scale


/// 判断设备是否有刘海
/// - Returns: 是否有刘海
private func judgeHasLiuHai() -> Bool {
    if DD_CurrentDeviceModel != .phone {
        return false
    }
    if #available(iOS 11.0, *) {
        return UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0 > 0
    } else {
        return false;
    }
}

/// 获取当前设备的型号
private func getCurrentDevieModel() -> UIUserInterfaceIdiom {
    if #available(iOS 13.0, *) {
        return UIDevice.current.userInterfaceIdiom
    } else {
        return UI_USER_INTERFACE_IDIOM()
    }
}

/// 获取状态栏高度
/// - Returns: 状态栏高度
private func getDeviceStatusBarHeight() -> CGFloat {
    if #available(iOS 13.0, *) {
        return UIApplication.shared.windows.first?.windowScene?.statusBarManager?.statusBarFrame.size.height ?? 44.0
    } else {
        return UIApplication.shared.statusBarFrame.size.height
    }
}

// MARK: ================= 获取App软件信息
/// 获取KeyWindow
let DD_KeyWindow = getKeyWindow()
/// 获取软件的AppDelegate
let DD_AppDelegate = UIApplication.shared.delegate as! AppDelegate
/// App名称
let DD_AppName: String = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String ?? ""
/// 获取App版本号
let DD_AppVersion: String = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
/// 获取当前设备的型号
let DD_CurrentDeviceModel = getCurrentDevieModel()

/// 获取keyWindow
private func getKeyWindow() -> UIWindow? {
    return UIApplication.shared.keyWindow
}


let DD_ServiceIP = ""

/// 把网络图转换成URL
/// - Parameter urlStr: 网络图片链接
/// - Returns: 处理好的URL
func DD_HTTPURL(_ urlStr: String?) -> URL? {
    var httpUrlStr = ""
    if let name = urlStr, !name.isEmpty {
        httpUrlStr = name.hasPrefix("http") ? name : (DD_ServiceIP + name)
    }
    return URL(string: httpUrlStr.replaceWhiteSpaceToPercent20())
}


/// 加载本地图片
/// - Parameter name: 图片名
/// - Returns: 本地图片Image
func DD_UIImage(_ name: String) -> UIImage? {
    return UIImage(named: name)
}

extension UIImageView {
    
    /// Kingfisher 加载网络图片
    /// 这个方法只是简单的封装了一下， 如果想继续使用Kingfisher，也是可以的
    /// - Parameters:
    ///   - name: 网络图片地址
    ///   - placeHolderImage: 占位图
    func DD_setURLImage(urlStr: String?, placeHolderImage: UIImage? = UIImage.color(UIColor.color(hex: "dbdbdb"))) {
        self.kf.setImage(with: DD_HTTPURL(urlStr), placeholder: placeHolderImage)
    }
   
}
