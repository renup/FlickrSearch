//
//  Photo.swift
//  FlickrSearch
//
//  Created by Renu Punjabi on 9/1/18.
//  Copyright © 2018 Renu Punjabi. All rights reserved.
//

import Foundation

struct Photo: Codable {
    var url_s: String?
    var height_s: String?
    var width_s: String?
}

struct Photos: Codable {
    var photos: PhotosMetaData?
    var stat: String?
}

struct PhotosMetaData: Codable {
    var page: Int?
    var pages: Int?
    var perpage: Int?
    var total: String?
    var photo: [Photo]?
}

