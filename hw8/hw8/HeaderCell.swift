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
    
    override func prepareForReuse() {
        self.label.text = ""
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        self.label.textAlignment = .center
        self.label.frame = self.bounds
        self.label.textColor = UIColor.black
        self.label.font = UIFont.systemFont(ofSize: 16)
        self.contentView.addSubview(label)
        self.backgroundColor = .lightGray
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
