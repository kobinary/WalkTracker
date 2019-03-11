//
//  TrackerViewController.swift
//  WalkTracker
//
//  Created by Maria Ortega on 27/02/2019.
//  Copyright © 2019 Maria Ortega. All rights reserved.
//

import UIKit
import CoreLocation

private let reuseIdentifier = "TrackerViewCell"

class TrackerViewController: UICollectionViewController {

    // MARK: Properties
    
    private let locationManager = LocationManager.shared
    private let trackerManager = TrackerManager()

    private var distance = Measurement(value: 0, unit: UnitLength.meters)
    private var locationList: [CLLocation] = []
    private var photos : [FlickrPhoto] = []
    
    // MARK: Setups
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        startWalk()
    }
    
    func setupView() {
        setupNavigationItems()
    }
    
    private func setupNavigationItems() {
        navigationItem.titleView = LogoHelper().setupLogo()
        navigationItem.setHidesBackButton(true, animated:true);
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        locationManager.stopUpdatingLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    // MARK: - IBActions
    
    @IBAction func stopTapped(_ sender: Any) {
        locationManager.stopUpdatingLocation()
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Location
    
    private func startWalk() {
        distance = Measurement(value: 0, unit: UnitLength.meters)
        locationList.removeAll()
        startLocationUpdates()
    }

}

// MARK: UICollectionViewDataSource

extension TrackerViewController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TrackerViewCell
        cell.imageView.image = photos[indexPath.row].largeImage
        return cell
    }
    
    private func reloadContent() {
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
        }
    }
}

// MARK: Location Manager Delegate

extension TrackerViewController: CLLocationManagerDelegate {
    
    private func startLocationUpdates() {
        locationManager.delegate = self
        locationManager.activityType = .fitness
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        locationManager.distanceFilter = 50
        locationManager.allowsBackgroundLocationUpdates = true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let firtsLocation = locations.first, locationList.count == 0 {
            trackerManager.loadWalkStartedImage() { (flickrPhoto) in
                self.photos.append(flickrPhoto)
                self.reloadContent()
            }
            locationList.append(firtsLocation)
        }
        
        for newLocation in locations {
        
            pLog("newLocation is \(newLocation)")
            
            let howRecent = newLocation.timestamp.timeIntervalSinceNow
            guard newLocation.horizontalAccuracy < 20 && abs(howRecent) < 10 else { continue }
            
            if let lastLocation = locationList.last {
                let delta = newLocation.distance(from: lastLocation)
                distance = distance + Measurement(value: delta, unit: UnitLength.meters)
                
                pLog("distance is \(distance)")
                
                /**
                 Value:  It is the trigger value to fetch photos from Flickr API.
                 Start on 100m and increase by 100 every time a photo is added.
                 **/
                let value = Double(100 * ((self.photos.count - 1) + 1))
                pLog("value is \(value)")

                if distance > Measurement(value: value, unit: UnitLength.meters) {
                    trackerManager.fetchPhotoByLocation(lat: newLocation.coordinate.latitude, lon:newLocation.coordinate.longitude, photos: self.photos) { (flickrPhoto) in
                        self.photos.append(flickrPhoto)
                        _ = self.photos.sorted(by: { $0.index > $1.index })
                        self.reloadContent()
                    }
                }
            }
            locationList.append(newLocation)
        }
    }
}


