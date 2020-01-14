//
//  AlbumsAPIClient.swift
//  TopAlbums
//
//  Created by Venkata Manoj Tunuguntla on 1/12/20.
//  Copyright © 2020 Venkata Manoj Tunuguntla. All rights reserved.
//

import Foundation

class AlbumsAPIClient {
    
    var urlSessionDataTasks : [URLSessionDataTask] = []
    
    /// To fetch the list of top 100 albums in Apple music rss feed. Currently the parameter is hardcoded for the Prototype
    /// - Parameter completion: closure
    func fetchTopAlbums(completion: @escaping (_ feedResponse: RssFeed?,_ error: String?)->()) {
        let urlString = "https://rss.itunes.apple.com/api/v1/us/apple-music/top-albums/all/100/explicit.json"
        
        guard let url = URL(string: urlString.percentageEncodedString())else{
            print("Error Unwrapping URL")
            return
        }
        
        let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if error != nil {
                completion(nil, error as? String)
                return
            }
            
            if let response = response as? HTTPURLResponse {
                
                switch response.statusCode {
                case 200...299:
                    guard let responseData = data else {
                        print("Error getting data")
                        completion(nil, error as? String)
                        return
                    }
                    do {
                        if let jsonData = try? JSONSerialization.jsonObject(with: responseData, options: .mutableContainers) {
                            print(jsonData)
                            let rssFeedResponse = try JSONDecoder().decode(RssFeed.self, from: responseData)
                            print(rssFeedResponse)
                            completion(rssFeedResponse, error as? String)
                        }
                    }catch {
                        print(error)
                        completion(nil, error as? String)
                    }
                default:
                    completion(nil, error as? String)
                    return
                }
            }
        }
        dataTask.resume()
    }
    
    /// Download the image at index
    /// - Parameters:
    ///   - index: Index of row
    ///   - stringURL: string url of the image to be downloaded
    ///   - completion: closure
    func downloadImage(for index:Int, stringURL: String, completion: @escaping (_ imageData:Data?, _ index:Int, _ error:String?)->()) {
        
        guard let url = URL(string: stringURL.percentageEncodedString())else{
            print("Error Unwrapping URL")
            return
        }
        
        guard urlSessionDataTasks.firstIndex(where: { $0.originalRequest?.url == url }) == nil else {
            // Image Download is already in progress
            return
        }
        let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if error != nil {
                completion(nil, index, error as? String)
                return
            }
            
            if let response = response as? HTTPURLResponse {
                
                switch response.statusCode {
                case 200...299:
                    guard let responseData = data else {
                        print("Error getting data")
                        completion(nil, index, error as? String)
                        return
                    }
                    
                    completion(responseData, index, error as? String)
                    
                default:
                    completion(nil, index, error as? String)
                    return
                }
            }
        }
        dataTask.resume()
        urlSessionDataTasks.append(dataTask)
    }
    
    /// To cancel the image download
    /// - Parameter stringURL: string URL of the Image
    func cancelDownloadingImage(for stringURL: String) {
        
        guard let url = URL(string: stringURL.percentageEncodedString())else{
            print("Error Unwrapping URL")
            return
        }
        
        //if there is no existing data task for the specific image item, do not cancel it
        guard let dataTaskIndex = urlSessionDataTasks.firstIndex(where: { $0.originalRequest?.url == url }) else {
            return
        }
        
        let dataTask =  urlSessionDataTasks[dataTaskIndex]
        
        // cancel and remove the dataTask from the urlSessionDataTasks array
        dataTask.cancel()
        urlSessionDataTasks.remove(at: dataTaskIndex)
    }
}

extension String {
    //Encode the url query string
    func percentageEncodedString() -> String {
        guard let percentageEncodedUrlString = self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return self
        }
        return percentageEncodedUrlString
    }
}
