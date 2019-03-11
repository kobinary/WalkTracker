//
//  FlickrPhoto.swift
//  WalkTracker
//
//  Created by Maria Ortega on 28/02/2019.
//  Copyright © 2019 Maria Ortega. All rights reserved.
//

import UIKit

class FlickrPhoto: Equatable {
    
    // MARK: - Properties
    
    enum Error: Swift.Error {
        case invalidURL
        case noData
    }
    
    var largeImage: UIImage?
    let photoID: String
    let imageURL: String
    var index: Int = 0
    
    // MARK: - Setups
    
    init(photoID: String, imageURL: String, index: Int) {
        self.photoID = photoID
        self.imageURL = imageURL
        self.index = index
    }
    
    init(photoID: String, imageURL: String, index: Int, image: UIImage) {
        self.photoID = photoID
        self.imageURL = imageURL
        self.index = index
        self.largeImage = image
    }
    
    // MARK: - Image
    
    func loadImage(loadURL: String, completion: @escaping (Result<FlickrPhoto>) -> Void) {
        
        let loadRequest = URLRequest(url: URL(string: loadURL)!)
        
        URLSession.shared.dataTask(with: loadRequest) { (data, response, error) in
            if let error = error {
                DispatchQueue.main.async {
                    completion(Result.error(error))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(Result.error(Error.noData))
                }
                return
            }
            
            let returnedImage = UIImage(data: data)
            self.largeImage = returnedImage
            DispatchQueue.main.async {
                completion(Result.results(self))
            }
            }.resume()
    }
    
    // MARK: - Equal
    
    static func ==(lhs: FlickrPhoto, rhs: FlickrPhoto) -> Bool {
        return lhs.photoID == rhs.photoID
    }
}
