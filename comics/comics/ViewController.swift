//
//  ViewController.swift
//  comics
//
//  Created by nate.taylor_macbook on 22/10/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {

    var count = -1
    
    let defaultPagesRects = ComicsPicturesRects().allPictures
    var pagesRects = [CGRect]()
    
    var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.backgroundColor = .blue
        return scrollView
    }()
    
    let comicsImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    let backgroundView: UIImageView = {
        let imageView = UIImageView(frame: UIScreen.main.bounds)
        imageView.image = UIImage(named: "comics")
        return imageView
    }()
    
    let endButton = UIButton()
    let startButton = UIButton()
    
    let rightSwipe: UISwipeGestureRecognizer = {
        let swipe = UISwipeGestureRecognizer()
        swipe.direction = .right
        return swipe
    }()
    
    let leftSwipe: UISwipeGestureRecognizer = {
        let swipe = UISwipeGestureRecognizer()
        swipe.direction = .left
        return swipe
    }()
    
    override func viewDidLoad() {
        self.comicsImageView.image = resizedImage()
        self.scrollView.delegate = self
        self.scrollView.isScrollEnabled = false
        
        setScrollView()
        self.comicsImageView.frame = CGRect(origin: .zero, size: scrollView.contentSize)
        
        self.scrollView.addSubview(comicsImageView)
        self.view.addSubview(scrollView)
        
        self.view.addSubview(backgroundView)
        
        setStartButton()
        self.view.addSubview(startButton)
        
        setEndButton()
        self.view.addSubview(endButton)

        self.rightSwipe.addTarget(self, action: #selector(handleGesture))
        self.leftSwipe.addTarget(self, action: #selector(handleGesture))
        
        self.view.addGestureRecognizer(rightSwipe)
        self.view.addGestureRecognizer(leftSwipe)
    }
    
    func setScrollView() {
        self.scrollView.alpha = 0
        
        let screenBounds = UIScreen.main.bounds
        scrollView.frame = CGRect(x: 0,
                                  y: screenBounds.height/4,
                                  width: screenBounds.width,
                                  height: screenBounds.height/2)
        
        if let contentSize = self.comicsImageView.image?.size {
            scrollView.contentSize = contentSize
        } else {
            print("Scroll didn't get image size")
        }
    }

    func setEndButton() {
        let endButtonHeight = CGFloat(40)
        let padding: CGFloat = 10
        
        self.endButton.frame = CGRect(x: view.frame.width - view.center.x + padding,
                                      y: view.frame.height - endButtonHeight - padding,
                                      width: view.center.x - padding,
                                      height: endButtonHeight)
        self.endButton.backgroundColor = UIColor.white
        self.endButton.addTarget(self, action: #selector(tappedEndButton), for: .touchDown)
        self.endButton.setTitle("End watching", for: .normal)
        self.endButton.setTitleColor(UIColor.black, for: .normal)
    }
    
    func setStartButton() {
        let startButtonHeight = CGFloat(40)
        let padding:CGFloat = 10
        
        self.startButton.frame = CGRect(x: 0,
                                      y: view.frame.height - startButtonHeight - padding,
                                      width: view.center.x - padding,
                                      height: startButtonHeight)
        self.startButton.backgroundColor = UIColor.white
        self.startButton.addTarget(self, action: #selector(tappedStartButton), for: .touchDown)
        self.startButton.setTitle("Start watching", for: .normal)
        self.startButton.setTitleColor(UIColor.black, for: .normal)
    }
    
    @objc func tappedStartButton() {
        self.startButton.isEnabled = false
        self.backgroundView.alpha = 0.0
 
// if u comment next two lines (126 and 127) and uncomment comments marked as 1 and 2
// then u can see scroll view without page fitting
        self.count = 0
        self.changePage()
// ----------------------------------------------------------------------------------
        
        UIView.animate(withDuration: 1.0, animations: {
            self.scrollView.alpha = 1.0
        }, completion: { finished in
            
            self.rightSwipe.isEnabled = true
            self.leftSwipe.isEnabled = true
            self.endButton.isEnabled = true
//1            self.scrollView.isScrollEnabled = true
        })
    }

    @objc func tappedEndButton() {
        self.endButton.isEnabled = false
        self.rightSwipe.isEnabled = false
        self.leftSwipe.isEnabled = false
        
        UIView.animate(withDuration: 1.0, animations: {
            self.backgroundView.alpha = 1.0
        }, completion: { finished in
            self.count = 0
            self.changePage()
            self.setScrollView()
            self.count = -1
            self.startButton.isEnabled = true
        })
    }
    
    func changePage() {
        scrollView.bounds = CGRect(origin: .zero, size: pagesRects[count].size)
        scrollView.scrollRectToVisible(pagesRects[count], animated: true)
    }

    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
//2        scrollView.isScrollEnabled = false
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

        changePage()
    }
    
    func resizedImage() -> UIImage {
        let maxWidth = defaultPagesRects.map{$0.width}.max()!
        let maxHeight = defaultPagesRects.map{$0.height}.max()!

        let padding: CGFloat = 100 // button height can be
        
        let targetFrame = CGRect(origin: .zero, size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - padding))
        
        let imageName = "comics"
        if let image = UIImage(named: imageName) {
            let scaleX = targetFrame.size.width / maxWidth
            let scaleY = targetFrame.size.height / maxHeight
            let newSize = CGSize(width: scaleX * image.size.width, height: scaleY * image.size.height)
            let rect = CGRect(origin: .zero, size: newSize)

//            print("scaleX: ", scaleX, "scaleY: ", scaleY)
            changeRects(scaleX, scaleY)
            
            UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
            image.draw(in: rect)
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return newImage!
            
        } else {
            print("Error: no such picture: \(imageName)")
            return UIImage()
        }
    }
    
    func changeRects(_ x: CGFloat, _ y: CGFloat) {
        for rect in defaultPagesRects {
            pagesRects.append(CGRect(x: rect.origin.x * x,
                             y: rect.origin.y * y,
                             width: rect.width * x, height: rect.height * y))
        }
    }
}
