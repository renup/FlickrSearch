//
//  SearchViewController.swift
//  FlickrSearch
//
//  Created by Renu Punjabi on 9/1/18.
//  Copyright © 2018 Renu Punjabi. All rights reserved.
//

import Foundation
import UIKit

class PhotoCell: UITableViewCell {
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    func configure(imageStr: String) {
        PhotosViewModel.shared.getImage(urlString: imageStr) { (photo) in
            if let pic = photo {
                self.photoImageView.image = pic
            }
        }
    }
}

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchResultsTableView: UITableView!
    
    @IBOutlet weak var searchbar: UISearchBar!
    let cellIdentifier = "photoCell"
    let viewModel = PhotosViewModel.shared
    
    var photosArray: [String] = [] {
        didSet {
            searchResultsTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchbar.delegate = self
        getPhotos(for: "Sonia")
    }
    
    fileprivate func getPhotos(for search: String) {
        viewModel.requestPhotos(for: search, completionHandler: { (photoURLStrings) in
            if let urlStrings = photoURLStrings {
                self.photosArray = urlStrings
            }
        })
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photosArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! PhotoCell
        cell.configure(imageStr: photosArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let searchStr = searchBar.text {
            getPhotos(for: searchStr)
        }
    }
    
}
