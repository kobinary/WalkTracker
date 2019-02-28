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
    
    var manager : TrackerManager!
    let locationManager = LocationManager.shared
    var distance = Measurement(value: 0, unit: UnitLength.meters)
    var locationList: [CLLocation] = []
    var photos : [FlickrPhoto] = []
    
    // MARK: Setups
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager = TrackerManager(controller: self)
        manager.setupView()
        manager.startWalk()
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
}

// MARK: Location Manager Delegate

extension TrackerViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let firtsLocation = locations.first, locationList.count == 0 {
            self.manager.loadWalkStartedImage()
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

                if distance > Measurement(value: value, unit: UnitLength.meters){
                    self.manager.fetchPhotoByLocation(lat: newLocation.coordinate.latitude, lon:newLocation.coordinate.longitude )
                }
            }
            locationList.append(newLocation)
        }
    }
}

