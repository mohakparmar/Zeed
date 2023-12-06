//
//  CustomImageView.swift
//  Zeed
//
//  Created by Shrey Gupta on 28/02/21.
//

import UIKit

var imageCache = [String: UIImage]()

class CustomImageView: UIImageView {
    
    var lastImageURLUsedToLoadImage: String?
    
    func loadImage(from urlString: String){
        
        //set image to nil
        self.image = nil
        self.backgroundColor = .backgroundWhiteColor
        
        //set lastImageURLUsedToLoadImage
        lastImageURLUsedToLoadImage = urlString
        
        //check if image exists in cache
        if let cachedImage = imageCache[urlString]{
            self.image = cachedImage
            return
        }
        //image does not exists in cache
        // url for image
        guard let url = URL(string: urlString) else { return }
        
        //fetch contents of url
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("DEBUG: Error from loadImage: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.image = UIImage(named: "zeed_logo_tiny")
                }
                return
            }

            if self.lastImageURLUsedToLoadImage != url.absoluteString {
                DispatchQueue.main.async {
                    self.image = UIImage(named: "zeed_logo_tiny")
                }
                return

            }
            
            //get image data
            guard let imageData = data else { return }
            
            //create image from imageData
            let image = UIImage(data: imageData)
            
            //set key and value for image cache
            imageCache[url.absoluteString] = image
            
            // set out retrieved image
            DispatchQueue.main.async {
                self.image = image
                if image == nil {
                    self.image = UIImage(named: "zeed_logo_tiny")
                }
            }
        }.resume()
    }
}
