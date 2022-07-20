//
//  DDPictureListView.swift
//  CompositePicture
//
//  Created by Meet on 2022/7/19.
//

import UIKit

class DDPictureListView: UIView {
    private let cellReusedId = "pictureCell"
    // 背景图片数组
    var coverList: [String] {
        var array = [String]()
        for index in 1 ... 9 {
            array.append(String(format: "cover%02d", index))
        }
        return array
    }
    // 标签数组
    var tagList: [String] {
        var array = [String]()
        for index in 1 ... 7 {
            array.append(String(format: "tag%02d", index))
        }
        return array
    }
    private var pictureList: [String] = []
    // 是否是封面列表
    var isCover: Bool = true {
        didSet {
            self.pictureList = self.isCover ? coverList : tagList
            self.collectionView.reloadData()
        }
    }
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.addSubview(collectionView)
        collectionView.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        }
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(PictureCollectionViewCell.self, forCellWithReuseIdentifier: cellReusedId)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DDPictureListView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictureList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReusedId, for: indexPath) as! PictureCollectionViewCell
        cell.pictureImageView.image = UIImage(named: pictureList[indexPath.item])
        cell.pictureImageView.contentMode = isCover ? .scaleAspectFill : .scaleAspectFit
        return cell
    }
}

extension DDPictureListView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Adapt(50), height: Adapt(90))
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: Adapt(5), bottom: 0, right: Adapt(5))
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Adapt(5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.01
    }
    
}
