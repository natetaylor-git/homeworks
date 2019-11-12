//
//  CustomCollectionViewCell.swift
//  hw9
//
//  Created by nate.taylor_macbook on 11/11/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    let label: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        label.frame = self.bounds
        self.contentView.addSubview(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        self.label.text = nil
        self.alpha = 1.0
    }
}
