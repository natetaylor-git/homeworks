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
        self.frame = .zero
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.detailTextLabel?.text = nil
        self.textLabel?.text = nil
        self.textLabel?.textColor = .black
        self.accessoryType = .none
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let padding: CGFloat = 5
        let imageSize = CGSize(width: CGFloat(32), height: CGFloat(32))
        let textLabelWidth: CGFloat = 250

        if let imageView = self.imageView {
            imageView.frame = CGRect(x: padding,
                                      y: self.frame.size.height/2 - imageSize.height/2,
                                      width: imageSize.width,
                                      height: imageSize.height)
        }
        
        if let textLabel = self.textLabel {

            var yOrigin = padding
            let xOrigin = imageView!.frame.origin.x + imageView!.frame.width + padding
            let sizeTextLabel = textLabel.sizeThatFits(CGSize(width: textLabelWidth,
                                                              height: CGFloat.greatestFiniteMagnitude))
            
            yOrigin = self.frame.size.height/2 - sizeTextLabel.height/2
            
            if let detailTextLabel = self.detailTextLabel {

                let sizeDetailTextLabel = detailTextLabel.sizeThatFits(CGSize(width: textLabelWidth,
                                                                              height: CGFloat.greatestFiniteMagnitude))
                
                yOrigin = (self.frame.size.height - sizeTextLabel.height - sizeDetailTextLabel.height - padding)/2
                let yOriginDetail = yOrigin + sizeTextLabel.height + padding
                let xOriginDetail = xOrigin
                
                detailTextLabel.frame = CGRect(x: xOriginDetail,
                                               y: yOriginDetail,
                                               width: sizeDetailTextLabel.width,
                                               height: sizeDetailTextLabel.height)
            }
            
            textLabel.frame = CGRect(x: xOrigin,
            y: yOrigin,
            width: sizeTextLabel.width,
            height: sizeTextLabel.height)
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

