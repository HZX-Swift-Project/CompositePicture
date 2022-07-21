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
// MARK: -------------------------------- 绘制六边形
extension UIView {
    /// 三角方向
    enum TriangleDerection {
        case left
        case right
        case both
        case none
    }
    /// 给视图绘制六边形
    /// - Parameters:
    ///   - type: 六边形
    ///   - borderColor: 边框颜色
    ///   - borderWidth: 边框宽度
    ///   - radius: 弧度的半径
    func setSixBorder(_ type: TriangleDerection = .both, borderColor: UIColor = .clear, borderWidth: CGFloat = 2.0, radius: CGFloat = 6) {
        self.layoutIfNeeded()
        /// 移除已经存在的layer，加这一步的目的是多次操作后会在当前layer上就会有多个子layer 特别是在tableViewCell中可能出现问题
        self.layer.sublayers?.forEach({ (sulayer) in
            if sulayer.isKind(of: CAShapeLayer.self) {
                sulayer.removeFromSuperlayer()
            }
        })
        
        if type == .none {
            /// 如果没有剪切 那么移除所有直接返回 这个情况基本上不会出现 但是写上也不会多余
            return
        }
        
        /// 获取切割路径
        let maskPath = getSexanglePath(type, radius: radius)
        
        /// 创建切割路径Layer
        let maskLayer = CAShapeLayer()
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
        
        /// 创建路径边框
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = maskPath.cgPath
        shapeLayer.strokeColor = borderColor.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = borderWidth
        self.layer.addSublayer(shapeLayer)
    }
    
