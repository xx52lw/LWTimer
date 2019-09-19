//
//  LWSphereView.swift
//  LWTime
//
//  Created by liwei on 2019/9/16.
//  Copyright © 2019 liwei. All rights reserved.
//

import UIKit

class LWSphereView: UIView {

    /// 经纬度数组
    var coordinate = [LWPoint]()
    /// 滚动方向
    var direction = LWPoint()
    /// 定时器
    var timer : CADisplayLink?
    ///
    var last = CGPoint()
    ///
    var velocity :CGFloat = 0.0
    ///
    var inertia : CADisplayLink?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addGestureRecognizer(UIPanGestureRecognizer.init(target: self, action: #selector(handlePanGesture(gesture:))))
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   // 根据传入数据，创建视图
    var cloudTags : [UIView]! {
        didSet {
           coordinate.removeAll()
            for tagView in cloudTags {
                tagView.center = CGPoint.init(x: frame.size.width / 2.0, y: frame.size.height / 2.0)
                addSubview(tagView)
            }
            
            let p1 = .pi * (3 - sqrt(5))
            let p2 = 2.0 / Double(cloudTags.count)
            for i in 0..<cloudTags.count {
                let y:CGFloat = CGFloat(Double(i) * p2 - 1 + (p2 / 2.0))
                let r:CGFloat = CGFloat(sqrt(1 - y * y))
                let p3:CGFloat = CGFloat(Double(i) * p1)
                let x:CGFloat = CGFloat(cos(Double(p3)) * Double(r))
                let z:CGFloat = CGFloat(sin(Double(p3)) * Double(r))
                
                let point = LWPoint.init(x: x, y: y, z: z)
                coordinate.append(point)
                tagOfPoint(point: point, index: i)
            }
            // 随机抛洒
            direction = LWPointMake(3.0, 4.0, 0.0)
            UIView.animate(withDuration: 0.25, animations: {
                
            }) { (_) in
                self.timerStart()
            }
        }
    }
    func tagOfPoint(point: LWPoint, index: NSInteger)  {
        let tagView = cloudTags[index]
        let x :CGFloat = (point.x + 1) * (frame.size.width / 2.0)
        let y :CGFloat = (point.y + 1) * (frame.size.width / 2.0)
        tagView.center = CGPoint.init(x: x, y: y)
        let transform:CGFloat = (point.z + 2) / CGFloat(Double(3))
        tagView.transform = CGAffineTransform.init(scaleX: transform, y: transform)
        tagView.layer.zPosition = transform
        tagView.alpha = transform
        if point.z < 0.0 {
            tagView.isUserInteractionEnabled = false
        }
        else {
            tagView.isUserInteractionEnabled = true
        }
    }
    
    func timerStart() {
        timer = CADisplayLink.init(target: self, selector: #selector(autoTurnRotation))
        timer!.add(to: RunLoop.main, forMode: .default)
    }
    func timerStop() {
        if timer != nil {
            timer!.invalidate()
            timer = nil
        }
    }
    func inertiaStart() {
        timerStop()
        inertia = CADisplayLink.init(target: self, selector: #selector(inertiaStop))
        inertia!.add(to: RunLoop.main, forMode: .default)
    }
    @objc func inertiaStop() {
        if inertia != nil {
            inertia!.invalidate()
            inertia = nil
        }
        timerStart()
    }
    
    @objc func autoTurnRotation() {
        for i in 0..<cloudTags.count {
            updateFrameOfPoint(index: i, direction: direction, angle: 0.002)
        }
    }
    func updateFrameOfPoint(index: NSInteger, direction: LWPoint, angle: CGFloat) {
        var point = coordinate[index]
        point = LWPointMakeRotation(point, direction, angle)
        coordinate[index] = point
        tagOfPoint(point: point, index: index)
    }
    @objc func handlePanGesture(gesture:UIPanGestureRecognizer) {
        if gesture.state == .began {
            last = gesture.location(in: self)
            timerStop()
            inertiaStop()
        }
        else if gesture.state == .changed {
            let current = gesture.location(in: self)
            let currentDirection = LWPointMake(last.y - current.y, current.x - last.x, 0.0)
            let distance = sqrt(currentDirection.x * currentDirection.x + currentDirection.y * currentDirection.y)
            let angle = distance / (frame.size.width / 2.0)
            for i in 0..<cloudTags.count {
                updateFrameOfPoint(index: i, direction: currentDirection, angle: angle)
            }
            direction = currentDirection
            last = current
        }
        else if gesture.state == .cancelled {
            let velocityPoint = gesture.velocity(in: self)
            velocity = sqrt(velocityPoint.x * velocityPoint.x + velocityPoint.y * velocityPoint.y)
            inertiaStart()
        }
    }
}
