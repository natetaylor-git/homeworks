//
//  CustomActionButton.swift
//  Filter
//
//  Created by nate.taylor_macbook on 26/11/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import UIKit

class ActionButton: UIButton {
    init(frame: CGRect, name: String) {
        super.init(frame: frame)
        self.setTitle(name, for: .normal)
        self.setTitleColor(.black, for: .normal)
        self.backgroundColor = .white
        self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.black.cgColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
