//
//  HeaderCell.swift
//  hw8
//
//  Created by nate.taylor_macbook on 09/11/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import UIKit

class HeaderCell: UICollectionViewCell {
    let label = UILabel()
    let addButton: UIButton = {
       let button = UIButton()
        button.frame = .zero
        button.setTitle("+", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1.0
        button.backgroundColor = .yellow
        return button
    }()
    
    override func prepareForReuse() {
        self.label.text = ""
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //setup()
        
        let cellBounds = self.bounds
        
        self.label.textAlignment = .center
        self.label.frame = cellBounds
        
        self.label.frame = CGRect(origin: cellBounds.origin,
                                  size: CGSize(width: cellBounds.width, height: cellBounds.height * 1/2))
        
        self.label.textColor = UIColor.black
        self.label.font = UIFont.systemFont(ofSize: 20)
        self.contentView.addSubview(label)
        
        let buttonSide = cellBounds.height - self.label.frame.height
        let buttonOrigin = CGPoint(x: cellBounds.origin.x + (cellBounds.width - buttonSide) / 2,
                                   y: cellBounds.origin.y + self.label.frame.height)
        self.addButton.frame = CGRect(origin: buttonOrigin,
                                        size: CGSize(width: buttonSide, height: buttonSide))
        self.addButton.layer.cornerRadius = addButton.frame.width / 2
        self.contentView.addSubview(self.addButton)
        
        self.backgroundColor = .groupTableViewBackground
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.cornerRadius = 5.0
    }
    
}
