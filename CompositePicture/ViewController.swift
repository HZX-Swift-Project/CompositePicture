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
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = DD_DefaultBgColor
        configUI()
    }
}
extension ViewController {
    //MARK: -------------------------- UI界面
    private func configUI() {
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
        collectionView.isCover = true
        view.addSubview(collectionView)
        collectionView.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(Adapt(90))
            make.bottom.equalTo(bottomButtonView.snp.top).offset(-Adapt(10))
        }
    }
}
extension ViewController {
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
