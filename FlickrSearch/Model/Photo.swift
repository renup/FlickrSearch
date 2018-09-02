//
//  Photo.swift
//  FlickrSearch
//
//  Created by Renu Punjabi on 9/1/18.
//  Copyright © 2018 Renu Punjabi. All rights reserved.
//

import Foundation

struct Photo: Codable {
    var id: String?
    var owner: String?
    var secret: String?
    var server: String?
    var farm: Int?
    var ispublic: Int?
    var isfriend: Int?
    var isfamily: Int?
    var title: String?
    var url_s: String?
    var height_s: String?
    var width_s: String?
}

struct Photos: Codable {
    var photos: PhotosMetaData?
    var stat: String?
}

struct PhotosMetaData: Codable {
    let page: Int
    let pages: Int
    let perpage: Int
    let total: String
    let photo: [Photo]
}

