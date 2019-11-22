//
//  ImagePageViewController.swift
//  FlickrAndCoreData
//
//  Created by nate.taylor_macbook on 22/11/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import UIKit

/// View controller that represents image from selected cell in FlickrViewController
class ImagePageViewController: UIViewController {
    var imageView: UIImageView!
    var imageToShow: UIImage?
    var textForNavigationTitle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        setupNavigationBar()
        setupImageView()
    }
    
    /// Filling navigation bar title with Flickr image description from selected cell
    func setupNavigationBar() {
        let titleLabel = UILabel()
        titleLabel.numberOfLines = 2
        titleLabel.backgroundColor = .clear
        titleLabel.textAlignment = .center
        titleLabel.text = textForNavigationTitle
        titleLabel.sizeToFit()
        
        self.navigationItem.titleView = titleLabel
    }

    
    /// Filling imageView content with Flickr image from selected cell and setup its frame
    func setupImageView() {
        let viewFrame = self.view.frame
        self.imageView = UIImageView()
        self.imageView.frame = CGRect(origin: CGPoint(x: viewFrame.width / 8,
                                                      y: viewFrame.height / 8),
                                      size: CGSize(width: viewFrame.width * 3/4,
                                                   height: viewFrame.height * 3/4))
        self.imageView.image = self.imageToShow
        self.imageView.contentMode = .scaleAspectFit
        self.view.addSubview(imageView)
    }

}
