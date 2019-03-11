//
//  FlickrManager.swift
//  WalkTracker
//
//  Created by Maria Ortega on 27/02/2019.
//  Copyright © 2019 Maria Ortega. All rights reserved.
//

import UIKit
import CoreLocation

class FlickrManager {
    
    func flickrURLFromParameters(lat: CLLocationDegrees, lon: CLLocationDegrees) -> URL {
        
        // Build base URL
        var components = URLComponents()
        components.scheme = Constants.FlickrURLParams.APIScheme
        components.host = Constants.FlickrURLParams.APIHost
        components.path = Constants.FlickrURLParams.APIPath
        
        // Build query string
        components.queryItems = [URLQueryItem]()
        
        // Query components
        components.queryItems!.append(URLQueryItem(name: Constants.FlickrAPIKeys.APIKey, value: Constants.FlickrAPIValues.APIKey))
        components.queryItems!.append(URLQueryItem(name: Constants.FlickrAPIKeys.SearchMethod, value: Constants.FlickrAPIValues.SearchMethod))
        components.queryItems!.append(URLQueryItem(name: Constants.FlickrAPIKeys.ResponseFormat, value: Constants.FlickrAPIValues.ResponseFormat))
        components.queryItems!.append(URLQueryItem(name: Constants.FlickrAPIKeys.Extras, value: Constants.FlickrAPIValues.MediumURL))
        components.queryItems!.append(URLQueryItem(name: Constants.FlickrAPIKeys.Radius, value: Constants.FlickrAPIValues.Radius))
        components.queryItems!.append(URLQueryItem(name: Constants.FlickrAPIKeys.SafeSearch, value: Constants.FlickrAPIValues.SafeSearch))
        components.queryItems!.append(URLQueryItem(name: Constants.FlickrAPIKeys.DisableJSONCallback, value: Constants.FlickrAPIValues.DisableJSONCallback))
        components.queryItems!.append(URLQueryItem(name: Constants.FlickrAPIKeys.Per_page, value: Constants.FlickrAPIValues.Per_page))
        components.queryItems!.append(URLQueryItem(name: Constants.FlickrAPIKeys.Page, value: Constants.FlickrAPIValues.Page))
        components.queryItems!.append(URLQueryItem(name: Constants.FlickrAPIKeys.Lat, value: "\(lat)"))
        components.queryItems!.append(URLQueryItem(name: Constants.FlickrAPIKeys.Lon, value: "\(lon)"))
        
        return components.url!
    }
    
    func fetchFlickrPhoto(_ searchURL: URL, index: Int, completion: @escaping (Result<FlickrPhoto>) -> Void) {
        
        let session = URLSession.shared
        let request = URLRequest(url: searchURL)
        
        let task = session.dataTask(with: request) {
            (data, response, error) in
            if (error == nil) {
                
                // Check response code
                let status = (response as! HTTPURLResponse).statusCode
                if (status < 200 || status > 300) {
                    completion(Result.results(self.loadNoAvailablePhoto(searchURL: searchURL, index: index)))
                }
                
                // Check data returned
                guard let data = data else {
                    completion(Result.results(self.loadNoAvailablePhoto(searchURL: searchURL, index: index)))
                    return
                }
                
                // Parse the Data
                let parsedResult: [String:AnyObject]!
                do {
                    parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:AnyObject]
                } catch {
                    completion(Result.results(self.loadNoAvailablePhoto(searchURL: searchURL, index: index)))
                    return
                }
                
                // Check for Photos
                guard let photosDictionary = parsedResult["photos"] as? [String:AnyObject] else {
                    completion(Result.results(self.loadNoAvailablePhoto(searchURL: searchURL, index: index)))
                    return
                }
                
                guard let photosArray = photosDictionary["photo"] as? [[String: AnyObject]] else {
                    completion(Result.results(self.loadNoAvailablePhoto(searchURL: searchURL, index: index)))
                    return
                }
                
                // Check if there is coming any Photo
                if photosArray.count == 0 {
                    completion(Result.results(self.loadNoAvailablePhoto(searchURL: searchURL, index: index)))
                } else {
                    let photoDictionary = photosArray[0] as [String: AnyObject]
                    guard
                        let imageUrlString = photoDictionary["url_m"] as? String,
                        let photoID = photoDictionary["id"] as? String else {
                            completion(Result.results(self.loadNoAvailablePhoto(searchURL: searchURL, index: index)))
                            return
                    }
                    
                    // Return an avaliable Flickr Photo
                    let flickrPhoto = FlickrPhoto.init(photoID: photoID, imageURL: imageUrlString, index: index)
                    flickrPhoto.loadImage(loadURL: imageUrlString, completion: { (photo) in
                        completion(photo)
                    })
                }
            }
            else {
                completion(Result.results(self.loadNoAvailablePhoto(searchURL: searchURL, index: index)))
            }
        }
        task.resume()
    }
    
    // Return an NON avaliable Flickr Photo
    
    func loadNoAvailablePhoto(searchURL: URL, index: Int) -> FlickrPhoto {
        let photoID = "noPhoto_" + "\(searchURL)_" + UUID().uuidString
        let flickrPhoto = FlickrPhoto.init(photoID: photoID, imageURL: "", index: index)
        flickrPhoto.largeImage = UIImage(named: "noPhoto.png")
        return flickrPhoto
    }
}