    private func getSexanglePath(_ type: TriangleDerection = .both, radius: CGFloat) -> UIBezierPath {
        /// 定义PI值
        let PI = CGFloat(Double.pi)
        /// 弧度半径
        let radius: CGFloat = radius
        /// 视图的宽
        let allWidth = self.bounds.size.width
        /// 视图的高
        let allHeight = self.bounds.size.height
        /// 视图高度的一半
        let LayerHeigh = self.bounds.size.height/2
        /// 六边形的一个内角度数（这里默认是正六边形 所以一个角是120度）
        let sixDegree: CGFloat = PI*2/3
        let operateDegree:CGFloat = PI - sixDegree
        /// 圆弧与上边线的切点 到左上角的距离
        let distance = radius / tan(operateDegree)
        /// 左边定点到左上角之间的X狙击
        let maxDistance = LayerHeigh / tan(operateDegree)
        
        
        /// 计算第一个点
        let firstPointX = allWidth - (maxDistance + distance)
        let firstPoint = CGPoint(x: firstPointX, y: 0)
        
        /// 计算第二个点
        let secondPointX = firstPointX + distance + distance*cos(operateDegree)
        let secondPointY = distance*sin(operateDegree)
        let secondPoint = CGPoint(x: secondPointX, y: secondPointY)
        
        /// 计算第三个点
        let thirdPointX = allWidth - distance*cos(operateDegree)
        let thirdPointY = LayerHeigh - distance*sin(operateDegree)
        let thirdPoint = CGPoint(x: thirdPointX, y: thirdPointY)
        
        /// 计算第四个点
        let fourPointY = LayerHeigh + distance*sin(operateDegree)
        let fourPoint = CGPoint(x: thirdPointX, y: fourPointY)
        
        /// 计算第五个点
        let fivePointY = allHeight - secondPoint.y
        let fivePoint = CGPoint(x: secondPoint.x, y: fivePointY)
        
        /// 计算第六个点
        let sixPoint = CGPoint(x: firstPoint.x, y: allHeight)
        
        /// 第七个点
        let sevenPointX = maxDistance + distance
        let sevenPoint = CGPoint(x: sevenPointX, y: allHeight)
        
        /// 第八个点
        let eightPointX = maxDistance  - distance*cos(operateDegree)
        let eightPoint = CGPoint(x: eightPointX, y: fivePointY)
        
        /// 第九个点
        let ninePointX = distance*cos(operateDegree)
        let ninePoint = CGPoint(x: ninePointX, y: fourPointY)
        
        /// 第十个点
        let tenPoint = CGPoint(x: ninePointX, y: thirdPointY)
        
        /// 第十一个点
        let elevenPoint = CGPoint(x: eightPoint.x, y: secondPoint.y)
        
        /// 第十二个点
        let twelvePoint = CGPoint(x: sevenPoint.x, y: 0)
        
        /// 第一个圆弧圆心坐标
        let center1 = CGPoint(x: firstPoint.x, y: radius)
        /// 第二个圆弧圆心坐标
        let center2 = CGPoint(x: allWidth - distance/cos(operateDegree), y: LayerHeigh)
        /// 第三个圆弧圆心坐标
        let center3 = CGPoint(x: sixPoint.x, y: allHeight - radius)
        /// 第四个圆弧圆心坐标
        let center4 = CGPoint(x: sevenPoint.x, y: allHeight - radius)
        /// 第五个圆弧圆心坐标
        let center5 = CGPoint(x: distance/cos(operateDegree), y: LayerHeigh)
        /// 第六个圆弧圆心坐标
        let center6 = CGPoint(x: twelvePoint.x, y: radius)
        
        let path = UIBezierPath()
        switch type {
        case .left:
            /// 只有左边有三角
            path.move(to: CGPoint(x: allWidth, y: 0))
            path.addLine(to: CGPoint(x: allWidth, y: allHeight))
            path.addLine(to: sevenPoint)
            path.addArc(withCenter: center4, radius: radius, startAngle: PI/2, endAngle: PI/2 + operateDegree, clockwise: true)
            path.addLine(to: ninePoint)
            path.addArc(withCenter: center5, radius: radius, startAngle: PI - operateDegree/2, endAngle: PI + operateDegree/2, clockwise: true)
            path.addLine(to: elevenPoint)
            path.addArc(withCenter: center6, radius: radius, startAngle: PI + operateDegree/2, endAngle: PI*3/2, clockwise: true)
        case .right:
            path.move(to: firstPoint)
            path.addArc(withCenter: center1, radius: radius, startAngle: CGFloat(-PI/2), endAngle: operateDegree - PI/2, clockwise: true)
            path.addLine(to: thirdPoint)
            path.addArc(withCenter: center2, radius: radius, startAngle: CGFloat(-operateDegree/2), endAngle: operateDegree/2, clockwise: true)
            path.addLine(to: fivePoint)
            path.addArc(withCenter: center3, radius: radius, startAngle: operateDegree/2, endAngle: PI/2, clockwise: true)
            path.addLine(to: CGPoint(x: 0, y: allHeight))
            path.addLine(to: CGPoint(x: 0, y: 0))
        default :
            path.move(to: firstPoint)
            path.addArc(withCenter: center1, radius: radius, startAngle: CGFloat(-PI/2), endAngle: operateDegree - PI/2, clockwise: true)
            path.addLine(to: thirdPoint)
            path.addArc(withCenter: center2, radius: radius, startAngle: CGFloat(-operateDegree/2), endAngle: operateDegree/2, clockwise: true)
            path.addLine(to: fivePoint)
            path.addArc(withCenter: center3, radius: radius, startAngle: operateDegree/2, endAngle: PI/2, clockwise: true)
            path.addLine(to: sevenPoint)
            path.addArc(withCenter: center4, radius: radius, startAngle: PI/2, endAngle: PI/2 + operateDegree, clockwise: true)
            path.addLine(to: ninePoint)
            path.addArc(withCenter: center5, radius: radius, startAngle: PI - operateDegree/2, endAngle: PI + operateDegree/2, clockwise: true)
            path.addLine(to: elevenPoint)
            path.addArc(withCenter: center6, radius: radius, startAngle: PI + operateDegree/2, endAngle: PI*3/2, clockwise: true)
        }
        path.close()
        return path
    }
    
