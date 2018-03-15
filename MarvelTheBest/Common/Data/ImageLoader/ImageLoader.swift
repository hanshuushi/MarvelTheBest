//
//  ImageLoader.swift
//  MarvelTheBest
//
//  Created by 范舟弛 on 2018/3/14.
//  Copyright © 2018年 范舟弛. All rights reserved.
//

import Foundation

//class ImageLoader: NSObject {
//    static let share: ImageLoader = ImageLoader()
//
//    func getImage(of urlString: String) {
//
//    }
//}
//
//extension ImageLoader: URLSessionDelegate, URLSessionDelegate {
//
//}


protocol ImageLoader: NSObjectProtocol {
    var dataTast: URLSessionDataTask? {get set}
    
    func setImage(_ image: UIImage?)
    
    static func getPlaceHolderImage() -> UIImage?
}

fileprivate let sessionQueue: OperationQueue = {
    let queue = OperationQueue()
    
    queue.name = "com.latte.marvel.imageloader"
    
    return queue
}()

extension ImageLoader {
    func cancelDownload() {
        dataTast?.cancel()
        dataTast = nil
        
        setImage(Self.getPlaceHolderImage())
    }
    
    func download(from url: URL) {
        cancelDownload()
        
        if let image = ImageLoaderCacheManager.share.getImage(for: url) {
            setImage(image)
            
            return
        }
        
        let urlRequest = URLRequest(url: url)
        
        let session = URLSession(configuration: .default,
                                 delegate: nil,
                                 delegateQueue: sessionQueue)
        
        dataTast = session.dataTask(with: urlRequest,
                                    completionHandler: {
                                        [weak self] (data, _, error) in
                                        
                                        guard let `self` = self else {
                                            return
                                        }
                                        
                                        if let `error` = error {
                                            DispatchQueue.main.async {
                                                self.setImage(Self.getPlaceHolderImage())
                                            }
                                            
                                            debugPrint("error is \(error)")
                                            
                                            return
                                        }
                                        
                                        let image = data.flatMap({ UIImage(data: $0) })
                                        
                                        if let `image` = image {
                                            ImageLoaderCacheManager.share.set(image: image, for: url)
                                        }
                                        
                                        DispatchQueue.main.async {
                                            self.setImage(image)
                                        }
        })
        dataTast!.resume()
    }
}

fileprivate class ImageLoaderCacheManager: NSObject {
    static let share: ImageLoaderCacheManager = ImageLoaderCacheManager()
    
    var cache: NSCache<NSString, UIImage>
    
    func set(image: UIImage, for key: URL) {
        cache.setObject(image,
                        forKey: key.absoluteString as NSString)
    }
    
    func getImage(for key: URL) -> UIImage? {
        return cache.object(forKey: key.absoluteString as NSString)
    }
    
    override init() {
        cache = NSCache<NSString, UIImage>()
        
        super.init()
    }
}
