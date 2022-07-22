//
//  DDRightMenuView.swift
//  CompositePicture
//
//  Created by Meet on 2022/7/20.
//

import UIKit

protocol DDRightMenuViewDelegate {
    func rightView(_ rightView: DDRightMenuView, didSelectIndex index: Int)
}

class DDRightMenuView: UIView {
    var delegate: DDRightMenuViewDelegate?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension DDRightMenuView {
    private func configUI() {
        let iconArray = ["DIY_text", "DIY_mirror_left", "DIY_mirror_up", "DIY_copy", "DIY_reset", "DIY_next"]
        var markView: UIView!
        for i in 0..<iconArray.count {
            let menuButton = UIButton()
            menuButton.addTarget(self, action: #selector(clickMenuAction(_:)), for: .touchUpInside)
            menuButton.tag = 10 + i;
            self.addSubview(menuButton)
            menuButton.makeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.height.width.equalTo(Adapt(45))
                if i == 0 {
                    make.top.equalToSuperview()
                } else {
                    make.top.equalTo(markView.snp.bottom)
                }
                if i == iconArray.count - 1 {
                    make.bottom.equalToSuperview()
                }
            }
            markView = menuButton
            
            let iconImage = UIImage(named: iconArray[i])
            let imageWidth = Adapt(35)
            let imageHeight = iconImage!.size.height/iconImage!.size.width*imageWidth
            let iconImageView = UIImageView()
            iconImageView.image = iconImage
            menuButton.addSubview(iconImageView)
            iconImageView.makeConstraints { make in
                make.center.equalToSuperview()
                make.size.equalTo(CGSize(width: imageWidth, height: imageHeight))
            }
        }
    }
    @objc private func clickMenuAction(_ button: UIButton) {
        delegate?.rightView(self, didSelectIndex: button.tag - 10)
    }
}
