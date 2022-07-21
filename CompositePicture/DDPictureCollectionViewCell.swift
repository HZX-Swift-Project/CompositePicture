//
//  PictureCollectionViewCell.swift
//  CompositePicture
//
//  Created by Meet on 2022/7/20.
//

import UIKit

class DDPictureCollectionViewCell: UICollectionViewCell {
    
    lazy var pictureImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        configNewView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configNewView() {
        contentView.addSubview(pictureImageView)
        pictureImageView.image = UIImage(named: "cover01")
        pictureImageView.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
        self.roundSize(size: Adapt(5))
    }
}
