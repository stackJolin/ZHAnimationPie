//
//  ViewController.swift
//  ZHAnimationPie
//
//  Created by user on 16/1/19.
//  Copyright © 2016年 personal. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let model1:ZHFannedModel = ZHFannedModel(color: UIColor.redColor(), value: 0.5, text: nil)
        let model2:ZHFannedModel = ZHFannedModel(color: UIColor.greenColor(), value: 0.2, text: nil)
        let model3:ZHFannedModel = ZHFannedModel(color: UIColor.yellowColor(), value: 0.3, text: nil)
        
        let animationPie:ZHAnimationPie = ZHAnimationPie(frame: CGRectMake(0, 0, 100, 100), values: [model1, model2, model3])
        
        self.view.addSubview(animationPie)
        
        animationPie.reloadData()
    }

}

