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
    typealias FlickrResponse = (Error?, [Photo]?) -> Void

    struct Constants {
        static let apiKey = "3785458368e09e236c7943827d308315"
    }
    
    func fetchPhotos(forSearch keyword: String, onCompletion: @escaping FlickrResponse) {
        let urlString = constructRequestURL(for: keyword)
        
        Alamofire.request(urlString).responseJSON {response in
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)") // original server data as UTF8 string
            }

        }
    }
    
    private func constructRequestURL(for search: String) -> String {
        return "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(Constants.apiKey)&text=\(search)&extras=url_s&format=json&nojsoncallback=1"
    }
    
}
