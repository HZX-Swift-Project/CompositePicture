//
//  ViewController.swift
//  CompositePicture
//
//  Created by Meet on 2022/7/19.
//

import UIKit

class ViewController: UIViewController {
    // 底部图片视图
    private var collectionView: DDPictureListView!
    // 选择的底部菜单按钮
    private var chooseButton: UIButton!
    // 编辑容器视图
    private var editContainerView: UIView!
    // 虚线切割视图
    private var dashCutView: UIView!
    // 封面视图
    private var coverView: DDBaseEditView?
    // 选中的要编辑的图片
    private var chooseEditView: DDBaseEditView?
    // 遮罩视图的透明度
    let maskViewColor = UIColor.color(hex: "ffffff", alpha: 0.6)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        configUI()
    }
}
extension ViewController {
    //MARK: -------------------------- UI界面
    private func configUI() {
        // 底部切换视图
        let bottomButtonView = UIView()
        view.addSubview(bottomButtonView)
        bottomButtonView.backgroundColor = .white
        bottomButtonView.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.snp_bottomMargin)
            make.height.equalTo(Adapt(50))
        }
        for index in 0..<2 {
            let menuButton = UIButton()
            menuButton.setTitle(index == 0 ? "封面" : "贴纸", for: .normal)
            menuButton.setTitleColor(DD_LevelOneColor, for: .normal)
            menuButton.setTitleColor(.white, for: .selected)
            menuButton.tag = 10 + index
            if index == 0 {
                menuButton.backgroundColor = DD_BlueColor
                menuButton.isSelected = true
                chooseButton = menuButton
            }
            menuButton.addTarget(self, action: #selector(changeMenuAction(_:)), for: .touchUpInside)
            bottomButtonView.addSubview(menuButton)
            menuButton.makeConstraints { make in
                make.left.equalTo(DD_ScreenWidth/2*CGFloat(index))
                make.top.bottom.equalToSuperview()
                make.width.equalTo(DD_ScreenWidth/2)
            }
        }
        
        let collectionView = DDPictureListView(frame: .zero)
        self.collectionView = collectionView
        collectionView.delegate = self
        collectionView.isCover = true
        view.addSubview(collectionView)
        collectionView.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(Adapt(90))
            make.bottom.equalTo(bottomButtonView.snp.top).offset(-Adapt(10))
        }
        view.layoutIfNeeded()
        bottomButtonView.layoutIfNeeded()
        collectionView.layoutIfNeeded()
        
        let editContainerView = UIView()
        editContainerView.clipsToBounds = true
        editContainerView.backgroundColor = .clear
        self.editContainerView = editContainerView
        view.addSubview(editContainerView)
        editContainerView.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(collectionView.snp.top).offset(-Adapt(10))
            make.top.equalTo(DD_StatusBarHeight)
        }
        editContainerView.layoutIfNeeded()
        let dashCutView = UIView()
        dashCutView.isUserInteractionEnabled = false
        editContainerView.addSubview(dashCutView)
        dashCutView.backgroundColor = .clear
        self.dashCutView = dashCutView
        dashCutView.makeConstraints { make in
            make.height.equalTo(editContainerView.DD_height*0.8)
            make.width.equalToSuperview().multipliedBy(0.7)
            make.centerX.equalToSuperview().offset(Adapt(-10))
            make.centerY.equalToSuperview()
        }
        dashCutView.drawDashLine()
        
        let leftMarkView = UIView()
        leftMarkView.isUserInteractionEnabled = false
        leftMarkView.backgroundColor = maskViewColor
        editContainerView.addSubview(leftMarkView)
        leftMarkView.makeConstraints { (make) in
            make.left.top.bottom.equalToSuperview()
            make.right.equalTo(dashCutView.snp.left)
        }
        
        let topMarkView = UIView()
        topMarkView.isUserInteractionEnabled = false
        topMarkView.backgroundColor = maskViewColor
        editContainerView.addSubview(topMarkView)
        topMarkView.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.right.equalTo(dashCutView)
            make.left.equalTo(dashCutView)
            make.bottom.equalTo(dashCutView.snp.top)
        }
        
        let rightMarkView = UIView()
        rightMarkView.isUserInteractionEnabled = false
        rightMarkView.backgroundColor = maskViewColor
        editContainerView.addSubview(rightMarkView)
        rightMarkView.makeConstraints { (make) in
            make.left.equalTo(dashCutView.snp.right)
            make.right.bottom.top.equalToSuperview()
        }
        
        let bottomMarkView = UIView()
        bottomMarkView.isUserInteractionEnabled = false
        bottomMarkView.backgroundColor = maskViewColor
        editContainerView.addSubview(bottomMarkView)
        bottomMarkView.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.left.equalTo(dashCutView)
            make.right.equalTo(dashCutView)
            make.top.equalTo(dashCutView.snp.bottom)
        }
        
        let rightMenuView = DDRightMenuView()
        rightMenuView.delegate = self
        rightMenuView.backgroundColor = .clear
        view.addSubview(rightMenuView)
        rightMenuView.makeConstraints { make in
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(Adapt(50))
        }
    }
}
extension ViewController {
    //MARK: -------------------------- 点击事件
    // 切换菜单
    @objc private func changeMenuAction(_ button: UIButton) {
        chooseButton.isSelected = false
        chooseButton.backgroundColor = .white
        if chooseButton != button {
            chooseButton = button
            collectionView.isCover = chooseButton.tag == 10
        }
        chooseButton.isSelected = true
        chooseButton.backgroundColor = DD_BlueColor
    }
}

