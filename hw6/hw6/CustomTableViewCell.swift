//
//  CustomTableViewCell.swift
//  hw6
//
//  Created by nate.taylor_macbook on 22/10/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        self.textLabel?.font = UIFont.systemFont(ofSize: 16)
        self.detailTextLabel?.font = UIFont.systemFont(ofSize: 12)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.detailTextLabel?.text = nil
        self.textLabel?.textColor = .black
        self.accessoryType = .none
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let padding: CGFloat = 5
        
        if let imageView = self.imageView {
            imageView.frame = CGRect(x: imageView.frame.origin.x,
                                          y: imageView.frame.origin.y + padding,
                                          width: imageView.frame.width - padding * 2,
                                          height: imageView.frame.height - padding * 2)
        }
        if let textLabel = self.textLabel {
            textLabel.frame = CGRect(x: textLabel.frame.origin.x - padding * 2,
                                           y: textLabel.frame.origin.y,
                                           width: textLabel.frame.width + padding * 2,
                                           height: textLabel.frame.height)
        }
        
        if let detailTextLabel = self.detailTextLabel {
            detailTextLabel.frame = CGRect(x: detailTextLabel.frame.origin.x - padding * 2,
                                           y: detailTextLabel.frame.origin.y + padding,
                                           width: detailTextLabel.frame.width + padding * 2,
                                           height: detailTextLabel.frame.height)
        }
    }
    
}

//class TableViewCell: UITableViewCell {
//
//    var img = UIImageView()
//    var textField = UILabel()
//    var subTextField = UILabel()
//
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        //super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
//
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//
//        let cellContentHeight = self.contentView.frame.height
//        let cellContentWidth = self.contentView.frame.width
//
//        let imgHeight = cellContentHeight - 10
//        let imgWidth = imgHeight
//
//        self.textField.frame = CGRect(x: self.contentView.frame.origin.x+imgWidth+10,
//                                      y: self.contentView.frame.origin.y + 5,
//                                      width: cellContentWidth-imgWidth-10,
//                                      height: imgHeight/2)
//        self.textField.backgroundColor = .green
//        self.contentView.addSubview(self.textField)
//
//        self.subTextField.frame = CGRect(x: self.contentView.frame.origin.x+imgWidth+10,
//                                          y: self.contentView.frame.origin.y + 5 + self.textField.frame.height,
//                                          width: cellContentWidth-imgWidth-10,
//                                          height: imgHeight/2)
//        self.subTextField.backgroundColor = .blue
//        self.contentView.addSubview(self.subTextField)
//
//        self.img.frame = CGRect (x: self.contentView.frame.origin.x+5,
//                                 y: self.contentView.frame.origin.y + 5,
//                                 width: imgWidth,
//                                 height: imgHeight)
//        self.img.backgroundColor = .red
//        self.contentView.addSubview(self.img)
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        self.detailTextLabel?.text = nil
//        self.accessoryType = .none
//    }
//
////    override func layoutSubviews() {
////        super.layoutSubviews()
////        self.contentView.frame = self.contentView.frame.inset(by: UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0))
////        //self.contentView.layoutMargins.left = CGFloat(self.indentationLevel) * self.indentationWidth
////        self.contentView.layoutIfNeeded()
////    }
//}

