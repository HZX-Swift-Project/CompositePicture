//
//  DDPreViewVC.swift
//  CompositePicture
//
//  Created by Meet on 2022/7/21.
//

import UIKit

class DDPreViewVC: UIViewController {
    var resultImage: UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        guard let resultImage = resultImage else { return }
        let resultImageView = UIImageView()
        resultImageView.backgroundColor = .green
        resultImageView.image = resultImage
        view.addSubview(resultImageView)
        resultImageView.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.75)
            make.width.equalTo(resultImageView.snp.height).multipliedBy(resultImage.size.width/resultImage.size.height)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
