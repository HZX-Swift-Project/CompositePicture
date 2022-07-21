//
//  DDCustomTextView.swift
//  qieMoJiClient
//
//  Created by Meet on 2021/4/6.
//  Copyright © 2021 Lensun. All rights reserved.
//

import UIKit

/// 定制界面没有输入内容
let DD_DesignEditTextViewEmpty = "请输入文字内容"

protocol DDCustomTextViewDelegate {
    /// 点击取消的回调
    func cancel(view: DDCustomTextView, content: String, fontFamily:String, textColor: UIColor, derection: DDEditViewContentTextDerection, size: CGSize, isCreate: Bool)
    /// 切换方向
    func changeDerection(view: DDCustomTextView)
    /// 内容变化了
    func contentTextDidChange(View: DDCustomTextView, content: String)
}

class DDCustomTextView: UIView {
    var delegate: DDCustomTextViewDelegate?
    /// 是否是创建视图
    var isCreate = true
    /// 是否点击了取消
    var isClickCancel = false
    
    var editView: DDBaseEditView!
    /// 传入过来的默认值
    private var currentContentText: String!
    private var currentTextColor: UIColor!
    private var currentTextFontFamily: String!
    private var currentDerection: DDEditViewContentTextDerection!
    private var currentSize: CGSize!
    /// 创建视图的基本数据
    private var createTextColor: UIColor!
    private var createTextFontFamily: String!
    private var currentDerectionDerection = DDEditViewContentTextDerection.horizontal
    
    /// 字体名称
    private lazy var textColorArray = [UIColor.color(hex: "18499d"), UIColor.color(hex: "70c5cd"), UIColor.color(hex: "6cba55"), UIColor.color(hex: "e2e439"), UIColor.color(hex: "dc9852"), UIColor.color(hex: "c25b97"), UIColor.color(hex: "ce4969"), UIColor.color(hex: "4350a0"), UIColor.color(hex: "454444"), UIColor.color(hex: "ffffff"), UIColor.color(hex: "47623d"),UIColor.color(hex: "000000")]
    
    /// 颜色视图
    private var colorFamilyView: UIView!
    
