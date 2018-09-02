//
//  SearchViewController.swift
//  FlickrSearch
//
//  Created by Renu Punjabi on 9/1/18.
//  Copyright © 2018 Renu Punjabi. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class PhotoCell: UITableViewCell {
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var cellNumberLabel: UILabel!
    
    func configure(imageStr: String, rowNum: Int) {
        cellNumberLabel.text = rowNum.description
        photoImageView.image = nil
            photoImageView.af_setImage(
                withURL: URL(string: imageStr)!,
                placeholderImage: UIImage(named: "placeholder"),
                filter: nil,
                imageTransition: .crossDissolve(0.2)
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        //cancel inflight images and reset image
        photoImageView.af_cancelImageRequest()
        photoImageView.layer.removeAllAnimations()
        photoImageView.image = nil
    }
}

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchResultsTableView: UITableView!
    
    @IBOutlet weak var searchbar: UISearchBar!
    let cellIdentifier = "photoCell"
    let viewModel = PhotosViewModel.shared
    var selectedImage: UIImage?
    
    var photosArray: [String] = [] {
        didSet {
            if photosArray.count > 1 {
                searchResultsTableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchbar.delegate = self
        //Rose is a default word to search with.
        getPhotos(for: "Rose", batch: 1)
    }
    
    //VC talks to viewModel layer for photos
    fileprivate func getPhotos(for search: String, batch: Int) {
        viewModel.requestPhotos(for: search, page: batch,  completionHandler: { (photoURLStrings) in
            if let urlStrings = photoURLStrings {
                self.photosArray += urlStrings
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
        cell.configure(imageStr: photosArray[indexPath.row], rowNum: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        viewModel.getImage(urlString: photosArray[indexPath.row], completionHandler: { (image) in
            self.selectedImage = image
        })
        self.performSegue(withIdentifier: "searchToPhotoVC", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //If reached to the end of the search results, request next batch and display that.
        if indexPath.row == photosArray.count - 1 {
            getPhotos(for: "", batch: viewModel.batch + 1)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Scope of this project at this time is limited so am force unwrapping the segue.destination as PhotoVC. Typically, we check for segue.identifier, and based on that we get relative VC's here (in guard statements) and set their properties before segueing.
        let photosVC = segue.destination as! PhotoViewController
        photosVC.displayImage = selectedImage!
    }
    
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let searchStr = searchBar.text {
            //resetting photosArray here since this is a new search
            photosArray = []
            getPhotos(for: searchStr, batch: 1)
        }
    }
    
}
