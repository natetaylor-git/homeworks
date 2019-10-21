//
//  NavRootViewController.swift
//  hw4
//
//  Created by nate.taylor_macbook on 17/10/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import UIKit

class NavigationRootViewController: UIViewController {
    
    var didPush = false
    
    let viewController : MyViewController = {
        let viewController = MyViewController()
        return viewController
    }()
    
    let navigationDelegate : NavigationControllerDelegate = {
        let navigationDelegate = NavigationControllerDelegate()
        return navigationDelegate
    }()
    
    let heartButton : UIButton = {
        let button = UIButton(type: .custom)
        return button
    }()
    
    let repairButton : UIButton = {
        let button = UIButton(type: .custom)
        return button
    }()
    
    
    override func viewDidLoad() {
        self.navigationController?.delegate = navigationDelegate
        (UIApplication.shared.delegate as! AppDelegate).allowedRotation = .portrait
        
        setView()
        setHeartButton()
        setRepairButton()

        view.addSubview(heartButton)
        view.addSubview(repairButton)
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (didPush) {
            heartButton.setTitle("💔", for: .normal)
            repairButton.isEnabled = true
        }
    }
    
    @objc func tapHeartButton () {
        didPush = true
        heartButton.isEnabled = false
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc func tapRepairButton () {
        
        let inColorAnimation = CABasicAnimation(keyPath: "backgroundColor")
        inColorAnimation.fromValue = heartButton.layer.backgroundColor
        inColorAnimation.toValue = UIColor.black.cgColor
        inColorAnimation.duration = 1
        inColorAnimation.fillMode = CAMediaTimingFillMode.forwards
        inColorAnimation.isRemovedOnCompletion = false
        inColorAnimation.beginTime = 0.0

        let positionAnimation = CABasicAnimation(keyPath: "position")
        positionAnimation.fromValue = [heartButton.layer.position.x, heartButton.layer.position.y]
        positionAnimation.toValue = [heartButton.layer.position.x - 70, heartButton.layer.position.y - 70]
        positionAnimation.duration = 2
        positionAnimation.autoreverses = true
        positionAnimation.beginTime = inColorAnimation.beginTime + inColorAnimation.duration

        let rotateAnimationZ = CABasicAnimation(keyPath: "transform")
        rotateAnimationZ.valueFunction = CAValueFunction(name: CAValueFunctionName.rotateZ)
        rotateAnimationZ.fromValue = 0
        rotateAnimationZ.toValue = Float.pi * 2
        rotateAnimationZ.duration = 2
        rotateAnimationZ.autoreverses = true
        rotateAnimationZ.beginTime = inColorAnimation.beginTime + inColorAnimation.duration

        let outColorAnimation = CABasicAnimation(keyPath: "backgroundColor")
        outColorAnimation.fromValue = UIColor.black.cgColor
        outColorAnimation.toValue = heartButton.layer.backgroundColor
        outColorAnimation.duration = 1
        outColorAnimation.beginTime = positionAnimation.beginTime + positionAnimation.duration*2

        let animation = CAAnimationGroup()
        animation.animations = [inColorAnimation, rotateAnimationZ, outColorAnimation, positionAnimation]
        animation.duration = outColorAnimation.beginTime + outColorAnimation.duration
        heartButton.layer.add(animation, forKey: "heartRepairingAnimation")

        UIView.animate(withDuration: 2, delay: animation.duration, options: [], animations: {
            self.heartButton.titleLabel?.alpha = 0.0
        }, completion: {finished in
            self.heartButton.setTitle("❤️", for: .normal)
            UIView.animate(withDuration: 2, delay: 0, options: [], animations: {
                self.heartButton.titleLabel?.alpha = 1.0
            }, completion: {finished in
                CATransaction.begin()
                CATransaction.setCompletionBlock({
                    self.heartButton.isEnabled = true
                    self.repairButton.isEnabled = false
                })
                
                let heartBeatSlow = CABasicAnimation(keyPath: "transform")
                heartBeatSlow.valueFunction = CAValueFunction(name: CAValueFunctionName.scale)
                heartBeatSlow.fromValue = [1, 1, 1]
                heartBeatSlow.toValue = [0.8, 0.8, 0.8]
                heartBeatSlow.autoreverses = true
                heartBeatSlow.duration = 0.5
                heartBeatSlow.beginTime = 0.0
                
                let heartBeatFast = CABasicAnimation(keyPath: "transform")
                heartBeatFast.valueFunction = CAValueFunction(name: CAValueFunctionName.scale)
                heartBeatFast.fromValue = [1, 1, 1]
                heartBeatFast.toValue = [0.5, 0.5, 0.5]
                heartBeatFast.autoreverses = true
                heartBeatFast.duration = 0.7
                heartBeatFast.beginTime = heartBeatSlow.beginTime + heartBeatSlow.duration
                heartBeatFast.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
                
                let heartAnimation = CAAnimationGroup()
                heartAnimation.animations = [heartBeatSlow, heartBeatFast]
                heartAnimation.duration = heartBeatFast.beginTime + heartBeatFast.duration
                heartAnimation.repeatCount = 4
                self.heartButton.titleLabel?.layer.add(heartAnimation, forKey: "heartAnimation")
                
                CATransaction.commit()
            })
        })
    }
    
    func setHeartButton() {
        heartButton.setTitle("❤️", for: .normal)
        heartButton.backgroundColor = UIColor.white
        heartButton.setTitleColor(UIColor.black, for: .normal)
        heartButton.addTarget(self, action:  #selector(tapHeartButton), for:.touchDown)
        
        let buttonWidth = self.view.center.x
        let buttonHeight = buttonWidth
        heartButton.frame = CGRect(x: self.view.center.x - buttonWidth/2,
                                   y: self.view.center.y - buttonHeight/2,
                                   width: buttonWidth,
                                   height: buttonHeight)
        
        heartButton.layer.cornerRadius = buttonWidth/2
        heartButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 100)
    }
    
    func setRepairButton() {
        repairButton.setTitle("repair", for: .normal)
        repairButton.backgroundColor = UIColor.white
        repairButton.setTitleColor(UIColor.black, for: .normal)
        repairButton.addTarget(self, action:  #selector(tapRepairButton), for:.touchDown)
        repairButton.frame = CGRect(x: 25.0,
                                    y: 100.0,
                                    width: 100.0,
                                    height: 40.0)
        repairButton.isEnabled = false
    }
    
    func setView() {
        let layer = CAShapeLayer()
        let path = UIBezierPath()
        path.move(to: CGPoint.init(x: 0, y: 0))
        path.addLine(to: CGPoint.init(x: self.view.bounds.maxX, y: 0))
        path.addLine(to: CGPoint.init(x: 0, y: self.view.bounds.maxY))
        path.addLine(to: CGPoint.init(x: 0, y: 0))
        layer.path = path.cgPath
        layer.fillColor = UIColor.black.cgColor
        self.view.layer.addSublayer(layer)
        self.view.backgroundColor = UIColor.white
    }
}