    lazy var inputBgView: UIView = {
        let bgView = UIView(frame: CGRect(x: 0, y: DD_ScreenHeight - Adapt(50) - DD_BottomSafeAreaHeight, width: DD_ScreenWidth, height: Adapt(50)))
        bgView.backgroundColor = DD_BlueColor
        
        let textBgView = UIView()
        textBgView.backgroundColor = .white
        bgView.addSubview(textBgView)
        textBgView.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets(top: Adapt(5), left: Adapt(20), bottom: Adapt(5), right: Adapt(20)))
        }
        textBgView.roundSize(size: 5)
        
        let textField = UITextField()
        textField.text = self.editView.contentText
        textField.textColor = DD_BlueColor
        textField.font = UIFont.systemFont(ofSize: Adapt(16))
        textField.backgroundColor = .clear
        textField.delegate = self
        textField.becomeFirstResponder()
        textField.returnKeyType = .done
        textField.placeholder = DD_DesignEditTextViewEmpty
        textBgView.addSubview(textField)
        textField.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: Adapt(10), bottom: 0, right: Adapt(10)))
        }
        return bgView
    }()
    
    
    @discardableResult
    static func showCustomView(editView: DDBaseEditView) -> DDCustomTextView {
        return DDCustomTextView(frame: CGRect(x: 0, y: 0, width: DD_ScreenWidth, height: DD_ScreenHeight), editView: editView)
    }
    init(frame: CGRect, editView: DDBaseEditView) {
        self.isCreate = editView.contentText!.isEmptyString()
        self.editView = editView
        self.currentContentText = editView.contentText!
        self.currentTextColor = editView.contentTextColor
        self.currentDerection = editView.contentTextDerection
        self.currentSize = editView.contentSize
        super.init(frame: frame)
        configNewView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension DDCustomTextView {
    func configNewView() {
        self.backgroundColor = UIColor.color(hex: "ffffff", alpha: 0.25)
        DD_KeyWindow?.addSubview(self)
        /// 颜色
        configColorView()
        /// 横竖切换
        let derectionButton = UIButton()
        derectionButton.setTitle(exchangeText("横竖切换"), for: .normal)
        derectionButton.setTitleColor(DD_GrayTextColor, for: .normal)
        derectionButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13 * DD_Scale)
        derectionButton.backgroundColor = DD_DefaultBgColor
        derectionButton.addTarget(self, action: #selector(changeDerectionAction), for: .touchUpInside)
        self.addSubview(derectionButton)
        derectionButton.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalTo(colorFamilyView.snp.bottom).offset(2)
            make.height.equalTo(Adapt(35))
        }
        derectionButton.setSixBorder(.right)
        self.addSubview(inputBgView)
        
        /// 取消
        let cancelButton = UIButton()
        cancelButton.setTitle(exchangeText("取消"), for: .normal)
        cancelButton.setTitleColor(DD_GrayTextColor, for: .normal)
        cancelButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13 * DD_Scale)
        cancelButton.backgroundColor = .white
        cancelButton.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        self.addSubview(cancelButton)
        cancelButton.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.top.height.equalTo(derectionButton)
        }
        cancelButton.setSixBorder(.left, borderColor: UIColor.color(hex: "b4b4b5"), borderWidth: 2.0)
       
        /// 横竖切换
        let confirmButton = UIButton()
        confirmButton.setTitle(exchangeText("确定  "), for: .normal)
        confirmButton.setTitleColor(.white, for: .normal)
        confirmButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13 * DD_Scale)
        confirmButton.backgroundColor = UIColor.color(hex: "8fafdb")
        confirmButton.addTarget(self, action: #selector(confirmAction), for: .touchUpInside)
        self.insertSubview(confirmButton, belowSubview: cancelButton)
        confirmButton.makeConstraints { (make) in
            make.right.equalTo(cancelButton.snp.left).offset(Adapt(15))
            make.top.height.equalTo(cancelButton)
        }
        confirmButton.setSixBorder(.left, borderColor: UIColor.color(hex: "b4b4b5"), borderWidth: 2.0)
    }
    /// 创建顶部颜色视图
    func configColorView() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardChangeFrame), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        colorFamilyView = UIView()
        colorFamilyView.backgroundColor = .white
        self.addSubview(colorFamilyView)
        colorFamilyView.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(DD_StatusBarHeight)
            make.height.equalTo(Adapt(25))
        }
        colorFamilyView.layer.borderWidth = 1.0
        colorFamilyView.layer.borderColor = DD_GrayTextColor.cgColor
        
        let mainLabel = UILabel()
        mainLabel.text = exchangeText("颜色  ")
        mainLabel.font = UIFont.boldSystemFont(ofSize: 13 * DD_Scale)
        mainLabel.textColor = .white
        mainLabel.backgroundColor = UIColor.color(hex: "b4b4b5")
        colorFamilyView.addSubview(mainLabel)
        mainLabel.makeConstraints { (make) in
            make.left.top.bottom.equalToSuperview()
        }

        let menuScrollView = UIScrollView()
        menuScrollView.backgroundColor = .clear
        menuScrollView.showsHorizontalScrollIndicator = false
        colorFamilyView.addSubview(menuScrollView)
        menuScrollView.makeConstraints { (make) in
            make.left.equalTo(mainLabel.snp.right).offset(-Adapt(15))
            make.right.top.bottom.equalToSuperview()
        }
        
        var markView: UIView?
        for index in 0..<textColorArray.count {
            let menuButton = UIButton()
            if index != textColorArray.count - 1 {
                menuButton.backgroundColor = textColorArray[index]
            }
            menuButton.tag = 200 + index
            menuButton.addTarget(self, action: #selector(changeTextColorAction(_:)), for: .touchUpInside)
            menuScrollView.addSubview(menuButton)
            menuButton.makeConstraints { (make) in
                make.top.height.equalToSuperview()
                
                if index == 0 {
                    make.left.equalToSuperview()
                }  else {
                    make.left.equalTo(markView!.snp.right).offset(-Adapt(15))
                }
                if index == textColorArray.count - 1  {
                    make.width.equalTo(Adapt(100))
                    make.right.equalTo(0)
                } else {
                    make.width.equalTo(Adapt(40))
                }
            }
            menuButton.setSixBorder(.left)
            markView = menuButton
            if index == textColorArray.count - 1 {
                menuButton.layoutIfNeeded()
                let gradientLayer = CAGradientLayer()
                gradientLayer.colors = [UIColor.color(hex: "ff003e").cgColor,
                                        UIColor.color(hex: "1200ff").cgColor,
                                        UIColor.color(hex: "00ff24").cgColor,
                                        UIColor.color(hex: "fcff00").cgColor,
                                        UIColor.color(hex: "ff3c00").cgColor,
                ]
                gradientLayer.locations = [0.25, 0.5, 0.75, 1.0]
                gradientLayer.startPoint = CGPoint(x: 0, y: 0)
                gradientLayer.endPoint = CGPoint(x: 1.0, y: 0)
                gradientLayer.frame = CGRect(x: 0, y: 0, width: menuButton.DD_width, height: menuButton.DD_height);
                menuButton.layer.addSublayer(gradientLayer)
            }
        }
    }
}

