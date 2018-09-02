//
//  APIManager.swift
//  FlickrSearch
//
//  Created by Renu Punjabi on 9/1/18.
//  Copyright © 2018 Renu Punjabi. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage

class APIManager {
    static let shared = APIManager()

    struct Constants {
        static let apiKey = "3785458368e09e236c7943827d308315"
    }
    
    let imageCache = AutoPurgingImageCache(
        memoryCapacity: 100_000_000,
        preferredMemoryUsageAfterPurge: 60_000_000
    )
    
    func fetchPhotos(forSearch keyword: String, onCompletion: @escaping (Error?, [String]?) -> Void) {
        let urlString = constructRequestURL(for: keyword)
        
        Alamofire.request(urlString).responseJSON { response in
            if let jsonData = response.data, let str = String(data: jsonData, encoding: .utf8)?.replacingOccurrences(of: "\\/", with: "/") {
                do {
                    guard let data = str.data(using: .utf8) else {
                        assertionFailure("Photos response String conversion to data failed")
                        return
                    }
                    let dataArray = try JSONDecoder().decode(Photos.self, from: data)
                    guard let urlStrings = self.getPhotoURLStrings(from: dataArray) else { return }
                    onCompletion(nil, urlStrings)
                } catch {
                    print("Error while decoding photosResponse = \(error)")
                }
            }
        }
    }
    
    private func constructRequestURL(for search: String) -> String {
        return "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(Constants.apiKey)&text=\(search)&extras=url_s&format=json&nojsoncallback=1"
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
  
}

//MARK: Managing images methods
extension APIManager {
    
    /// Fetches Images for a Photo
    ///
    /// - Parameters:
    ///   - imageURLString: restaurant Image URL String
    ///   - imageDownloadHandler: Handler contains jsonResponse array and error
    /// - Returns: returns a UIImage object for the restaurant
    @discardableResult
    func fetchImageData(imageURLString: String, imageDownloadHandler: @escaping ((_ image: UIImage?) -> Void)) -> Request {
        //download image data using alamofire
        
        return Alamofire.request(imageURLString, method: .get).responseImage { (response) in
            if let image = response.result.value {
                imageDownloadHandler(image)
                self.cache(image, for: imageURLString)
            } else {
                imageDownloadHandler(nil)
            }
        }
    }
    
    /// Saves an image to the memory cache
    ///
    /// - Parameters:
    ///   - image: Image object to be saved to cache
    ///   - url: URL string to be associated with the image being saved to cache
    func cache(_ image: Image, for url: String) {
        imageCache.add(image, withIdentifier: url)
    }
    
    
    /// Returns cached image for the URL string provided
    ///
    /// - Parameter url: url string associated with the cached image
    /// - Returns: returns an Image object from the cache
    func cachedImage(for url: String) -> Image? {
        return imageCache.image(withIdentifier: url)
    }
}
