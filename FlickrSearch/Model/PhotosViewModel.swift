//
//  PhotosViewModel.swift
//  FlickrSearch
//
//  Created by Renu Punjabi on 9/1/18.
//  Copyright © 2018 Renu Punjabi. All rights reserved.
//

import Foundation
import UIKit

//ViewModel layer which communicates between Views and API layer and between Views and Model/Data layer
//It also processes the raw response from API layer before passing it to the Views to display it
class PhotosViewModel {
    
    let apiManager = APIManager.shared
    static let shared = PhotosViewModel()
    var searchWord = ""
    var batch = 1
    var totalBatches = 1
    
    //Requests for photos to the API layer
    func requestPhotos(for searchString: String, page: Int, completionHandler: @escaping((_ imageURLs: [String]?) -> Void)) {
        if searchString.count > 0 && searchWord != searchString {
            searchWord = searchString
        }
        
        if batch != page {
            batch = page
        }
    
        apiManager.fetchPhotos(forSearch: searchWord, batch: batch) { (error, photosObj) in
            if error == nil {
                guard let photosObject = photosObj else {
                    assertionFailure("photosObj is nil here")
                    completionHandler(nil)
                    return
                }
                
                guard let imageURLStrings = self.getPhotoURLStrings(from: photosObject) else {
                    assertionFailure("Something went wrong when creating array of image URL strings - PhotosViewModel")
                    return
                }
               completionHandler(imageURLStrings)
            }
            completionHandler(nil)
        }
    }
    
    //Gets cached images if available or downloads the image
    func getImage(urlString: String, completionHandler: @escaping ((_ image: UIImage?) -> Void)) {
        if let cachedImage = getCachedImage(for: urlString) {
            completionHandler(cachedImage)
        }
        
        apiManager.fetchImageData(imageURLString: urlString) { (image) in
            completionHandler(image)
        }
    }
    
    private func getCachedImage(for imageString: String) -> UIImage? {
        return apiManager.cachedImage(for: imageString)
    }
    
    //Processes the Photos object and extracts the imageURLStrings
    private func getPhotoURLStrings(from photoObject: Photos) -> [String]? {
        guard let photoMetaData = photoObject.photos else { return nil }
        guard let photoArray = photoMetaData.photo else { return nil }
        var urlStrings = [String]()
        for item in photoArray {
            if let urlStr = item.url_s {
                urlStrings.append(urlStr)
            }
        }
        return urlStrings
    }
    
    //Unused method. But this method will be used to determine whether we need to make further requests to get the next batch of photos or not.
    private func batchAvailable(for photosObject: Photos) -> Bool {
        guard let photoSet = photosObject.photos?.page, let totalSets = photosObject.photos?.pages else { return false }
        batch = photoSet
        totalBatches = totalSets
        return totalBatches - batch > 0
    }
  
}
