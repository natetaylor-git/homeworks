//
//  ViewController.swift
//  UrlSessionLesson
//
//  Created by Константин Богданов on 06/11/2019.
//  Copyright © 2019 Константин Богданов. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	let tableView = UITableView()
    let searchBar = UISearchBar()
    
    var searchTimer: Timer?
    var searchText: String?
    var sameSearch: Bool = false
    var searchPage: Int = 1
    
    var cache = ThreadSafeCache() //[Int: ImageViewModel]()
    var imageModels = ThreadSafeImageModelCollection() //[ImageModel]()
    
	let reuseId = "UITableViewCellreuseId"
	let interactor: InteractorInput

	init(interactor: InteractorInput) {
		self.interactor = interactor
		super.init(nibName: nil, bundle: nil)
	}
    
	required init?(coder: NSCoder) {
		fatalError("Метод не реализован")
	}
    
	override func viewDidLoad() {
		super.viewDidLoad()
		view.addSubview(tableView)

        searchBar.insetsLayoutMarginsFromSafeArea = true
        searchBar.delegate = self
        searchBar.placeholder = "Search images ..."
        view.addSubview(searchBar)
        
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leftAnchor.constraint(equalTo: view.leftAnchor),
            searchBar.rightAnchor.constraint(equalTo: view.rightAnchor)])
        
		tableView.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
			tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
			tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
			tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)])
		tableView.register(FlickrViewCell.self, forCellReuseIdentifier: reuseId)
		tableView.dataSource = self
        tableView.prefetchDataSource = self
        tableView.allowsSelection = false
	}

    @objc private func search() {
        if self.sameSearch == false {
            self.searchPage = 1
        }
        
        if let searchString = self.searchText {
            self.interactor.loadImageList(by: searchString, page: self.searchPage) { [weak self] models in
                self?.loadImages(with: models)
            }
        } else {
            print("no search text")
        }
	}
   
// MARK: - Variant#1 loadImages downloads models page by page and saves images here to cache for tableView cells
    
//    private func loadImages(with models: [ImageModel]) {
//        if self.sameSearch == false {
//            self.cache.removeAll()
//            self.imageModels.removeAll()
//        }
//
//        let existedNumberOfImages = self.imageModels.count
//        self.imageModels.append(contentsOf: models)
//
//        let group = DispatchGroup()
//
//        for item in models.enumerated() {
//            group.enter()
//            let model = item.element
//            let index = item.offset + existedNumberOfImages
//            self.interactor.loadImage(at: model.path) { [weak self] (image) in
//                guard let image = image else {
//                    group.leave()
//                    return
//                }
//
//                let imageViewModel = ImageViewModel(description: model.description, image: image)
//                self?.cache[index] = imageViewModel
//
//                group.leave()
//            }
//        }
//
//        group.notify(queue: DispatchQueue.main) {
//            if self.sameSearch == false {
//                self.tableView.contentOffset = .zero
//            }
//            self.tableView.reloadData()
//        }
//    }

// MARK: - Variant#2 loadImages only downloads models and
//                   reloads tableView Data (changes amount of cells in tableView)
    
	private func loadImages(with models: [ImageModel]) {
        if self.sameSearch == false {
            self.imageModels.removeAll()
            self.cache.removeAll()
        }

        self.imageModels.append(contentsOf: models)
        DispatchQueue.main.async {
            if self.sameSearch == false {
                self.tableView.contentOffset = .zero
            }
            self.tableView.reloadData()
        }
	}
}

extension ViewController: UITableViewDataSource {

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return imageModels.count
	}

// MARK: - tableView method for variant#1 (page by page)
    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath) as! FlickrViewCell
//        cell.imageView?.image =  UIImage(named: "EmptyImage")
//
//        if cache.keys.contains(indexPath.row) {
//            cell.imageView?.image = cache[indexPath.row]!.image
//            cell.textLabel?.text = cache[indexPath.row]!.description
//        } else {
//            cell.textLabel?.text = "empty cell"
//        }
//
//        return cell
//    }
    
// MARK: - tableView method for variant#2
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath) as! FlickrViewCell

        if self.imageModels.count == 0 {
            print("no data")
            return cell
        }
        
        let rowNumber = indexPath.row
        let model = self.imageModels[rowNumber]

        if cache.keys.contains(rowNumber) {
            cell.imageView?.image = cache[rowNumber]!.image
            cell.textLabel?.text = String(rowNumber) + " " + cache[rowNumber]!.description
            //cell.textLabel?.text = String(rowNumber) + " cache " + cache[rowNumber]!.description

        } else {
            cell.imageView?.image = UIImage(named: "EmptyImage")
            cell.textLabel?.text = "waiting"
            let imagePath = model.path

            self.interactor.loadImage(at: imagePath) {[weak self] (image) in
                let index = rowNumber
                
                guard let cellImage = image else {
                    cell.textLabel?.text = String(indexPath.row) + " " + "invalid image"
                    return
                }
                let description = model.description
                self?.cache[index] = ImageViewModel(description: description, image: cellImage)

                DispatchQueue.main.async {
                    let cell = self?.tableView.cellForRow(at: IndexPath(row: index, section: 0))
                    cell?.imageView?.image = cellImage
                    cell?.textLabel?.text = String(indexPath.row) + " " + description
                }
            }
        }

        return cell
    }
}

extension ViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        let rows = indexPaths.map{$0.row}
        let downloadAtOffset: Int = 10
        let pageSize: Int = 100
        let tenthFromEndNumber = pageSize * self.searchPage - downloadAtOffset
        if rows.contains(tenthFromEndNumber) {
            //print("new batch")
            self.sameSearch = true
            self.searchPage += 1
            self.search()
        }
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if let timer = self.searchTimer {
            timer.invalidate()
        }
        
        if searchText != "" {
            self.sameSearch = false
            self.searchText = searchText
            searchTimer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(search), userInfo: nil, repeats: false)
        }
    }
}
