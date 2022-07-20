//
//  String+DDHelper.swift
//  DDSwiftToolProject
//
//  Created by Meet on 2020/4/27.
//  Copyright © 2020 houZhongXiang. All rights reserved.
//

import UIKit

// MARK: -------------- 获取字符串中一段字符串的相关操作
extension String {
    /// 获取字符串某个索引的字符（从前往后）
    /// - Parameter index: 索引值 是从0开始算的
    /// - Returns: 处理后的字符串
    public func getCharAdvance(index: Int) -> String {
        assert(index < self.count, "哦呵~ 字符串索引越界了！")
        let positionIndex = self.index(self.startIndex, offsetBy: index)
        let char = self[positionIndex]
        return String(char)
    }
    
    /// 获取字符串第一个字符
    /// - Returns: 处理后的字符串
    public func getFirstChar() -> String {
        return getCharAdvance(index: 0)
    }
    
    /// 获取字符串某个索引的字符（从后往前）
    /// - Parameter index: 索引值
    /// - Returns: 处理后的字符串
    public func getCharReverse(index: Int) -> String {
        assert(index < self.count, "哦呵~ 字符串索引越界了！")
        //在这里做了索引减1，因为endIndex获取的是 字符串最后一个字符的下一位
        let positionIndex = self.index(self.endIndex, offsetBy: -index - 1)
        let char = self[positionIndex]
        return String(char)
    }
    
    /// 获取字符串最后一个字符
    /// - Returns: 处理后的字符串
    public func getLastChar() -> String {
        return getCharReverse(index: 0)
    }
    
    /// 获取某一串字符串按索引值 （前闭后开 包含前边不包含后边）
    /// - Parameters:
    ///   - start: 开始的索引
    ///   - end: 结束的索引
    /// - Returns: 处理后的字符串
    public func getString(startIndex: Int, endIndex: Int) -> String {
        let start = self.index(self.startIndex, offsetBy: startIndex)
        let end = self.index(self.startIndex, offsetBy: endIndex)
        return String (self[start ..< end])
    }
    
    /// 获取某一串字符串按数量
    /// - Parameters:
    ///   - startIndex: 开始索引
    ///   - count: 截取个数
    /// - Returns: 处理后的字符串
    public func getString(startIndex: Int, count: Int) -> String {
        return getString(startIndex: startIndex, endIndex: startIndex + count)
    }
    
    /// 截取字符串从某个索引开始截取 包含当前索引
    /// - Parameter startIndex: 开始索引
    /// - Returns: 截取后的字符串
    public func subStringFrom(startIndex: Int) -> String {
        return getString(startIndex: startIndex, endIndex: self.count)
    }
    
    /// 截取字符串（从开始截取到想要的索引位置）不包含当前索引
    /// - Parameter endIndex: 结束索引
    /// - Returns: 截取后的字符串
    public func subStringTo(endIndex: Int) -> String {
        return getString(startIndex: 0, endIndex: endIndex)
    }
    
    /// 利用subscript 获取某个位置的字符串
    subscript(index: Int) -> String {
        let startIndex = self.index(self.startIndex, offsetBy: index)
        let endIndex = self.index(startIndex, offsetBy: 1)
        return String(self[startIndex ..< endIndex])
    }
}

// MARK: -------------- 计算字符串的尺寸
extension String {
    
    /// 计算字体的宽度
    /// - Parameters:
    ///   - font: 字体大小
    ///   - height: label高度
    /// - Returns: 字体宽度
    public func calculateTextWidth(font: UIFont, height: CGFloat) -> CGFloat {
        let attributes = [NSAttributedString.Key.font: font]
        let option = NSStringDrawingOptions.usesLineFragmentOrigin
        let rect:CGRect = self.boundingRect(with: CGSize(width: CGFloat.infinity, height: height), options: option, attributes: attributes, context: nil)
        return rect.size.width;
    }
    
    /// 计算字体的高度
    /// - Parameters:
    ///   - font: 字体大小
    ///   - width: 文字宽度
    /// - Returns: 字体高度
    public func calculateTextHeight(font: UIFont, width: CGFloat) -> CGFloat {
        let attributes = [NSAttributedString.Key.font: font]
        let option = NSStringDrawingOptions.usesLineFragmentOrigin
        let rect:CGRect = self.boundingRect(with: CGSize(width: width, height: CGFloat.infinity), options: option, attributes: attributes, context: nil)
        return rect.size.height;
    }
}

// MARK: ----------------- 特殊处理
extension String {
    /// 把空格字符串替换为%20
    public func replaceWhiteSpaceToPercent20() -> String {
        let str = self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? self
        return str
    }
    
    /// 去除字符串中的所有空格
    /// - Returns: 返回处理后的结果
    public func trimmingAllWhiteSpaces() -> String {
        let tempStr = self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        return tempStr.replacingOccurrences(of: " ", with: "")
    }
    
    /// 判断是否是空符串（去除空格之后）
    public func isEmptyString() -> Bool {
        return self.trimmingAllWhiteSpaces().isEmpty
    }
    
    /// 手机号加密
    /// - Returns: 隐藏后的手机号
    public func encodeTelphone() -> String {
        let phoneStr = self.trimmingAllWhiteSpaces()
        if phoneStr.count == 11 {
            let start = self.index(self.startIndex, offsetBy: 3)
            let endIndex = self.index(self.startIndex, offsetBy: self.count - 4)
            return self.replacingCharacters(in: start ..< endIndex, with: "****")
        } else {
            return self
        }
    }
    
    /// 字符串Base64编码
    /// - Returns: 编码后的字符串
    func DDBase64Encoding() -> String {
        let plainData = self.data(using: String.Encoding.utf8)
        let base64String = plainData?.base64EncodedString(options: NSData.Base64EncodingOptions.init(rawValue: 0))
        return base64String!
    }
    
}
