//
//  NavContollerDelegate.swift
//  hw4
//
//  Created by nate.taylor_macbook on 18/10/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import UIKit

class NavigationControllerDelegate : UIViewController, UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        let className = String(describing: viewController.classForCoder)
        print("Will show VC of class: ", className)
    }
}

extension NavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        switch operation {
        case .pop: return PopAnimator()
        case .push: return PushAnimator()
        default: return nil
        }
    }
}