extension ViewController: DDRightMenuViewDelegate {
    //MARK: -------------------------- 右边按钮事件
    func rightView(_ rightView: DDRightMenuView, didSelectIndex index: Int) {
        switch index {
        case 0:
            // 文字视图
            if let editView = self.chooseEditView, editView.isTextView {
                let textView = DDCustomTextView.showCustomView(editView: chooseEditView!)
                textView.delegate = self
            } else {
                let textEditView = DDBaseEditView()
                let sizeWidth = DD_DesignEditTextViewEmpty.calculateTextWidth(font: DD_Regular15Font, height: Adapt(30)) + Adapt(20)
                textEditView.contentText = ""
                textEditView.baseDelegate = self
                textEditView.isChoose = true
                textEditView.contentTextDerection = .horizontal
                self.editContainerView.insertSubview(textEditView, belowSubview: self.dashCutView)
                textEditView.makeConstraints { (make) in
                    make.center.equalTo(self.dashCutView)
                    make.height.equalTo(Adapt(30))
                    make.width.equalTo(sizeWidth)
                }
                self.chooseEditView = textEditView
                let textView = DDCustomTextView.showCustomView(editView: chooseEditView!)
                textView.delegate = self
            }
            
        case 1:
            // 左右镜像
            self.chooseEditView?.changeXMirror()
        case 2:
            // 上下镜像
            self.chooseEditView?.changeYMirror()
        case 3:
            /// 复制
            guard let editView = self.chooseEditView, editView.isCanCopy else { return }
            editView.isChoose = false
            let copyEditView = try? editView.copyObject() as? DDBaseEditView
            copyEditView?.removeAllSubviews()
            if editView.isTextView {
                copyEditView?.contentText = editView.contentText
                copyEditView?.contentTextDerection = editView.contentTextDerection
                copyEditView?.contentTextFontSize = editView.contentTextFontSize
                copyEditView?.contentTextColor = editView.contentTextColor
            } else {
                if let image = editView.contenImage {
                    copyEditView?.contenImage = image
                } else {
                    copyEditView?.imageStr = editView.imageStr
                }
            }
            
            copyEditView?.baseDelegate = self
            self.editContainerView.insertSubview(copyEditView!, belowSubview: self.dashCutView)
            copyEditView!.makeConstraints { (make) in
                make.center.equalTo(editView).offset(Adapt(20))
                make.width.equalTo(editView.contentSize.width)
                make.height.equalTo(editView.contentSize.height)
            }
            self.chooseEditView = copyEditView
            self.chooseEditView?.isChoose = true
        case 4:
            // 清除
            for (_, view) in self.editContainerView.subviews.enumerated() {
                if view is DDBaseEditView {
                    view.removeFromSuperview()
                }
            }
            self.chooseEditView = nil
            self.coverView = nil
        case 5:
            // 预览图片
            checkPreviewAction()
        default:
            return
        }
    }
    private func checkPreviewAction() {
        guard let coverView = coverView else { return DDMBProgressHUD.showTipMessage("没有添加封面图") }
        var kScale = 4.0
        if DD_ScreenWidth <= 375.0 {
            kScale = 5.0
        }
        // 获取封面背景图
        guard let coverImage = coverView.image else { return DDMBProgressHUD.showTipMessage("未获取到图片信息") }
        /// 开启上下文
        let fileSize = self.dashCutView.DD_size;
        let targetSize = CGSize(width: fileSize.width*kScale, height: fileSize.height*kScale);
        // 开启画布
        UIGraphicsBeginImageContextWithOptions(targetSize, false, 0);
        // 获取封面图相对于图纸文件的位置
        let rect = self.editContainerView.convert(coverView.frame, to: self.dashCutView)
        // 绘制封面图
        // 这是图片旋转的角度 弧度数
        let degree = atan2f(Float(coverView.transform.b), Float(coverView.transform.a))
        // 获取切割的位置
        let targetRect = CGRect(x: rect.origin.x*kScale, y: rect.origin.y*kScale, width: rect.size.width*kScale, height: rect.size.height*kScale)
        let coverRotateImage = coverImage.operate(radians: CGFloat(degree), isMirrorH: coverView.isMirrorH, isMirrorV: coverView.isMirrorV)
        coverRotateImage.draw(in: targetRect)
        
        // 绘制贴图和文字
        for view in editContainerView.subviews {
            if view !== coverView {
                if view is DDBaseEditView {
                    let editView = view as! DDBaseEditView
                    // 获取贴图
                    if let tagImage = editView.image {
                        let degree = atan2f(Float(editView.transform.b), Float(editView.transform.a))
                        var targetRect: CGRect = .zero
                        if editView.isTextView {
                            let editViewRect = self.editContainerView.layer.convert(editView.layer.frame, to: self.dashCutView.layer)
                            targetRect = CGRect(x: editViewRect.origin.x*kScale, y: editViewRect.origin.y*kScale, width: editViewRect.size.width*kScale, height: editViewRect.size.height*kScale)
                        } else {
                            let editViewRect = self.editContainerView.convert(editView.frame, to: self.dashCutView)
                            targetRect = CGRect(x: editViewRect.origin.x*kScale, y: editViewRect.origin.y*kScale, width: editViewRect.size.width*kScale, height: editViewRect.size.height*kScale)
                        }
                        let tagRotateImage = tagImage.operate(radians: CGFloat(degree), isMirrorH: editView.isMirrorH, isMirrorV: editView.isMirrorV)
                        tagRotateImage.draw(in: targetRect)
                    }
                }
            }
        }
        
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        /// 关闭画布
        UIGraphicsEndImageContext();
        if let resultImage = resultImage {
            naviToNextVC(resultImage: resultImage)
        }
    }
    private func naviToNextVC(resultImage: UIImage) {
        let VC = DDPreViewVC()
        VC.resultImage = resultImage
        navigationController?.pushViewController(VC, animated: true)
    }
}
extension ViewController: DDPictureListViewDelegate {
    // 点击底部图片
    func didSelectItem(_ image: UIImage!, isCover: Bool) {
        if isCover {
            // 封面图
            refreshCoverView(image)
        } else {
            // 贴纸
            self.chooseEditView?.isChoose = false
            let tagsEditView = DDBaseEditView()
            let width = Adapt(80)
            tagsEditView.contenImage = image
            tagsEditView.baseDelegate = self
            tagsEditView.isChoose = true
            self.editContainerView.insertSubview(tagsEditView, belowSubview: self.dashCutView)
            tagsEditView.makeConstraints { (make) in
                make.center.equalTo(self.dashCutView).offset(CGFloat(arc4random() % 15 + 5))
                make.width.equalTo(width)
                make.height.equalTo(width * (image.size.height / image.size.width))
            }
            self.chooseEditView = tagsEditView
        }
    }
    private func refreshCoverView(_ coverImage: UIImage) {
        // 图片宽高比
        let imageScale = coverImage.size.width / coverImage.size.height
        // 虚线框宽高比
        self.dashCutView.layoutIfNeeded()
        let cutScale = self.dashCutView.DD_width / self.dashCutView.DD_height
        
        if let coverView = self.coverView {
            coverView.contenImage = coverImage
            coverView.remakeConstraints { make in
                make.center.equalTo(self.dashCutView)
                if cutScale < imageScale {
                    // 纵向铺满
                    make.height.equalTo(self.dashCutView)
                    make.width.equalTo(self.dashCutView.DD_height*imageScale)
                } else {
                    // 横向铺满
                    make.width.equalTo(self.dashCutView)
                    make.height.equalTo(self.dashCutView.DD_width/imageScale)
                }
            }
        } else {
            // 没有封面视图就创建
            let coverImageView = DDBaseEditView()
            coverImageView.baseDelegate = self
            coverImageView.isCanCopy = false
            coverImageView.backgroundColor = .clear
            coverImageView.contenImage = coverImage
            self.coverView = coverImageView
            self.editContainerView.insertSubview(coverImageView, at: 0)
            coverImageView.makeConstraints { make in
                make.center.equalTo(self.dashCutView)
                if cutScale < imageScale {
                    // 纵向铺满
                    make.height.equalTo(self.dashCutView)
                    make.width.equalTo(self.dashCutView.DD_height*imageScale)
                } else {
                    // 横向铺满
                    make.width.equalTo(self.dashCutView)
                    make.height.equalTo(self.dashCutView.DD_width/imageScale)
                }
            }
        }
    }
}
//MARK: ---------------------- 编辑文字视图的代理方法
extension ViewController: DDCustomTextViewDelegate {
    /// 点击取消
    func cancel(view: DDCustomTextView, content: String, fontFamily: String, textColor: UIColor, derection: DDEditViewContentTextDerection, size: CGSize, isCreate: Bool) {
        if isCreate {
            /// 把创建的视图移除
            self.chooseEditView?.removeFromSuperview()
            self.chooseEditView = nil
        } else {
            self.chooseEditView!.contentText = content
            self.chooseEditView!.contentTextColor = textColor
            self.chooseEditView!.contentTextDerection = derection
            self.chooseEditView!.updateConstraints { (make) in
                make.width.equalTo(size.width)
                make.height.equalTo(size.height)
            }
        }
        
    }
    /// 修改方向
    func changeDerection(view: DDCustomTextView) {
        if let eidtView = self.chooseEditView {
            let size = self.getEditTextSize()
            eidtView.updateConstraints { (make) in
                make.width.equalTo(size.width)
                make.height.equalTo(size.height)
            }
        }
    }
    /// 修改文字内容
    func contentTextDidChange(View: DDCustomTextView, content: String) {
        if let eidtView = self.chooseEditView {
            let size = self.getEditTextSize()
//            refreshUploadTextButton(isEdit: true)
            eidtView.updateConstraints { (make) in
                make.width.equalTo(size.width)
                make.height.equalTo(size.height)
            }
        }
    }
}
extension ViewController: DDBaseEditViewDelegate {
    //MARK: --------------------------  编辑视图代理事件
    func baseViewDidTap(view: DDBaseEditView) {
        self.chooseEditView?.isChoose = false
        self.chooseEditView = view
        self.chooseEditView?.isChoose = true
    }
    
    func baseViewColseAction(view: DDBaseEditView) {
        if view == self.coverView {
            self.coverView = nil
        }
        self.chooseEditView = nil
    }
    
    func baseViewRotateAction(view: DDBaseEditView) {
        
    }
}
extension ViewController {
    //MARK: --------------------------  工具方法
    /// 计算字体文字编辑视图的尺寸
    func getEditTextSize() -> CGSize {
        if let editTextView = self.chooseEditView {
            let contentText = editTextView.contentText
            let fontSize = editTextView.contentTextFontSize
            let font = UIFont.systemFont(ofSize: fontSize)
            let minSize = min(editTextView.contentSize.width, editTextView.contentSize.height)
            
            if editTextView.contentTextDerection == .vertical {
                editTextView.contentTextDerection = .vertical
                let height = editTextView.verticalContentText.calculateTextHeight(font: font, width: minSize - Adapt(10) - Adapt(20))
                return CGSize(width: minSize, height: height + Adapt(40))
            } else {
                editTextView.contentTextDerection = .horizontal
                let width = contentText!.calculateTextWidth(font: font, height: minSize - Adapt(10) - Adapt(20))
                return CGSize(width: width + Adapt(40), height: minSize)
            }
        }
        return .zero
    }
}
