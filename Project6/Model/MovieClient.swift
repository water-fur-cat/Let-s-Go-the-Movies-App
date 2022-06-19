//
//  MovieClient.swift
//  Project6
//
//  Created for MPCS 501030
//

import Foundation
import UIKit

/// Creates a task that retrieves the contents of the an itunes URL, then calls a handler upon completion.
class MovieClient {
    
/// Fetch movies from iTunes with completion block
/// - Parameters:
///     - completion: A tuple with an `Array` of the movies and an error code
/// - Throws:
/// - Returns:
    static let cache = NSCache<NSString, UIImage>()
    static let cache2 = NSCache<NSString, movielist>()
    static func fetchMovies(searchItem: String, completion: @escaping (movielist?, Error?) -> Void) {
        let search = searchItem.split(separator:" ")
        let searchItem = search[0]
        print("Attempting to fetch movies")
        let url = URL(string: "https://itunes.apple.com/search?country=US&media=movie&limit=200&term=" + searchItem)!
        DataManager.sharedInstance.saveNet(condition: 1)
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
                                    
            guard let data = data, error == nil else {
                if let issues = self.cache2.object(forKey:"lastestSearch"){
//                    print("Using a cached result")
                    DataManager.sharedInstance.saveNet(condition: 0)
                    DispatchQueue.main.async { completion(issues, nil) }
                }else{
                    DispatchQueue.main.async { completion(nil, error) }
                }
                return
            }

            do{
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let issues = try decoder.decode(movielist.self, from: data)
                print("DEBUG ------> fetched new movies:", issues)
                DispatchQueue.main.async { completion(issues, nil) }
                self.cache2.setObject(issues, forKey: "lastestSearch")
                
            } catch(let parsingError) {
                DispatchQueue.main.async { completion(nil, parsingError) }
            }
        }
        task.resume()
    }
    
    // FIXME: Update this to cache an image. Always check to see if the image exists
    //        in cache before trying to download it. If you download it, then make sure
    //        to add it to the cache.
    static func getImage(url: String, completion: @escaping (UIImage?, Error?) -> Void) {
        let str_url = url
        let url=URL(string: url)!
        
        let session = URLSession.shared
        
        let task=session.dataTask(with:url as URL,completionHandler:{(data,response,error)->Void in
             guard let data = data, error == nil else {
                DispatchQueue.main.async { completion(nil, error) }
                return
           }
            
            if let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    // use cache to store image
                    if let cachedImage = self.cache.object(forKey: str_url as NSString){
                        print("Using a cached image for item")
                        completion(cachedImage, nil)
                        
                    }else{
                        completion(image, nil)
                        self.cache.setObject(image, forKey: str_url as NSString)
                    }
                }
            }else{
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        })
        task.resume()
    }
}
