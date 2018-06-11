//
//  UIBarButtonItem_Extension.swift
//  DYLive_Swift
//
//  Created by qujiahong on 2018/6/11.
//  Copyright © 2018年 瞿嘉洪. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    
    //为UIBarButtonItem扩展类方法
    class func createItem(imageName : String, highImageName : String, itemSize : CGSize) -> UIBarButtonItem {
        
        let btn = UIButton()
        
        btn.setImage(UIImage(named: imageName), for: .normal)
        btn.setImage(UIImage(named: highImageName), for: .highlighted)
        
        btn.frame = CGRect(origin: CGPoint.zero, size: itemSize)
        
        return UIBarButtonItem(customView: btn)
    }
    
    //为UIBarButtonItem扩展构造
    //便利构造函数：1.convenience开头。2.在构造函数中必须明确调用一个设计构造函数(self)
    convenience init(imageName : String, highImageName : String = "", itemSize : CGSize = CGSize.zero) {
        
        let btn = UIButton()
        btn.setImage(UIImage(named: imageName), for: .normal)
        if highImageName != "" {
            btn.setImage(UIImage(named: highImageName), for: .highlighted)
        }
        
        if itemSize == CGSize.zero {
            btn.sizeToFit()
        }else{
            btn.frame = CGRect(origin: CGPoint.zero, size: itemSize)
        }
        
        self.init(customView: btn)
    }
}