extension DDCustomTextView {
    private func exchangeText(_ text: String) -> String {
        let whiteSpace = "    "
        return whiteSpace + text + whiteSpace
    }
    /// 修改字体颜色
    @objc private func changeTextColorAction(_ button: UIButton) {
        if button.tag != 200 + textColorArray.count - 1 {
            let color = textColorArray[button.tag - 200]
            self.editView.contentTextColor = color
        } else {
            DD_KeyWindow?.endEditing(true)
            DDChooseColorView.show { (color) in
                self.editView.contentTextColor = color
            }
        }
    }
    /// 修文字方向
    @objc private func changeDerectionAction() {
        DD_KeyWindow?.endEditing(true)
        guard !self.editView.contentText!.isEmptyString() else {
            DDMBProgressHUD.showTipMessage(DD_DesignEditTextViewEmpty)
            return
        }
        
        if let delegate = delegate {
            self.editView.contentTextDerection.toggle()
            delegate.changeDerection(view: self)
        }
    }
    
    /// 确定
    @objc private func confirmAction() {
        DD_KeyWindow?.endEditing(true)
        guard !self.editView.contentText!.isEmptyString() else {
            DDMBProgressHUD.showTipMessage(DD_DesignEditTextViewEmpty)
            return
        }
        self.removeFromSuperview()
    }
    /// 取消
    @objc private func cancelAction() {
        isClickCancel = true
        if let delegate = delegate {
            delegate.cancel(view: self, content: self.currentContentText, fontFamily: self.currentTextFontFamily, textColor: self.currentTextColor, derection: self.currentDerection, size: self.currentSize, isCreate: isCreate)
        }
        self.removeFromSuperview()
    }
}

extension DDCustomTextView: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if isClickCancel {
            return
        }
        guard let content = textField.text, !content.isEmptyString() else {
            DDMBProgressHUD.showTipMessage(DD_DesignEditTextViewEmpty)
            return
        }
        self.editView.contentText = content
        if let delegate = delegate {
            delegate.contentTextDidChange(View: self, content: content)
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       endEditing(true)
    }
}

//MARK: -------------------------- 通知方式
extension DDCustomTextView {
    @objc func keyboardChangeFrame(notification: Notification) {
        let userInfo = notification.userInfo! as Dictionary
        let value = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        let keyBoardRect = value.cgRectValue
        // 得到键盘高度
//        let keyBoardHeight = keyBoardRect.size.height
        // 得到键盘弹出所需时间
        let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        let isShowKeyboard = keyBoardRect.origin.y < DD_ScreenHeight
        UIView.animate(withDuration: duration) {
            if isShowKeyboard {
                self.inputBgView.DD_bottom = keyBoardRect.origin.y
            } else {
                self.inputBgView.DD_bottom = keyBoardRect.origin.y - DD_BottomSafeAreaHeight
            }
        }
    }
}
