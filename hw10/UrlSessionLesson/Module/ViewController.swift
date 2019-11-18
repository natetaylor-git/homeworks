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
    var lastSearchText: String?
    var searchPage: Int = 1
    var cache = ThreadSafeCache()
    
	var imageModels: [ImageModel] = []
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
        if let lastSearch = self.lastSearchText, let currentSearch = searchText, lastSearch == currentSearch {
            print("page number: ", self.searchPage)
        } else {
            self.searchPage = 1
            self.cache.removeAll()
            self.imageModels.removeAll()
            self.tableView.reloadData()
        }
        
        if let searchString = self.searchText {
            self.lastSearchText = searchText
            self.interactor.loadImageList(by: searchString, page: self.searchPage) { [weak self] models in
                self?.loadImages(with: models)
            }
        } else {
            print("no search text")
        }
	}

	private func loadImages(with models: [ImageModel]) {
        imageModels.append(contentsOf: models)

        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
	}
}

extension ViewController: UITableViewDataSource {

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return imageModels.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath) as! FlickrViewCell
        let model = self.imageModels[indexPath.row]
        
        cell.textLabel?.text = String(indexPath.row) + " " + model.description
        
        if cache.keys.contains(indexPath.row) {
            cell.imageView?.image = cache[indexPath.row]
        } else {
            cell.imageView?.image = UIImage(named: "EmptyImage")
            let imagePath = model.path
            self.interactor.loadImage(at: imagePath) {[weak self] (image) in
                guard let cellImage = image else { return }
                
                self?.cache[indexPath.row] = cellImage
                DispatchQueue.main.async {
                    cell.imageView?.image = cellImage
                }
            }
        }

		return cell
	}
}

extension ViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        let rows = indexPaths.map{$0.row}
        let tenthFromEndNumber = 100 * self.searchPage - 10
        if rows.contains(tenthFromEndNumber) {
            //print("new batch")
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
            self.searchText = searchText
            searchTimer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(search), userInfo: nil, repeats: false)
        }
    }
}
