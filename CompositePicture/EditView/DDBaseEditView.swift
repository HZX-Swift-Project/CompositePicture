//
//  DDBaseEditView.swift
//  qieMoJiClient
//
//  Created by Meet on 2021/3/29.
//  Copyright © 2021 Lensun. All rights reserved.
//

import UIKit

protocol DDBaseEditViewDelegate {
    func baseViewDidTap(view: DDBaseEditView)
    func baseViewColseAction(view: DDBaseEditView)
    func baseViewRotateAction(view: DDBaseEditView)
}

@inline(__always) func CGRectGetCenter(_ rect:CGRect) -> CGPoint {
    return CGPoint(x: rect.midX, y: rect.midY)
}

@inline(__always) func CGRectScale(_ rect:CGRect, wScale:CGFloat, hScale:CGFloat) -> CGRect {
    return CGRect(x: rect.origin.x, y: rect.origin.y, width: rect.size.width * wScale, height: rect.size.height * hScale)
}

@inline(__always) func CGAffineTransformGetAngle(_ t:CGAffineTransform) -> CGFloat {
    return atan2(t.b, t.a)
}

@inline(__always) func CGPointGetDistance(point1:CGPoint, point2:CGPoint) -> CGFloat {
    let fx = point2.x - point1.x
    let fy = point2.y - point1.y
    return sqrt(fx * fx + fy * fy)
}

enum DDEditViewContentTextDerection {
    case horizontal
    case vertical
    mutating func toggle() {
        switch self {
        case .horizontal:
            self = .vertical
        case .vertical:
            self = .horizontal
        }
    }
}

class DDBaseEditView: UIView {
//    override var undoManager: UndoManager?
    /// 水平镜像
    var isMirrorH = false
    /// 垂直镜像
    var isMirrorV = false
    
