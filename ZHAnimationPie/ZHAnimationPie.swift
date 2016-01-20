//
//  ZHAnimationPie.swift
//  ZHAnimationPie
//
//  Created by user on 16/1/19.
//  Copyright © 2016年 personal. All rights reserved.
//

import UIKit

class ZHAnimationPie: UIView {
    
    //扇形的半径
    private var pieRadius:CGFloat? = 0
    //所有扇形的角度起始值数组
    private var startAngleArray:NSMutableArray = NSMutableArray()
    //所有扇形的角度终止值数组
    private var endAngleArray:NSMutableArray = NSMutableArray()
    //百分比数组
    private var percentArray:NSMutableArray = NSMutableArray()
    //遮罩层
    private var maskLayer:ZHShapeLayer?
    
    //存储所有扇形的model
    private var valueArray: [ZHFannedModel] = [ZHFannedModel]()
    //所有的扇形
    private var fanArray:[ZHShapeLayer] = [ZHShapeLayer]()
    //所有的Label
    private var fanLabels:[UILabel] = [UILabel]()
    //记录位置偏移Layer的Index
    private var transMakeLayerIndex:Int = -1
    //重载构造函数
    init(frame:CGRect,values:[ZHFannedModel]){
        valueArray = values
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
        let tapGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "clickPieView:")
        self.addGestureRecognizer(tapGesture)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //刷新数据
    func reloadData(){
        performAnimation()
    }
    
    private func performAnimation(){
        //移除之前的动画
        self.maskLayer?.removeAllAnimations()
        //数据分组
        self.setDataGroups()
        //根据分组创建扇形对应的layer
        self.createLayer()
        //创建label
        self.createFanLabels()
        //创建layer的遮罩
        self.createmaskLayer()
        //执行遮罩层的动画
        self.startAnimation()
    }
    //数据分组
    private func setDataGroups(){
        self.pieRadius = self.bounds.width * 0.5
        print(self.pieRadius)
        //遍历values
        var currentSum:Float = 0
        for model:ZHFannedModel in self.valueArray {
            self.startAngleArray.addObject(NSNumber(float: currentSum))
            currentSum += Float(model.value!)
            self.endAngleArray.addObject(NSNumber(float:currentSum))
            self.percentArray.addObject(NSNumber(float:model.value!))
        }
    }
    //根据分组创建扇形对应的Layer
    private func createLayer(){
        //Block的遍历方式比for快
        for (i,_) in self.valueArray.enumerate() {
            let subLayer:ZHShapeLayer = self.creatreSubLayer(i)
            self.layer.addSublayer(subLayer)
            self.fanArray.append(subLayer)
        }
    }
    //创建具体的某一个扇形layer
    private func creatreSubLayer(index:Int) -> ZHShapeLayer{
        let startAngle:Float = self.startAngleArray[index].floatValue * 2 * Float(M_PI)
        let endAngle:Float = self.endAngleArray[index].floatValue * 2 * Float(M_PI)
        print(startAngle, endAngle)
        let model:ZHFannedModel = self.valueArray[index]
        
        //下面这种写法是错误的,CALyer以及ZHShapeLayer都没有用frame初始化的方法,需要手动去指定frame
//        let subLayer:ZHShapeLayer = ZHShapeLayer(frame:self.bounds)
        let subLayer:ZHShapeLayer = ZHShapeLayer()
        subLayer.frame = self.bounds
        subLayer.lineWidth = 0;
        subLayer.strokeColor = UIColor.clearColor().CGColor
        subLayer.fillColor = model.color!.CGColor
        let path:UIBezierPath = UIBezierPath(arcCenter: CGPointMake(self.bounds.width * 0.5, self.bounds.height * 0.5), radius: self.pieRadius!, startAngle: CGFloat(startAngle), endAngle: CGFloat(endAngle), clockwise: true)
        path.addLineToPoint(CGPointMake(self.bounds.width * 0.5, self.bounds.height * 0.5))
        path.closePath()
        subLayer.path = path.CGPath
        
        return subLayer
    }
    //创建遮罩层
    private func createmaskLayer(){
        let maskLayer:ZHShapeLayer = ZHShapeLayer()
        maskLayer.frame = self.bounds
        let path:UIBezierPath = UIBezierPath(arcCenter: CGPointMake(self.bounds.width * 0.5, self.bounds.height * 0.5), radius: CGFloat(self.pieRadius!), startAngle: CGFloat(-0.5 * M_PI), endAngle: CGFloat(1.5 * M_PI), clockwise: true)
        maskLayer.path = path.CGPath
        maskLayer.lineWidth = CGFloat(self.pieRadius!) * 2
        maskLayer.strokeColor = UIColor.greenColor().CGColor
        maskLayer.fillColor = UIColor.clearColor().CGColor
        self.layer.mask = maskLayer
        self.maskLayer = maskLayer
    }
    //执行遮罩层动画
    private func startAnimation(){
        //创建动画
        let animation:CABasicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = (0)
        animation.toValue = (1)
        animation.duration = 5
        animation.removedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        self.maskLayer?.addAnimation(animation, forKey: "animateWithMaskLayer")
    }
    
