//
//  PushAnimator.swift
//  hw4
//
//  Created by nate.taylor_macbook on 18/10/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import UIKit

class PushAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 3.0
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        
        toViewController?.view.transform = CGAffineTransform.identity
        fromViewController?.view.transform = CGAffineTransform.identity
        
        containerView.insertSubview(toViewController!.view, belowSubview: fromViewController!.view)
        
        toViewController?.view.alpha = 0.0
        UIView.animate(withDuration: 2.0, animations: {
            fromViewController?.view.transform = CGAffineTransform(scaleX: 5.0, y: 5.0)
            fromViewController?.view.alpha = 0.0
        }) { (completed) in
            UIView.animate(withDuration: 1.0, animations: {
                toViewController?.view.alpha = 1.0
                fromViewController?.view.transform = CGAffineTransform.identity
            }) { finished in
                let cancelled = transitionContext.transitionWasCancelled
                transitionContext.completeTransition(!cancelled)
            }
        }
        
    }
    
}
