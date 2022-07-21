//
//  DDChooseColorView.swift
//  qieMoJiClient
//
//  Created by Meet on 2021/4/13.
//  Copyright © 2021 Lensun. All rights reserved.
//

import UIKit

private let viewHeight = (185.0 / 211 * DD_ScreenWidth)

class DDChooseColorView: UIView {
    
    var block: ((UIColor)->())?
    
    
    init(frame: CGRect, block: ((UIColor)->())?) {
        self.block = block
        super.init(frame: frame)
        configNewView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 图片视图
    lazy var colorPieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "colorSet")
//        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    lazy var maskControl: UIControl = {
        let control = UIControl(frame: CGRect(x: 0, y: 0, width: DD_ScreenWidth, height: DD_ScreenHeight))
        control.backgroundColor = .clear
        control.addTarget(self, action: #selector(dissmissView), for: .touchUpInside)
        return control
    }()
}
//MARK: -------------------------- UI
extension DDChooseColorView {
    @discardableResult
    static func show(block: ((UIColor) -> ())? = nil) -> DDChooseColorView {
        return DDChooseColorView(frame: CGRect(x: 0, y: DD_ScreenHeight, width: DD_ScreenWidth, height: viewHeight), block: block)
    }
    func configNewView() {
        DD_KeyWindow?.addSubview(maskControl)
        DD_KeyWindow?.addSubview(self)
        self.backgroundColor = DD_GrayBgColor
        self.addSubview(colorPieImageView)
        self.layer.borderWidth = 0.5
        self.layer.borderColor = DD_GrayLineColor.cgColor
        colorPieImageView.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: DD_ScreenWidth, height: viewHeight))
        }

        UIView.animate(withDuration: 0.25) {
            self.DD_top = DD_ScreenHeight - viewHeight
        }
    }
}

extension DDChooseColorView {
    @objc func dissmissView() {
        UIView.animate(withDuration: 0.25) {
            self.DD_top = DD_ScreenHeight
        } completion: { (finish) in
            if finish {
                self.maskControl.removeFromSuperview()
                self.removeFromSuperview()
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let point = touch?.location(in: self.colorPieImageView)
        if let point = point  {
            let color = self.colorPieImageView.getColor(point: point)
            if let block = block {
                block(color)
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let point = touch?.location(in: self.colorPieImageView)
        if let point = point  {
            let color = self.colorPieImageView.getColor(point: point)
            if let block = block {
                block(color)
            }
        }
    }
    
}