    //创建所有的fanLabel
    private func createFanLabels(){
        for i in 0..<self.valueArray.count{
            let fanLabel:UILabel = percentLabel(i)
            self.addSubview(fanLabel)
            fanLabels.append(fanLabel)
        }
    }
    
    //单个百分比label创建
    private func percentLabel(index:Int) -> UILabel{
        //获取subLayer的中心角度
        let centerAngle:Float = (self.startAngleArray[index].floatValue + self.endAngleArray[index].floatValue) * 2 * Float(M_PI) * 0.5
        //计算subLayer中心点的坐标
        let centerX:CGFloat = (self.pieRadius! + CGFloat(cos(centerAngle)) * 0.5 * self.pieRadius! * 1.2)
        let centerY:CGFloat = (self.pieRadius! + CGFloat(sin(centerAngle)) * 0.5 * self.pieRadius! * 1.2)
        //创建Label
        let label:UILabel = UILabel()
        label.text = NSString(string: "\(self.percentArray[index].floatValue * 100)%") as String
        label.textAlignment = NSTextAlignment.Center
        label.backgroundColor = UIColor.clearColor()
        label.font = UIFont.systemFontOfSize(10)
        label.sizeToFit()
        label.center = CGPointMake(centerX, centerY)
        return label
    }
}

//Mark - 手势点击方法
extension ZHAnimationPie{
    @objc private func clickPieView(gesture:UITapGestureRecognizer){
        let location:CGPoint = gesture.locationInView(gesture.view)
        //var transform:CGAffineTransform = CGAffineTransformIdentity
        for (i,subLayer) in self.fanArray.enumerate() {
            if CGPathContainsPoint(subLayer.path, &transform, location, false){
                self.transFormSelectedLayer(i)
                break
            }
        }
    }
    private func transFormSelectedLayer(index:Int){
        UIView.animateWithDuration(1) { () -> Void in
            //如果之前有layer进行过仿射变换的话,那么移除仿射变换
            if let subLayer:ZHShapeLayer = self.fanArray[index]{
                if self.transMakeLayerIndex != -1 {
                    if subLayer.isOpen == true {
                        subLayer.isOpen = false
                        subLayer.transform = CATransform3DIdentity
                    }
                    else{
                        if let transLayer:ZHShapeLayer = self.fanArray[self.transMakeLayerIndex] {
                            transLayer.isOpen = false
                            self.transMakeLayerIndex = -1
                            transLayer.transform = CATransform3DIdentity
                        }
                    }
                }
                if index != self.transMakeLayerIndex && subLayer.isOpen == false{
                    //获取subLayer的中心角度
                    let centerAngle:Float = (self.startAngleArray[index].floatValue + self.endAngleArray[index].floatValue) * 2 * Float(M_PI) * 0.5
                    self.transMakeLayerIndex = index
                    subLayer.isOpen = true
                    subLayer.transform = CATransform3DMakeTranslation(10 * CGFloat(cos(centerAngle)), 10 * CGFloat(sin(centerAngle)), 0)
                }
            }
        }
    }
    //为了处理touchBegan和gesture的冲突
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
    }
}














