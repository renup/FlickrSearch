//
//  APIManager.swift
//  FlickrSearch
//
//  Created by Renu Punjabi on 9/1/18.
//  Copyright © 2018 Renu Punjabi. All rights reserved.
//

import Foundation
import Alamofire

class APIManager {
    static let shared = APIManager()
    typealias FlickrResponse = (Error?, [Photos]?) -> Void

    struct Constants {
        static let apiKey = "3785458368e09e236c7943827d308315"
    }
    
    func fetchPhotos(forSearch keyword: String, onCompletion: @escaping FlickrResponse) {
        let urlString = constructRequestURL(for: keyword)
        
        Alamofire.request(urlString).responseJSON { response in
//            var photosArray = [Photo]()
            if let jsonData = response.data {
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase

                    let dataArray = try decoder.decode(Photos.self, from: jsonData)
                    print("Data array = \(dataArray)")

               //     onCompletion(nil, photosArray)
                } catch {
                    print("Error while decoding photosResponse = \(error)")
                }
            }
        }
    }
    
    private func constructRequestURL(for search: String) -> String {
        return "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(Constants.apiKey)&text=\(search)&extras=url_s&format=json&nojsoncallback=1"
    }
    
}
