//
//  ViewController.swift
//  hw7
//
//  Created by nate.taylor_macbook on 29/10/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import UIKit

class PictureViewController: UIViewController {
    
    let configurator: PictureConfiguratorProtocol = PictureConfigurator()
    var presenter: PicturePresenterInputProtocol!
    
    var imageView: UIImageView = {
        let imageView = UIImageView()
        let screenSize = UIScreen.main.bounds.size
        let width = 2/3 * screenSize.width
        let height = 1/2 * screenSize.height
        let xPadding = (screenSize.width - width)/2
        let yPadding: CGFloat = xPadding
        
        imageView.frame = CGRect(origin: CGPoint(x: xPadding, y: yPadding),
                                 size: CGSize(width: width, height: height))
        imageView.backgroundColor = .blue
        
        return imageView
    }()

    let showButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .lightGray
        button.setTitle("Show", for: .normal)
        return button
    }()
    
    let downloadButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .lightGray
        button.setTitle("Download", for: .normal)
        return button
    }()
    
    let cleanCacheButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .lightGray
        button.setTitle("Clean cache", for: .normal)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurator.configure(with: self)
        presenter.configureView()
        
        self.downloadButton.addTarget(self, action: #selector(tappedDownloadButton), for: .touchUpInside)
        self.showButton.addTarget(self, action: #selector(tappedShowButton), for: .touchUpInside)
        self.cleanCacheButton.addTarget(self, action: #selector(tappedCleanCacheButton), for: .touchUpInside)
    }
    
    @objc func tappedDownloadButton() {
        self.presenter.tappedDownloadButton()
    }
    
    @objc func tappedShowButton() {
        self.presenter.tappedShowButton()
    }
    
    @objc func tappedCleanCacheButton() {
        self.presenter.tappedCleanCacheButton()
    }
}

extension PictureViewController: PicturePresenterOutputProtocol {
    func initialLayout() {
        self.view.addSubview(self.imageView)
        layoutEmptyImageView()
        layoutButtons()
    }
    
    func resetLayout() {
        self.imageView.image = nil
        for view in imageView.subviews {
            view.alpha = 1.0
        }
    }
    
    private func layoutEmptyImageView() {
        self.imageView.image = nil
        let titleLabel = UILabel()
        titleLabel.text = "Image"
        titleLabel.font = UIFont.systemFont(ofSize: 50)
        titleLabel.textColor = UIColor.white
        titleLabel.textAlignment = .center
        titleLabel.frame.size = .zero
        titleLabel.sizeToFit()
        titleLabel.frame.origin = CGPoint(x: imageView.frame.width / 2 - titleLabel.frame.width / 2,
                                          y: imageView.frame.height / 2 - titleLabel.frame.height / 2)
        self.imageView.addSubview(titleLabel)
    }
    
    private func layoutButtons() {
        let buttons = [self.showButton, self.downloadButton, self.cleanCacheButton]
        let numButtons = buttons.count
        
        let freeArea = UIScreen.main.bounds.height - imageView.frame.maxY
        let paddingOfButtonsAreaRatio: CGFloat = 0.4
        let paddingOfButtonsArea = paddingOfButtonsAreaRatio * freeArea / 2
        let buttonsArea =  freeArea * (1 - paddingOfButtonsAreaRatio)
        
        let paddingOfButtonRatio: CGFloat = 0.5
        let buttonHeight = buttonsArea / (CGFloat(numButtons) + CGFloat(numButtons - 1) * paddingOfButtonRatio)
        let buttonSize = CGSize(width: imageView.frame.width, height: buttonHeight)
        let paddingBetweenButtons: CGFloat = buttonSize.height * paddingOfButtonRatio
        
        for (index, button) in buttons.enumerated() {
            let buttonOriginY = imageView.frame.maxY + paddingOfButtonsArea +
                CGFloat(index) * (buttonSize.height + paddingBetweenButtons)
            let buttonOrigin = CGPoint(x: imageView.frame.minX, y: buttonOriginY)
            button.frame = CGRect(origin: buttonOrigin, size: buttonSize)
            
            self.view.addSubview(button)
        }
        
        self.view.addSubview(showButton)
        self.view.addSubview(downloadButton)
        self.view.addSubview(cleanCacheButton)
    }
    
    func layoutImageView(with image: UIImage?) {
        for view in imageView.subviews {
            view.alpha = 0.0
        }
        self.imageView.image = image!
    }
    
    func showError(with errorText: String) {
        let errorAlertController = UIAlertController(title: "Error", message: errorText, preferredStyle: .alert)
        let actionOk = UIAlertAction(title: "OK", style: .default, handler: nil)
        errorAlertController.addAction(actionOk)
        self.present(errorAlertController, animated: true, completion: nil)
    }
}
