//
//  SearchViewController.swift
//  FlickrSearch
//
//  Created by Renu Punjabi on 9/1/18.
//  Copyright © 2018 Renu Punjabi. All rights reserved.
//

import Foundation
import UIKit

class SearchViewController: UIViewController {
    
    let apiManager = APIManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        apiManager.fetchPhotos(forSearch: "sonia") { (error, photos) in
            print("inside the response block photos = \(photos)")
        }
    }
}
