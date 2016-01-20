//
//  ZHFannedModel.swift
//  ZHAnimationPie
//
//  Created by user on 16/1/19.
//  Copyright © 2016年 personal. All rights reserved.
//

import UIKit

class ZHFannedModel: NSObject {
    var color:UIColor?
    var value:Float?
    var text:String?
    //重载构造函数
    init(color:UIColor, value:Float, text:String?){
        self.color = color
        self.value = value
        self.text = text
        super.init()
    }
}

