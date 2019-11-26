//
//  ViewController.swift
//  Filter
//
//  Created by nate.taylor_macbook on 23/11/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import UIKit

class ViewController: UIViewController, FilterCollectionHelperDelegate {
    let filtersCollectionViewHelper: FiltersCollectionHelper = FiltersCollectionHelper()
    
    var imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    let filtersCollectionView: UICollectionView = {
        let filtersCollectionViewLayout = UICollectionViewFlowLayout()
        filtersCollectionViewLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: filtersCollectionViewLayout)
        return collectionView
    }()
    
    let galleryButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    let cameraButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    var showFilters: Bool = true {
        willSet(newValue) {
            if newValue {
                UIView.animate(withDuration: 0.5, animations: {
                    self.careTaker?.undo()
                }) { (finished) in
                    self.filtersCollectionView.alpha = 1.0
                }
            } else {
                let window = UIApplication.shared.windows[0]
                let safeFrame = window.safeAreaLayoutGuide.layoutFrame
                let imageViewHeight = safeFrame.height * 3/4
                let filtersCollectionViewHeight = self.filtersCollectionView.frame.height
                careTaker?.backup()
                self.creator?.setNewSize(size: CGSize(width: self.imageView.frame.width,
                                                      height: imageViewHeight + filtersCollectionViewHeight))
                self.filtersCollectionView.alpha = 0.0
            }
        }
    }
    
    var creator: ImageViewCreator?
    var careTaker: CareTaker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        creator = ImageViewCreator(self.imageView)
        careTaker = CareTaker(creator: creator!)
        
        setupUI()
        
        self.imageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
        self.imageView.addGestureRecognizer(tap)
        
        self.filtersCollectionView.register(FilteredImageCell.self, forCellWithReuseIdentifier: "cellReuseId")
        self.filtersCollectionViewHelper.delegate = self
        self.filtersCollectionViewHelper.currentImage = self.imageView.image
        self.filtersCollectionView.dataSource = filtersCollectionViewHelper
        self.filtersCollectionView.delegate = filtersCollectionViewHelper
    }
    
    func setImageView(with image: UIImage?) {
        self.imageView.image = image
    }
    
    func setupUI() {
        let window = UIApplication.shared.windows[0]
        let safeFrame = window.safeAreaLayoutGuide.layoutFrame
        let imageViewHeight = safeFrame.height * 3/4
        let filtersCollectionViewHeight = (safeFrame.height - imageViewHeight) * 3/4
        let buttonsHeight = self.view.frame.height - safeFrame.minY - imageViewHeight - filtersCollectionViewHeight
        
        let imageViewFrame = CGRect(origin: safeFrame.origin,
                                    size: CGSize(width: safeFrame.width, height: imageViewHeight))
        self.imageView.frame = imageViewFrame
        self.imageView.image = UIImage(named: "DefaultImage")
        self.imageView.contentMode = .scaleAspectFill
        self.imageView.backgroundColor = .black
        self.imageView.insetsLayoutMarginsFromSafeArea = true
        self.view.addSubview(self.imageView)
        
        let filtersCollectionViewOrigin = CGPoint(x: safeFrame.minX, y: imageView.frame.maxY)
        let filtersCollectionViewSize = CGSize(width: safeFrame.width,
                                               height: filtersCollectionViewHeight)
        self.filtersCollectionView.frame = CGRect(origin: filtersCollectionViewOrigin,
                                                  size: filtersCollectionViewSize)
        self.filtersCollectionView.backgroundColor = .groupTableViewBackground
        self.view.addSubview(filtersCollectionView)
        
        let galleryButtonFrame = CGRect(origin: CGPoint(x: safeFrame.minX,
                                                        y: safeFrame.origin.y + imageViewHeight + filtersCollectionViewHeight),
                                        size: CGSize(width: safeFrame.width / 2, height: buttonsHeight))
        galleryButton.frame = galleryButtonFrame
        galleryButton.addTarget(self, action: #selector(galleryButtonTapped), for: .touchUpInside)
        galleryButton.setTitle("Gallery", for: .normal)
        galleryButton.setTitleColor(.black, for: .normal)
        galleryButton.backgroundColor = .white//.groupTableViewBackground
        galleryButton.layer.borderWidth = 1.0
        galleryButton.layer.borderColor = UIColor.black.cgColor
        self.view.addSubview(galleryButton)
        
        var cameraButtonFrame = galleryButtonFrame
        cameraButtonFrame.origin.x = galleryButton.frame.origin.x + galleryButton.frame.width
        cameraButton.frame = cameraButtonFrame
        cameraButton.addTarget(self, action: #selector(cameraButtonTapped), for: .touchUpInside)
        cameraButton.setTitle("Camera", for: .normal)
        cameraButton.setTitleColor(.black, for: .normal)
        cameraButton.backgroundColor = .white
        cameraButton.layer.borderWidth = 1.0
        cameraButton.layer.borderColor = UIColor.black.cgColor
        self.view.addSubview(cameraButton)
        
        showFilters = false
    }
    
    @objc func imageViewTapped() {
        self.showFilters = !self.showFilters
    }
    
    @objc func galleryButtonTapped() {
        self.filtersCollectionViewHelper.resetFilteredImages()
        self.presentImagePickerController(with: UIImagePickerController.SourceType.photoLibrary)
    }
    
    @objc func cameraButtonTapped() {
        self.filtersCollectionViewHelper.resetFilteredImages()
        self.presentImagePickerController(with: UIImagePickerController.SourceType.camera)
    }
    
    func activateButtons() {
        self.galleryButton.isEnabled = true
        self.cameraButton.isEnabled = true
        UIView.animate(withDuration: 0.5) {
            self.galleryButton.alpha = 1.0
            self.cameraButton.alpha = 1.0
        }
    }
    
    func deactivateButtons() {
        self.galleryButton.isEnabled = false
        self.cameraButton.isEnabled = false
        self.galleryButton.alpha = 0.5
        self.cameraButton.alpha = 0.5
    }
}

extension ViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func createImagePickerController(with sourceType: UIImagePickerController.SourceType) -> UIImagePickerController {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = sourceType
        imagePickerController.delegate = self
        return imagePickerController
    }
    
    func presentImagePickerController(with sourceType: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let imagePickerController = createImagePickerController(with: sourceType)
            self.present(imagePickerController, animated: true, completion: nil)
        } else {
            print("Got unavailable source type for imagePickerController")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        self.imageView.image = pickedImage
        self.filtersCollectionViewHelper.currentImage = pickedImage
        self.filtersCollectionViewHelper.newImageLoaded = true
        self.filtersCollectionView.reloadData()
        self.showFilters = true
        self.filtersCollectionViewHelper.addFilters(for: self.filtersCollectionView)
        deactivateButtons()
        picker.dismiss(animated: false, completion: nil)
    }
}
