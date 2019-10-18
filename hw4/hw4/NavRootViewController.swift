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
        
        setHeartButton()
        setRepairButton()
        setView()

        view.addSubview(heartButton)
        view.addSubview(repairButton)
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (didPush) {
            heartButton.setTitle("💔", for: .normal)
        }
    }
    
    @objc func tapHeartButton () {
        didPush = true
        heartButton.isEnabled = false
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc func tapRepairButton () {
        heartButton.setTitle("❤️", for: .normal)
        heartButton.isEnabled = true
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