    var editViewId: String {
        let address = String(format: "%p", self)
        return address
    }
    /// 图片路径
    var imageStr: String? {
        didSet {
            guard let imageStr = imageStr else { return }
            self.contentImageView.DD_setURLImage(urlStr: imageStr)
        }
    }
    /// 图片
    var contenImage: UIImage? {
        didSet {
            guard let image = contenImage else { return }
            self.contentImageView.image = image
        }
    }
    /// 文字内容 如果是文字视图字符串必须设置不能传nil 或者不传
    var contentText: String? {
        didSet {
            if let content = contentText {
                let str = content.isEmptyString() ? DD_DesignEditTextViewEmpty : contentText!
                self.contentTextLabel.text = str
            }
            
        }
    }
    var image: UIImage? {
        if isTextView {
            let layerSize = layer.bounds.size
            // 开启画布  把文字绘制成图片
            UIGraphicsBeginImageContextWithOptions(layerSize, false, 0.0)
            //文字样式属性
            let style = NSMutableParagraphStyle ()
            style.lineBreakMode = .byCharWrapping
            style.alignment = .center
            
            let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: contentTextFontSize),
                              NSAttributedString.Key.foregroundColor : contentTextColor,
                              NSAttributedString.Key.paragraphStyle : style]
            var targetText = contentText! as NSString
            if contentTextDerection == .vertical {
                targetText = verticalContentText as NSString
            }
            // 计算文字所占的size，文字居中显示在画布上
            let textSize = targetText.boundingRect(with: layerSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attributes as [NSAttributedString.Key : Any], context: nil)
            // 开始绘制
            targetText.draw(in: CGRect(x: layerSize.width/2 - textSize.width/2, y: layerSize.height/2 - textSize.height/2, width: textSize.width, height: textSize.height), withAttributes: attributes as [NSAttributedString.Key : Any])
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return newImage ?? nil
        } else {
            if (self.contenImage != nil) {
                return self.contenImage
            } else if (self.imageStr != nil) {
                return self.contentImageView.image
            } else {
                return nil
            }
        }
        
    }
    /// 内容的透明度
    var contentAlpha: CGFloat = 1.0
    
    /// 文字方向
    var contentTextDerection: DDEditViewContentTextDerection = .horizontal {
        didSet {
            guard let contentText = contentText else {
                return
            }
            if contentTextDerection == .vertical {
                self.contentTextLabel.text = verticalContentText
            } else {
                let str = contentText.isEmptyString() ? DD_DesignEditTextViewEmpty : contentText
                self.contentTextLabel.text = str
            }
        }
    }
    /// 文字大小
    var contentTextFontSize: CGFloat = 15.0 {
        didSet {
            self.contentTextLabel.font = UIFont.systemFont(ofSize: contentTextFontSize)
        }
    }

    /// 文字颜色
    var contentTextColor: UIColor = .black {
        didSet {
            self.contentTextLabel.textColor = contentTextColor
        }
    }
    
    /// 竖向文字
    var verticalContentText: String {
        guard let contentText = contentText else {
            return ""
        }
        let str = contentText.isEmptyString() ? DD_DesignEditTextViewEmpty : contentText
        var tempArray = [String]()
        for index in str.indices {
            let letter = contentText[index]
            tempArray.append(String(letter))
        }
        let resultStr = tempArray.joined(separator: "\n")
        return resultStr
    }
    /// 旋转角度
    var rotateAngle: CGFloat {
        return self.deltaAngle
    }
    
    /// 内容大小
    var contentSize: CGSize {
        return self.bounds.size
    }

    /// 是否被选中
    var isChoose = false {
        willSet {
            closeImageView.isHidden = !newValue
            rotateImageView.isHidden = !newValue
            scaleImageView.isHidden = !newValue
            
            if newValue {
                closeImageView.addGestureRecognizer(closeGesture)
                rotateImageView.addGestureRecognizer(rotateGesture)
                scaleImageView.addGestureRecognizer(scaleGesture)
            } else {
                closeImageView.removeGestureRecognizer(closeGesture)
                rotateImageView.removeGestureRecognizer(rotateGesture)
                scaleImageView.removeGestureRecognizer(scaleGesture)
            }
            self.layer.borderWidth = newValue ? 1.0 : 0.0
        }
    }
    /// 图片视图
    lazy var contentImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    /// 文字内容
    lazy var contentTextLabel: UILabel = {
        let label = UILabel()
        label.font = DD_Regular15Font
        label.backgroundColor = .clear
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: contentTextFontSize)
        label.textColor = contentTextColor
        label.numberOfLines = 0
        return label
    }()
    /// 是否是文字视图
    var isTextView: Bool {
        guard let _ = contentText else { return false }
        return true
    }
    /// 是否是文字视图
    var isCanCopy: Bool = true
    /**
     *  Variables for moving view
     */
    private var beginningPoint = CGPoint.zero
    private var beginningCenter = CGPoint.zero
    /// 用于记录你和手势的比例大小
    private var pinchScale: CGFloat = 1.0
    // 用于记录发大过后的尺寸
    private var recordRect: CGRect = .zero
    
    /**
     *  Variables for rotating and resizing view
     */
    private var initialBounds = CGRect.zero
    private var initialDistance:CGFloat = 0
    private var deltaAngle:CGFloat = 0
    override func layoutSubviews() {
        self.isUserInteractionEnabled = true
        
        let width = Adapt(27)
        let height = Adapt(30)
        
        if let image = imageStr {
            self.addSubview(contentImageView)
            contentImageView.DD_setURLImage(urlStr: image)
            contentImageView.makeConstraints { (make) in
                make.edges.equalTo(UIEdgeInsets.zero)
            }
        }
        if let image = contenImage {
            self.addSubview(contentImageView)
            contentImageView.image = image
            contentImageView.makeConstraints { (make) in
                make.edges.equalTo(UIEdgeInsets.zero)
            }
        }
        if let _ = contentText {
            self.addSubview(contentTextLabel)
            contentTextLabel.makeConstraints { (make) in
                make.edges.equalTo(UIEdgeInsets(top: Adapt(5), left: Adapt(5), bottom: Adapt(5), right: Adapt(5)))
            }
        }
        
        /// 关闭
        self.addSubview(closeImageView)
        self.closeImageView.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: width, height: height))
            make.left.equalTo(-width/2)
            make.top.equalTo(-height/2)
        }
        /// 旋转
        self.addSubview(rotateImageView)
        self.rotateImageView.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: width, height: height))
            make.top.equalTo(-height/2)
            make.right.equalTo(width/2)
        }
        /// 放大缩小
        self.addSubview(scaleImageView)
        self.scaleImageView.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: width, height: height))
            make.right.equalTo(width/2)
            make.bottom.equalTo(height/2)
        }
        
        /// 添加移动手势
        self.addGestureRecognizer(self.moveGesture)
        /// 捏合手势
        self.addGestureRecognizer(self.pinchGesture)
        self.pinchGesture.delegate = self
        /// 旋转手势
        self.addGestureRecognizer(self.bgRotateGesture)
        self.bgRotateGesture.delegate = self
        /// 点击手势
        self.addGestureRecognizer(self.tapGesture)
        
        self.layer.borderWidth = isChoose ? 1.0 : 0.0
        self.layer.borderColor = DD_BlueColor.cgColor
        self.layer.cornerRadius = 3
        recordRect = self.layer.frame
    }
    
    /// 关闭按钮
    lazy var closeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isHidden = true
        imageView.image = DD_UIImage("design_delete")
        imageView.isUserInteractionEnabled = true
