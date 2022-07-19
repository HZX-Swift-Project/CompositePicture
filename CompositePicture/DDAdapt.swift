//
//  DDAdapt.swift
//  CompositePicture
//
//  Created by Meet on 2022/7/19.
//

import UIKit

/// 适配比例
let DD_Scale: CGFloat = UIScreen.main.bounds.size.width / 375.0

/// 自动适配
func AdaptSize(_ num: CGFloat) -> CGFloat {
    return num * DD_Scale
}
extension Int {
    var adapt: CGFloat {return DD_Scale * CGFloat(self)}
}
extension Float {
    var adapt: CGFloat {return DD_Scale * CGFloat(self)}
}
extension Double {
    var adapt: CGFloat {return DD_Scale * CGFloat(self)}
}
