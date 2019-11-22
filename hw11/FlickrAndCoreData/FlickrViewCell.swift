//
//  FlickrViewCell.swift
//  UrlSessionLesson
//
//  Created by nate.taylor_macbook on 18/11/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import UIKit

class FlickrViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    /// Configure imageView and textLabel frames that depend on cell bounds and setup imageView content mode
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let padding: CGFloat = 10
        let imageWidth: CGFloat = self.bounds.width / 7
        self.imageView?.frame = CGRect(origin: CGPoint(x: padding, y: 0),
                                       size: CGSize(width: imageWidth, height: self.bounds.height))
        self.textLabel?.frame = CGRect(origin: CGPoint(x: imageWidth + padding * 2,
                                                       y: 0),
                                       size: CGSize(width: self.bounds.width - padding * 2 - imageWidth,
                                                    height: self.bounds.height))
        
        self.imageView?.contentMode = .scaleToFill
        self.imageView?.image?.withAlignmentRectInsets(.zero)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        self.textLabel?.text = ""
        self.imageView?.image = nil
    }

}
