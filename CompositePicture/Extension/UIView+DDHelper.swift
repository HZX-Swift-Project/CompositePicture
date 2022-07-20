//
//  UIView+DDHelper.swift
//  CompositePicture
//
//  Created by Meet on 2022/7/19.
//

import UIKit
import SnapKit

// MARK: -------------------------------- 快速获取Frame信息
extension UIView {
    /// 左顶点
    var DD_left: CGFloat {
        set {
            self.frame.origin.x = newValue
        }
        get {
            return self.frame.origin.x
        }
    }
    /// 上边
    var DD_top: CGFloat {
        set {
            self.frame.origin.y = newValue
        }
        get {
            return self.frame.origin.y
        }
    }
    /// 右边
    var DD_right: CGFloat {
        set {
            var newFrame = self.frame
            newFrame.origin.x = newValue - newFrame.size.width
            self.frame = newFrame
        }
        get {
            return self.frame.origin.x + self.frame.size.width
        }
    }
    /// 下边
    var DD_bottom: CGFloat {
        set {
            var newFrame = self.frame
            newFrame.origin.y = newValue - newFrame.size.height
            self.frame = newFrame
        }
        get {
            return self.frame.origin.y + self.frame.size.height
        }
    }
    /// 中心点X坐标
    var DD_centerX: CGFloat {
        set {
            self.center = CGPoint(x: newValue, y: self.center.y)
        }
        get {
            return self.center.x
        }
    }
    /// 中心点Y坐标
    var DD_centerY: CGFloat {
        set {
            self.center = CGPoint(x: self.center.x, y: newValue)
        }
        get {
            return self.center.y
        }
    }
    /// 视图的宽
    var DD_width: CGFloat {
        set {
            var newFrame = self.frame
            newFrame.size.width = newValue
            self.frame = newFrame
        }
        get {
            return self.frame.size.width
        }
    }
    /// 视图的高
    var DD_height: CGFloat {
        set {
            var newFrame = self.frame
            newFrame.size.height = newValue
            self.frame = newFrame
        }
        get {
            return self.frame.size.height
        }
    }
    /// 源点
    var DD_origin: CGPoint {
        set {
            var newFrame = self.frame
            newFrame.origin = newValue
            self.frame = newFrame
        }
        get {
            return self.frame.origin
        }
    }
    /// 尺寸
    var DD_size: CGSize {
        set {
            var newFrame = self.frame
            newFrame.size = newValue
            self.frame = newFrame
        }
        get {
            return self.frame.size
        }
    }
}
// MARK: -------------------------------- 剪切圆角
extension UIView {
    /// 给视图剪切圆角
    ///
    /// ⚠️⚠️⚠️ 如果使用了SnapKit 等自动布局  一定要在添加约束之后调用这个方法。⚠️⚠️⚠️
    /// 其实不管是frame布局和自动布局，都得是视图位置和大小已经知道了 才能切圆角
    /// - Parameters:
    ///   - round: 圆角大小
    ///   - corners: 剪切位置 传入的是一个数组类似 [.topLeft, .topRight]
    func roundSize(size: CGFloat, corners: UIRectCorner = .allCorners) {
        /// 调用这个方法的目的是解决使用snapKit（自动布局）以后出现的bug，
        self.layoutIfNeeded()
        
        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: size, height: size))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    }
}

// MARK: -------------------------------- 对Snpkit封装
extension UIView {
    public func prepareConstraints(_ closure: (_ make: ConstraintMaker) -> Void) -> [Constraint] {
        return self.snp.prepareConstraints(closure)
    }
    
    public func makeConstraints(_ closure: (_ make: ConstraintMaker) -> Void) {
        self.snp.makeConstraints(closure)
    }
    
    public func remakeConstraints(_ closure: (_ make: ConstraintMaker) -> Void) {
        self.snp.remakeConstraints(closure)
    }
    
    public func updateConstraints(_ closure: (_ make: ConstraintMaker) -> Void) {
        self.snp.updateConstraints(closure)
    }
    
    public func removeConstraints() {
        self.snp.removeConstraints()
    }
}

//MARK: -------------------------------- 获取某一点的颜色
extension UIView {
    func getColor(point: CGPoint) -> UIColor {
        let pointX = trunc(point.x);
        let pointY = trunc(point.y);
        
        let colorSpace = CGColorSpaceCreateDeviceRGB();
        var pixelData: [UInt8] = [0, 0, 0, 0]
        
        
        pixelData.withUnsafeMutableBytes { pointer in
            if let context = CGContext(data: pointer.baseAddress, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue){
                context.setBlendMode(.copy)
                context.translateBy(x: -pointX, y: pointY - DD_height)
                self.layer .render(in: context)
            }
        }
        let red = CGFloat(pixelData[0]) / CGFloat(255.0)
        let green = CGFloat(pixelData[1]) / CGFloat(255.0)
        let blue = CGFloat(pixelData[2]) / CGFloat(255.0)
        let alpha = CGFloat(pixelData[3]) / CGFloat(255.0)
        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}
