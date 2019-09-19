//
//  ViewController.swift
//  LWTime
//
//  Created by liwei on 2019/9/16.
//  Copyright © 2019 liwei. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    lazy var bgImageView:  UIImageView = {
        let imageView = UIImageView.init()
        imageView.image = UIImage.init(named: "bg.gif")
        return imageView
    }()
    var sphereView : LWSphereView?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.addSubview(bgImageView)
        bgImageView.frame = view.bounds
        sphereView = LWSphereView.init(frame: CGRect.init(x: 0.0, y: 80.0, width: view.frame.size.width, height: view.frame.size.height - 80.0))
        view.addSubview(sphereView!)
        initsphereViews()
    }
// 星球转动
    func initsphereViews()  {
        var sphereArray = [UIView]()
        for _ in 0..<50 {
            let tagView = UIView.init(frame: CGRect.init(x: 0.0, y: 0.0, width: 80.0, height: 60.0))
            tagView.backgroundColor = .red
            tagView.addGestureRecognizer(UIPanGestureRecognizer.init(target: self, action: #selector(handlePanGesture(gesture:))))
            sphereArray.append(tagView)
        }
        sphereView?.cloudTags = sphereArray
    }
    @objc func handlePanGesture(gesture:UIPanGestureRecognizer) {
        
    }
}


