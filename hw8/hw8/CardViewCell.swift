//
//  CardViewCell.swift
//  hw8
//
//  Created by nate.taylor_macbook on 07/11/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import UIKit

class CardViewCell: UICollectionViewCell, UITextViewDelegate {
    
    let label = UILabel()
    
    let textView : UITextView = {
        let textView = UITextView()
        textView.frame = .zero
        textView.backgroundColor = .white//UIColor(red: 144/255, green: 238/255, blue: 144/255, alpha: 0.5)
        textView.alpha = 0.7
        textView.textColor = UIColor.black
        textView.font = UIFont.systemFont(ofSize: 16)
        return textView
    }()
    
    override func prepareForReuse() {
        self.textView.text = ""
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
//        self.label.textColor = .white
//        self.label.frame = self.bounds
//        self.contentView.addSubview(label)
        
        self.textView.delegate = self
        self.textView.frame = self.bounds.insetBy(dx: 10.0, dy: 20.0)
        self.textView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.textView.isUserInteractionEnabled = false
        self.contentView.addSubview(textView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.cornerRadius = 5.0
    }
    
//    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//        if(text == "\n") {
//            textView.resignFirstResponder()
//            return false
//        }
//        return true
//    }

}