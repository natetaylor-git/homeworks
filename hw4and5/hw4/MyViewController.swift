//
//  MyViewController.swift
//  hw4
//
//  Created by nate.taylor_macbook on 17/10/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import UIKit

class MyViewController: UIViewController {

    var stayButtonTapped = false
    
    let stayButton : UIButton = {
        let button = UIButton(type: .custom)
        return button
    }()
    
    let leaveButton : UIButton = {
        let button = UIButton(type: .custom)
        return button
    }()
    
    override func viewDidLoad() {
        self.navigationItem.setHidesBackButton(true, animated:true);
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        view.backgroundColor = UIColor.white
        setStayButton()
        setLeaveButton()
        view.addSubview(stayButton)
        view.addSubview(leaveButton)
        
        (UIApplication.shared.delegate as! AppDelegate).allowedRotation = .portrait
        super.viewWillAppear(animated)
    }
    
    @objc func tapStayButton () {
        UIView.transition(with: self.view, duration: 2.0, options: [.transitionCrossDissolve], animations: {
            self.stayButton.removeFromSuperview()
            self.leaveButton.backgroundColor = UIColor.white
        }, completion: { success in
            if success {
                self.sunRiseAnimation()
            }
        })
        leaveButton.isEnabled = false
        stayButtonTapped = true
    }
    
    func sunRiseAnimation() {
        UIView.transition(with: self.view, duration: 2.0, options: [.transitionCrossDissolve], animations: {
            self.leaveButton.setTitle("☀️", for: .normal)
            self.leaveButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 100)
            self.leaveButton.frame = CGRect(x: 0,
                                            y: self.view.center.y/2,
                                            width: self.view.bounds.maxX,
                                            height: self.view.center.y)
            self.leaveButton.alpha = 1.0
        }, completion: { completed in
            if completed {
                (UIApplication.shared.delegate as! AppDelegate).allowedRotation = .all}
        })
    }
    
    @objc func tapLeaveButton () {
        self.stayButton.removeFromSuperview()
        self.leaveButton.removeFromSuperview()
        navigationController?.popViewController(animated: true)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isLandscape && stayButtonTapped {
            leaveButton.setTitle("Уйти", for: .normal)
            leaveButton.setTitleColor(UIColor.black, for: .normal)
            leaveButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 36)
            leaveButton.isEnabled = true
        }
    }
    
    func setStayButton() {
        stayButton.setTitle("Остаться навсегда", for: .normal)
        stayButton.backgroundColor = UIColor.white
        stayButton.setTitleColor(UIColor.black, for: .normal)
        stayButton.addTarget(self, action:  #selector(tapStayButton), for:.touchDown)
        stayButton.frame = CGRect(x: 0,
                                  y: 0,
                                  width: self.view.bounds.maxX,
                                  height: self.view.center.y)
    }
    
    func setLeaveButton() {
        leaveButton.setTitle("Уйти", for: .normal)
        leaveButton.backgroundColor = UIColor.black
        leaveButton.setTitleColor(UIColor.white, for: .normal)
        leaveButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        leaveButton.addTarget(self, action:  #selector(tapLeaveButton), for:.touchDown)
        leaveButton.frame = CGRect(x: 0,
                                   y: self.view.center.y,
                                   width: self.view.bounds.maxX,
                                   height: self.view.center.y)
        leaveButton.alpha = 1.0
    }
}

