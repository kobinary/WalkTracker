//
//  TrackerManager.swift
//  WalkTracker
//
//  Created by Maria Ortega on 27/02/2019.
//  Copyright © 2019 Maria Ortega. All rights reserved.
//

import UIKit
import CoreLocation

class TrackerManager: NSObject {

    // MARK: Properties
    
    var controller : TrackerViewController!
    var flickrManager = FlickrManager()

    // MARK: Init
    
    override init() {
        super.init()
    }
    
    init(controller: TrackerViewController) {
        self.controller = controller
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("Not meant to be initialised this way")
    }
    
    // MARK: Setups
    
    func setupView() {
        setupNavigationItems()
    }
    
    func setupNavigationItems() {
        controller.navigationItem.titleView = LogoHelper().setupLogo()
        controller.navigationItem.setHidesBackButton(true, animated:true);
    }
    
    // MARK: Location
    
    func startWalk() {
        controller.distance = Measurement(value: 0, unit: UnitLength.meters)
        controller.locationList.removeAll()
        startLocationUpdates()
    }
    
    private func startLocationUpdates() {
        controller.locationManager.delegate = controller
        controller.locationManager.activityType = .fitness
        controller.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        controller.locationManager.startUpdatingLocation()
        controller.locationManager.allowsBackgroundLocationUpdates = true
    }

    // MARK: Load Photos
    
    func fetchPhotoByLocation(lat: CLLocationDegrees, lon: CLLocationDegrees) {
        
        let searchURL = flickrManager.flickrURLFromParameters(lat: lat, lon: lon)
        
        flickrManager.fetchFlickrPhoto(searchURL, index: controller.photos.count) { (results) in
            switch results {
            case .error(let error) :
                print("Error Fetching Photo: \(error)")
            case .results(let flickrPhoto):
                self.controller.photos.append(flickrPhoto)
                self.controller.photos = self.controller.photos.sorted(by: { $0.index > $1.index })
            }
            self.reloadContent()
        }
    }
    
    func loadWalkStartedImage() {
        let flickrPhoto = FlickrPhoto.init(photoID: "walkStarted", imageURL: "", index: 0, image: UIImage(named: "walkStarted.png")!)
        controller.photos.append(flickrPhoto)
        reloadContent()
    }
    
    // MARK: Reload CollectionView
    
    func reloadContent() {
        DispatchQueue.main.async {
            self.controller.collectionView?.reloadData()
        }
    }
}
