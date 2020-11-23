//
//  UIImageView.swift
//  WearPicker
//
//  Created by Madara2hor on 16.11.2020.
//

import Foundation
import UIKit

let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            guard let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) else {
                if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                    imageCache.setObject(image, forKey: url.absoluteString as NSString)
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
                return
            }
            DispatchQueue.main.async {
                self?.image = cachedImage
            }
        }
    }
    
}


