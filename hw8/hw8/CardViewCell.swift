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
        textView.backgroundColor = .white
        textView.alpha = 0.7
        textView.textColor = UIColor.black
        textView.font = UIFont.systemFont(ofSize: 16)
        return textView
    }()
    
    override var alpha: CGFloat {
        didSet {
            super.alpha = 1.0
        }
    }
    
    override func prepareForReuse() {
        self.textView.text = ""
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        
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
