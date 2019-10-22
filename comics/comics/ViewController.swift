//
//  ViewController.swift
//  comics
//
//  Created by nate.taylor_macbook on 22/10/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {

    var scrollView  = UIScrollView()
    var imageView = UIImageView()
    var pagesRects : Array<CGRect> = []
    var count = -1
//    let button = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        pagesRects.append(CGRect(x: imageView.frame.origin.x, y: imageView.frame.origin.y, width: 150, height: 150))
        pagesRects.append(CGRect(x: imageView.frame.origin.x+1.5, y: imageView.frame.origin.y+4.0, width: 134.5, height: 290))
        pagesRects.append(CGRect(x: imageView.frame.origin.x+141, y: imageView.frame.origin.y+4.0, width: 130.5, height: 290))
        pagesRects.append(CGRect(x: imageView.frame.origin.x+277, y: imageView.frame.origin.y+4.0, width: 135, height: 289.5))
        pagesRects.append(CGRect(x: imageView.frame.origin.x+2.5, y: imageView.frame.origin.y+305, width: 202, height: 357))
        pagesRects.append(CGRect(x: imageView.frame.origin.x+210, y: imageView.frame.origin.y+302, width: 202, height: 290))
        pagesRects.append(CGRect(x: imageView.frame.origin.x+2.5, y: imageView.frame.origin.y+671.5, width: 203, height: 221))
        pagesRects.append(CGRect(x: imageView.frame.origin.x+211, y: imageView.frame.origin.y+601, width: 201, height: 290.5))
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let viewFrame = self.view.frame
        
        let imageWidth = viewFrame.width
        let imageHeight = viewFrame.height
        imageView.frame = CGRect(x: 0, y: 0, width: imageWidth, height: imageHeight)
        imageView.image = UIImage(named: "comics")
        
        scrollView = UIScrollView.init(frame: imageView.frame)
        scrollView.delegate = self
        scrollView.contentSize = CGSize(width: imageWidth, height: imageHeight)
        imageView.contentMode = .scaleToFill
        scrollView.backgroundColor = UIColor.green
        scrollView.isScrollEnabled = false
        
//        button.frame = CGRect(x: 40, y: viewFrame.height-40, width: 100, height: 40)
//        button.backgroundColor = UIColor.red
//        button.addTarget(self, action: #selector(tapped), for: .touchDown)
        
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
//        view.addSubview(button)
    }

//    @objc func tapped() {
//        scrollView.bounds = pagesRects[count]
//        scrollView.scrollRectToVisible(pagesRects[count], animated: true)
//    }
    
    @objc func changePicture() {
        scrollView.bounds = pagesRects[count]
        scrollView.scrollRectToVisible(pagesRects[count], animated: true)
    }
    
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        if gesture.direction == .right {
            count -= 1
        }
        if gesture.direction == .left {
            count += 1
        }

        if count == pagesRects.count {
            count = 0
        }
        
        if count < 0 {
            count = pagesRects.count-1
        }
        
        changePicture()
    }

}

