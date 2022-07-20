//
//  UIImage+DDHelper.swift
//  CompositePicture
//
//  Created by Meet on 2022/7/19.
//

import UIKit

extension UIImage {
    /// 根据颜色生成图片
    /// - Parameter color: 图片颜色
    /// - Returns: 生成后的图片
    public static func color(_ color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 10, height: 10)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}

extension UIImage {
    /// 编辑图片
    /// - Parameters:
    ///   - radians: 旋转的弧度
    ///   - isMirrorH: 是否水平镜像
    ///   - isMirrorV: 是否垂直镜像
    /// - Returns: 编辑后的图片
    func operate(radians: CGFloat = 0.0, isMirrorH: Bool = false, isMirrorV: Bool = false) -> UIImage {
        if radians == 0.0, !isMirrorH, !isMirrorV {
            return self
        }
        var targetImage = self
        if isMirrorH {
            // 水平镜像
            targetImage = targetImage.flipH()
        }
        if isMirrorV {
            // 垂直镜像
            targetImage = targetImage.flipV()
        }
        return targetImage.rotate(radians: radians)
    }
    
    /// 旋转图片
    /// - Parameter radians: 旋转弧度数
    /// - Returns: 编辑后的图片
    func rotate(radians: CGFloat = 0.0) -> UIImage {
        if radians == 0.0 {
            return self
        }
        let imageRect = CGRect(origin: .zero, size: size)
        // 获取旋转后的图片尺寸大小
        var rotatedRect = imageRect.applying(CGAffineTransform(rotationAngle: CGFloat(radians))).integral
        rotatedRect.origin.x = 0
        rotatedRect.origin.y = 0
        // 开启画布 这里第三个参数 scale 出入0 系统会自动缩放
        UIGraphicsBeginImageContextWithOptions(rotatedRect.size, false, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else { return self }
        // 把旋转点放在屏幕中心
        context.translateBy(x: rotatedRect.width / 2, y: rotatedRect.height / 2)
        context.rotate(by: radians)
        context.translateBy(x: -size.width / 2, y: -size.height / 2)
        // 开始绘画
        draw(at: .zero)
        // 获取图片
        let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return rotatedImage ?? self
    }
    
    ///  水平镜像
    /// - Returns: 处理过后的图片
    func flipH() -> UIImage {
       return self.withHorizontallyFlippedOrientation()
    }
    
    /// 垂直镜像
    /// - Returns: 处理过后的图片
    func flipV() -> UIImage {
        // 先绕中心点旋转180度 然后再水平镜像
        return self.rotate(radians: CGFloat(Double.pi)).withHorizontallyFlippedOrientation()
    }
}
