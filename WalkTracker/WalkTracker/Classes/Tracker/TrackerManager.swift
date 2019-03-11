//
//  TrackerManager.swift
//  WalkTracker
//
//  Created by Maria Ortega on 27/02/2019.
//  Copyright © 2019 Maria Ortega. All rights reserved.
//

import UIKit
import CoreLocation

class TrackerManager {

    // MARK: Properties
    
    private let flickrManager = FlickrManager()

    // MARK: Load Photos
    
    func fetchPhotoByLocation(lat: CLLocationDegrees, lon: CLLocationDegrees, photos: [FlickrPhoto], completion: @escaping (FlickrPhoto) -> Void) {
        
        let searchURL = flickrManager.flickrURLFromParameters(lat: lat, lon: lon)
        
        flickrManager.fetchFlickrPhoto(searchURL, index: photos.count) { (results) in
            switch results {
            case .error(let error) :
                print("Error Fetching Photo: \(error)")
            case .results(let flickrPhoto):
                completion(flickrPhoto)
            }
        }
    }
    
    func loadWalkStartedImage(completion: @escaping (FlickrPhoto) -> Void) {
        let flickrPhoto = FlickrPhoto.init(photoID: "walkStarted", imageURL: "", index: 0, image: UIImage(named: "walkStarted.png")!)
        completion(flickrPhoto)
    }

}
