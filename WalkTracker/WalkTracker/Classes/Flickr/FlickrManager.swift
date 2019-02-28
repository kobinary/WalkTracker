//
//  FlickrManager.swift
//  WalkTracker
//
//  Created by Maria Ortega on 27/02/2019.
//  Copyright © 2019 Maria Ortega. All rights reserved.
//

import UIKit
import CoreLocation

class FlickrManager: NSObject {

    // Generate API URL Request
    
    func flickrURLFromParameters(lat: CLLocationDegrees, lon: CLLocationDegrees) -> URL {
        
        // Build base URL
        var components = URLComponents()
        components.scheme = Constants.FlickrURLParams.APIScheme
        components.host = Constants.FlickrURLParams.APIHost
        components.path = Constants.FlickrURLParams.APIPath
        
        // Build query components
        components.queryItems = [URLQueryItem]()
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
    
    // Fetch Flickr photo and parse into a FlickrPhoto model.
    
    func fetchFlickrPhoto(_ searchURL: URL, index: Int, completion: @escaping (UIImage) -> Void) {
        
        let session = URLSession.shared
        let request = URLRequest(url: searchURL)
        
        let task = session.dataTask(with: request) {
            (data, response, error) in
            if (error == nil) {
              
                // Check response code
                let status = (response as! HTTPURLResponse).statusCode
                if (status < 200 || status > 300) {
                    // Error
                }
                
                // Check response data
                guard let data = data else {
                    // Error
                    return
                }
                
                // Parse the data
                let parsedResult: [String:AnyObject]!
                do {
                    parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
                } catch {
                    // Error
                    return
                }
                
                guard let photosDictionary = parsedResult["photos"] as? [String:AnyObject] else {
                    // Error
                    return
                }
                
                guard let photosArray = photosDictionary["photo"] as? [[String: AnyObject]] else {
                    // Error
                    return
                }
                
                // Check photos
                if photosArray.count == 0 {
                    // Error
                } else {
                    let photoDictionary = photosArray[0] as [String: AnyObject]
                    guard
                        let imageUrlString = photoDictionary["url_m"] as? String,
                        let photoID = photoDictionary["id"] as? String else {
                            // Error
                            return
                    }
                    
                    // Success
                    // TO DO ....
                }
            }
            else {
                // Error
            }
        }
        task.resume()
    }
}
