//
//  PhotoViewController.swift
//  FlickrSearch
//
//  Created by Renu Punjabi on 9/1/18.
//  Copyright © 2018 Renu Punjabi. All rights reserved.
//

import Foundation
import UIKit

class PhotoViewController: UIViewController {
    
    @IBOutlet weak var photoImageView: UIImageView!
    var displayImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoImageView.image = displayImage
    }
    
}