    //MARK: -------------------------------- 画虚线
    // 虚线方向
    enum DashDerection{
        case left, top, right, bottom, both
    }
    /// 画虚线
    /// - Parameters:
    ///   - derection: 方向
    ///   - lineWidth: 线宽
    ///   - color: 颜色
    ///   - linelength: 小线段长度
    ///   - space: 线段间隔
    ///   - padding: 内边距 只针对 .both 类型
    ///   - path: 自定义贝塞尔曲线
    func drawDashLine(derection: DashDerection = .both, lineWidth: CGFloat = 1.0, color: UIColor = .red, linelength: Float = 10, space: Float = 5, padding: CGFloat = 0, path: UIBezierPath? = nil) {
        self.layoutIfNeeded()
        /// 移除已经存在的layer，加这一步的目的是多次操作后会在当前layer上就会有多个子layer 特别是在tableViewCell中可能出现问题
        self.layer.sublayers?.forEach({ (sulayer) in
            if sulayer.isKind(of: CAShapeLayer.self) {
                sulayer.removeFromSuperlayer()
            }
        })
        
        if let path = path {
            self.drawShapeLayer(lineWidth: lineWidth, color: color, linelength: linelength, space: space, path: path)
        } else {
            let width = self.bounds.size.width
            let height = self.bounds.size.height
            
            // 左上坐标
            let leftTopPoint = CGPoint(x: 0, y: 0)
            // 右上坐标
            let rightTopPoint = CGPoint(x: width, y: 0)
            // 右下坐标
            let rightBottomPoint = CGPoint(x: width, y: height)
            // 左下坐标
            let leftBottomPoint = CGPoint(x: 0, y: height )
            
            // 虚线路径
            let path = UIBezierPath()
            switch derection {
            case .top:
                path.move(to: leftTopPoint)
                path.addLine(to: rightTopPoint)
            case .left:
                path.move(to: leftTopPoint)
                path.addLine(to: leftBottomPoint)
            case .right:
                path.move(to: rightTopPoint)
                path.addLine(to: rightBottomPoint)
            case .bottom:
                path.move(to: leftBottomPoint)
                path.addLine(to: rightBottomPoint)
            case .both:
                path.move(to: CGPoint(x: leftTopPoint.x + padding, y: leftTopPoint.y + padding))
                path.addLine(to: CGPoint(x: rightTopPoint.x - padding, y: rightTopPoint.y + padding))
                path.addLine(to: CGPoint(x: rightBottomPoint.x - padding, y: rightBottomPoint.y - padding))
                path.addLine(to: CGPoint(x: leftBottomPoint.x + padding, y: leftBottomPoint.y - padding))
                path.addLine(to: CGPoint(x: leftTopPoint.x + padding, y: leftTopPoint.y + padding))
            }
            path.stroke()
            self.drawShapeLayer(lineWidth: lineWidth, color: color, linelength: linelength, space: space, path: path)
        }
    }
    private func drawShapeLayer(lineWidth: CGFloat = 1.0, color: UIColor = .red, linelength: Float = 10, space: Float = 5, path: UIBezierPath) {
        // 绘制图形
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.fillColor = UIColor.clear.cgColor
        // 第一个是虚线小线段的长 第二个是两条小线段之前的间隔
        shapeLayer.lineDashPattern = [NSNumber(value: linelength), NSNumber(value: space)]
        self.layer.addSublayer(shapeLayer)
    }
}

//MARK: -------------------------------- 拷贝对象
extension NSObject {
    func copyObject<T:NSObject>() throws -> T? {
        if #available(iOS 11.0, *) {
            let data = try NSKeyedArchiver.archivedData(withRootObject:self, requiringSecureCoding:false)
            return try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? T
        } else {
            return NSKeyedUnarchiver.unarchiveObject(with: NSKeyedArchiver.archivedData(withRootObject: self)) as? T
        }
        
    }
}
