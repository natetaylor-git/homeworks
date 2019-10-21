//
//  PopAnimator.swift
//  hw4
//
//  Created by nate.taylor_macbook on 18/10/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import UIKit

class PopAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 3.0
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        
        containerView.insertSubview(toViewController!.view, belowSubview: fromViewController!.view)
        toViewController?.view.transform = CGAffineTransform(scaleX: 5.0, y: 5.0)
        
        toViewController?.view.alpha = 0.0
//        UIView.animate(withDuration: 1.5, animations: {
//            fromViewController?.view.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
//            fromViewController?.view.alpha = 0.0
//        }) { (completed) in
//            UIView.animate(withDuration: 1.5, animations: {
//                toViewController?.view.transform = CGAffineTransform.identity
//                toViewController?.view.alpha = 1.0
//                fromViewController?.view.transform = CGAffineTransform.identity
//            }) { finished in
//                let cancelled = transitionContext.transitionWasCancelled
//                transitionContext.completeTransition(!cancelled)
//            }
//        }
        UIView.animateKeyframes(withDuration: 2, delay: 0, options:.calculationModePaced, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.3, animations: {
                fromViewController?.view.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                fromViewController?.view.alpha = 0.0
            })
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.3, animations: {
                toViewController?.view.transform = CGAffineTransform.identity
                toViewController?.view.alpha = 1.0
            })
        }, completion: { finished in
                fromViewController?.view.transform = CGAffineTransform.identity
                let cancelled = transitionContext.transitionWasCancelled
                transitionContext.completeTransition(!cancelled)
        })

    }
    
}
