//
//  Constants.swift
//  WalkTracker
//
//  Created by Maria Ortega on 27/02/2019.
//  Copyright © 2019 Maria Ortega. All rights reserved.
//

import UIKit

struct Constants {
    
    // MARK: Flickr API Constants
    
    struct FlickrURLParams {
        static let APIScheme = "https"
        static let APIHost = "api.flickr.com"
        static let APIPath = "/services/rest"
    }
    
    struct FlickrAPIKeys {
        static let SearchMethod = "method"
        static let APIKey = "api_key"
        static let Sort = "sort"
        static let Lat = "lat"
        static let Lon = "lon"
        static let Radius = "radius"
        static let Per_page = "per_page"
        static let Page = "page"
        static let ResponseFormat = "format"
        static let DisableJSONCallback = "nojsoncallback"
        static let SafeSearch = "safe_search"
        static let Extras = "extras"
    }
    
    struct FlickrAPIValues {
        static let SearchMethod = "flickr.photos.search"
        static let APIKey = "f36327ec313fd49c1951ea714cbc2910"
        static let Radius = "0.01"
        static let Per_page = "1"
        static let Page = "1"
        static let ResponseFormat = "json"
        static let DisableJSONCallback = "1"
        static let SafeSearch = "1"
        static let MediumURL = "url_m"
    }
}
