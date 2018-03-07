//
//  OperationGetStoryImage.swift
//  HackerNews
//
//  Created by Рамиз Кичибеков on 01.03.2018.
//  Copyright © 2018 Рамиз Кичибеков. All rights reserved.
//

import UIKit

final class OperationGetStoryImage: Operation {
    
    private var url: URL
    public var image: UIImage?
    static let imageCache = NSCache<NSString, AnyObject>()
    
    public init(_ url: URL) {
        self.url = url
        super.init()
        cancelOperation()
        main()
    }
    
    override func main() {
        cancelOperation()
        if let cachedImage = OperationGetStoryImage.imageCache.object(forKey: url.absoluteString as NSString) as? UIImage {
            self.image = cachedImage
        } else {
            downloadImage(with: url.getFaviconImageFromURL())
        }
    }
    
    //MARK: - Private methods
    
    private func downloadImage(with url: URL?) {
        guard let url = url else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let completionBlock = self.completionBlock, let data = data else {
                return
            }
            self.cancelOperation()
            if let imageFromURL = UIImage(data: data) {
                OperationGetStoryImage.imageCache.setObject(imageFromURL, forKey: url.absoluteString as NSString)
                self.image = imageFromURL
                completionBlock()
            } else if let string = String(data: data, encoding: .utf8), string.contains("unavailable") {
                self.downloadImage(with: self.url.getFaviconImageFromURL(true))
            } else {
                self.image = nil
                completionBlock()
                return
            }
        }.resume()
    }
    
}
