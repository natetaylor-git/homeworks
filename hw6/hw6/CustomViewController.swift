//
//  CustomViewController.swift
//  hw6
//
//  Created by nate.taylor_macbook on 22/10/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import UIKit

class CustomViewController: UIViewController, UITextViewDelegate, TransferedData {
    
    let textView : UITextView = {
        let textView = UITextView()
        textView.frame = .zero
        textView.backgroundColor = .white
        textView.textColor = UIColor.black
        textView.font = UIFont.systemFont(ofSize: 16)
        return textView
    }()
    
    var changedData : cellData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.textView.delegate = self
        
        self.view.backgroundColor = UIColor.init(red: 229/255, green: 229/255, blue: 234/255, alpha: 1.0)
        self.navigationItem.largeTitleDisplayMode = .never
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let padding: CGFloat = 50
        let viewFrame = self.view.frame
        let textViewWidth = viewFrame.width-2*padding
        let textViewHeight = textViewWidth/2
        
        self.textView.frame = CGRect(x: viewFrame.origin.x+padding,
                                     y: self.view.center.y - textViewHeight/2,
                                     width: textViewWidth,
                                     height: textViewHeight)
        
        self.view.addSubview(self.textView)
    }
    
    func textViewDidBeginEditing (_ textView: UITextView) {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTextEditing))
    }
    
    @objc func doneTextEditing() {
        self.navigationItem.rightBarButtonItem = nil
        self.textView.endEditing(true)
        self.changedData?.text = self.textView.text
        
//        var previousViewController:UIViewController?{
//            if let cvStack = self.navigationController?.viewControllers, cvStack >= 2 {
//                let numCV = controllersOnNavStack.count
//                return controllersOnNavStack[numCV - 2] as! ViewController
//            }
//            return nil
//        }
        
    }
}
