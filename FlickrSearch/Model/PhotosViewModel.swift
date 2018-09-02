//
//  PhotosViewModel.swift
//  FlickrSearch
//
//  Created by Renu Punjabi on 9/1/18.
//  Copyright © 2018 Renu Punjabi. All rights reserved.
//

import Foundation
import UIKit

class PhotosViewModel {
    
    let apiManager = APIManager.shared
    static let shared = PhotosViewModel()
    var searchWord = ""
    var batch = 1
    var totalBatches = 1
    
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
                    assertionFailure("Somehthing went wrong when creating array of image URL strings - PhotosViewModel")
                    return
                }
               completionHandler(imageURLStrings)
            }
            completionHandler(nil)
        }
    }
    
    func getImage(urlString: String, completionHandler: @escaping ((_ image: UIImage?) -> Void)) {
        if let cachedImage = apiManager.cachedImage(for: urlString) {
            completionHandler(cachedImage)
        }
        
        apiManager.fetchImageData(imageURLString: urlString) { (image) in
            completionHandler(image)
        }
    }
    
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
    
    private func batchAvailable(for photosObject: Photos) -> Bool {
        guard let photoSet = photosObject.photos?.page, let totalSets = photosObject.photos?.pages else { return false }
        batch = photoSet
        totalBatches = totalSets
        return totalBatches - batch > 0
    }
  
}
