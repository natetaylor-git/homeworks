//
//  ViewController.swift
//  UrlSessionLesson
//
//  Created by Константин Богданов on 06/11/2019.
//  Copyright © 2019 Константин Богданов. All rights reserved.
//

import UIKit

/// ViewController that represents all downloaded Flickr images in table view
class FlickrViewController: UIViewController {
    let configurator: FlickrConfiguratorProtocol = FlickrConfigurator()
    var interactor: FlickrInteractorInputProtocol!
    
	let tableView = UITableView()
	let reuseId = "FlickrCellreuseId"
    
    var images = ThreadSafeImageViewCollection()

	override func viewDidLoad() {
		super.viewDidLoad()
        configurator.configure(with: self)
        
		setupUI()
        
        tableView.register(FlickrViewCell.self, forCellReuseIdentifier: reuseId)
        tableView.dataSource = self
        tableView.delegate = self
        
        self.interactor.loadImagesFromSQLite { models in
            self.images = ThreadSafeImageViewCollection(with: models)
            if self.images.count == 0 {
                print("data from web")
                self.search(by: "cat")
            } else {
                DispatchQueue.main.async {
                    print("data from sqlite")
                    self.tableView.reloadData()
                }
            }
        }
	}

    /// Setup of navigation elements and tableView position
    func setupUI() {
        self.navigationItem.title = "Flickr Images"

        let backButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButton
        
        view.addSubview(self.tableView)
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)])
    }
    
    
    /// Method that downloads Flickr images from web according to searchString
    ///
    /// - Parameter searchString: key word for searching objects at Flickr
	private func search(by searchString: String) {
		interactor.loadImageList(by: searchString) { [weak self] models in
			self?.loadImages(with: models)
		}
	}
    
    /// Method that loads images one by one using urls from models collection and updates tableView data
    ///
    /// - Parameter models: Flickr objects list with image urls and descriptions
	private func loadImages(with models: [ImageModel]) {
        let maxNumberOfImages: Int = 100
		let models = models.suffix(maxNumberOfImages)

		let group = DispatchGroup()
		for model in models {
			group.enter()
			interactor.loadImage(at: model.path) { [weak self] image in
				guard let image = image else {
					group.leave()
					return
				}
				let viewModel = ImageViewModel(description: model.description,
											   image: image)
				self?.images.append(viewModel)
				group.leave()
			}

		}

		group.notify(queue: DispatchQueue.main) {
            self.interactor.saveImagesToSQLite(from: self.images)
			self.tableView.reloadData()
		}
	}
}

extension FlickrViewController: UITableViewDataSource, UITableViewDelegate {

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return images.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath) as! FlickrViewCell
		let model = images[indexPath.row]
		cell.imageView?.image = model.image
		cell.textLabel?.text = model.description
		return cell
	}
    
    
    /// Transition to ImagePageViewController configured using selected cell info
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pushViewContoller = ImagePageViewController()
        let imageViewModel = images[indexPath.row]
        pushViewContoller.textForNavigationTitle = imageViewModel.description
        pushViewContoller.imageToShow = imageViewModel.image
        self.navigationController?.pushViewController(pushViewContoller, animated: false)
    }
}
