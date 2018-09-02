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
    
    let cellIdentifier = "photoCell"
    
    var photosArray: [String] = [] {
        didSet {
            searchResultsTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PhotosViewModel.shared.requestPhotos { (photoURLStrings) in
            if let urlStrings = photoURLStrings {
                self.photosArray = urlStrings
            }
        }
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
}
