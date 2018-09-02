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
    
    func requestPhotos(for searchString: String, completionHandler: @escaping((_ imageURLs: [String]?) -> Void)) {
        
        apiManager.fetchPhotos(forSearch: searchString) { (error, photoURLStrings) in
            if error == nil {
                guard let urlStrings = photoURLStrings else {
                    assertionFailure("photo url strings is nil here")
                    completionHandler(nil)
                    return
                }
               completionHandler(urlStrings)
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
  
}