//        imageView.addGestureRecognizer(closeGesture)
        return imageView
    }()
    private lazy var closeGesture = {
        return UITapGestureRecognizer(target: self, action: #selector(handleCloseGesture(_:)))
    }()
    /// 旋转按钮
    lazy var rotateImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isHidden = true
        imageView.image = DD_UIImage("design_rotate")
        imageView.isUserInteractionEnabled = true
//        imageView.addGestureRecognizer(rotateGesture)
        return imageView
    }()
    private lazy var rotateGesture = {
        return UIPanGestureRecognizer(target: self, action: #selector(handleRotateGesture(_:)))
    }()
    /// 放大按钮
    lazy var scaleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isHidden = true
        imageView.image = DD_UIImage("design_scale")
        imageView.isUserInteractionEnabled = true
//        imageView.addGestureRecognizer(scaleGesture)
        return imageView
    }()
    private lazy var scaleGesture = {
        return UIPanGestureRecognizer(target: self, action: #selector(handleScaleGesture(_:)))
    }()
    /// 移动手势
    private lazy var moveGesture: UIPanGestureRecognizer = {
        let moveGesture = UIPanGestureRecognizer(target: self, action: #selector(handleMoveGesture(_:)))
        moveGesture.maximumNumberOfTouches = 1;
        return moveGesture
    }()
    /// 点击手势
    private lazy var tapGesture = {
        return UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
    }()
    /// 捏合手势
    private lazy var pinchGesture = {
        return UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture(_:)))
    }()
    /// 旋转手势
    private lazy var bgRotateGesture = {
        return UIRotationGestureRecognizer(target: self, action: #selector(handleContentRotateGesture(_:)))
    }()
    /// 代理事件
    var baseDelegate: DDBaseEditViewDelegate?
}
//MARK: ---------------------------------- 三个按钮手势事件
extension DDBaseEditView {
    /// 移除子视图
    func removeAllSubviews() {
        for (_, subView) in self.subviews.enumerated() {
            subView.removeFromSuperview()
        }
    }
    /// 左右镜像
    func changeXMirror() {
        isMirrorH = !isMirrorH
        if self.isTextView {
            self.contentTextLabel.transform = CGAffineTransform(scaleX: -1, y: 1).concatenating(self.contentTextLabel.transform)
        } else {
            self.contentImageView.transform = CGAffineTransform(scaleX: -1, y: 1).concatenating(self.contentImageView.transform)
        }
    }
    /// 上下镜像
    func changeYMirror() {
        isMirrorV = !isMirrorV
        if self.isTextView {
            self.contentTextLabel.transform = CGAffineTransform(scaleX: 1, y: -1).concatenating(self.contentTextLabel.transform)
        } else {
            self.contentImageView.transform = CGAffineTransform(scaleX: 1, y: -1).concatenating(self.contentImageView.transform)
        }
    }
    /// 关闭事件
    @objc
    func handleCloseGesture(_ recognizer: UITapGestureRecognizer) {
        baseDelegate?.baseViewColseAction(view: self)
        self.removeFromSuperview()
    }
    /// 放大事件
    @objc
    func handleScaleGesture(_ recognizer: UIPanGestureRecognizer) {
        let touchLocation = recognizer.location(in: self.superview)
        let center = self.center
        
        switch recognizer.state {
        case .began:
            self.pinchScale = 1.0
            self.initialBounds = self.bounds
            self.initialDistance = CGPointGetDistance(point1: center, point2: touchLocation)
        case .changed:
            let scale = CGPointGetDistance(point1: center, point2: touchLocation) / self.initialDistance
            let scaledBounds = CGRectScale(self.initialBounds, wScale: scale, hScale: scale)
            self.remakeConstraints { (make) in
                make.center.equalTo(center)
                make.size.equalTo(scaledBounds.size)
            }
            self.pinchScale = scale / self.pinchScale
            self.contentTextFontSize *= self.pinchScale
            self.pinchScale = scale
        default:
            break
        }
    }
    /// 旋转事件
    @objc
    func handleRotateGesture(_ recognizer: UIPanGestureRecognizer) {
        let touchLocation = recognizer.location(in: self.superview)
        let center = self.center
        switch recognizer.state {
        case .began:
            self.deltaAngle = CGFloat(atan2f(Float(touchLocation.y - center.y), Float(touchLocation.x - center.x)))
        case .changed:
            let angle = atan2f(Float(touchLocation.y - center.y), Float(touchLocation.x - center.x))
            let angleDiff = Float(self.deltaAngle) - angle
            self.transform = CGAffineTransform(rotationAngle: CGFloat(-angleDiff)).concatenating(self.transform)
            self.deltaAngle = CGFloat(angle)
        default:
            break
        }
        baseDelegate?.baseViewRotateAction(view: self)
    }
}
//MARK: ---------------------------------- 整个视图手势事件
extension DDBaseEditView {
    /// 点击手势
    @objc
    func handleTapGesture(_ recognizer: UIPanGestureRecognizer) {
        baseDelegate?.baseViewDidTap(view: self)
    }
    /// 移动手势
    @objc
    func handleMoveGesture(_ recognizer: UIPanGestureRecognizer) {
        let touchLocation = recognizer.location(in: self.superview)
        switch recognizer.state {
        case .began:
            self.beginningPoint = touchLocation
            self.beginningCenter = self.center
        case .changed:
            let center = CGPoint(x: self.beginningCenter.x + (touchLocation.x - self.beginningPoint.x), y: self.beginningCenter.y + (touchLocation.y - self.beginningPoint.y))
            self.remakeConstraints { (make) in
                make.center.equalTo(center)
                make.size.equalTo(self.bounds.size)
            }
        case .ended:
            let center = CGPoint(x: self.beginningCenter.x + (touchLocation.x - self.beginningPoint.x), y: self.beginningCenter.y + (touchLocation.y - self.beginningPoint.y))
            self.remakeConstraints { (make) in
                make.center.equalTo(center)
                make.size.equalTo(self.bounds.size)
            }
        default:
            break
        }
    }
    /// 捏合手势
    @objc
    func handlePinchGesture(_ recognizer: UIPinchGestureRecognizer) {
        if recognizer.state == .began {
            self.initialBounds = self.bounds
            self.pinchScale = 1.0
        }
        if recognizer.state == .changed {
            self.pinchScale = recognizer.scale / self.pinchScale
            let scaledBounds = CGRectScale(self.initialBounds, wScale: recognizer.scale, hScale: recognizer.scale)
            self.remakeConstraints { (make) in
                make.center.equalTo(center)
                make.size.equalTo(scaledBounds.size)
            }
            if self.contentText != nil {
                self.contentTextFontSize *= self.pinchScale
                self.pinchScale = recognizer.scale
            }
        }
    }
    /// 自身旋转手势
    @objc
    func handleContentRotateGesture(_ recognizer: UIRotationGestureRecognizer) {
        if recognizer.state == .changed {
            self.transform = self.transform.rotated(by: recognizer.rotation)
            self.deltaAngle = recognizer.rotation
            recognizer.rotation = 0.0
        }
        
    }
}

//MARK: ---------------------------------- 手势代理
extension DDBaseEditView: UIGestureRecognizerDelegate {
    /// 允许手势重叠
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        let view = super.hitTest(point, with: event)
        /// 关闭视图
        let point1 = self.closeImageView.convert(point, from: self)
        if self.closeImageView.point(inside: point1, with: event) {
            return self.closeImageView
        }
        /// 放大视图
        let point2 = self.scaleImageView.convert(point, from: self)
        if self.scaleImageView.point(inside: point2, with: event) {
            return self.scaleImageView
        }
        /// 旋转视图
        let point3 = self.rotateImageView.convert(point, from: self)
        if self.rotateImageView.point(inside: point3, with: event) {
            return self.rotateImageView
        }
        
        return view
    }
    
}
