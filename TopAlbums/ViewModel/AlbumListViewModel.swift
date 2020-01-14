//
//  AlbumListViewModel.swift
//  TopAlbums
//
//  Created by Venkata Manoj Tunuguntla on 1/12/20.
//  Copyright © 2020 Venkata Manoj Tunuguntla. All rights reserved.
//

import Foundation
import UIKit

/// View Model to fetch the list of Albums & parse the data (using model classes) & update the data in the ViewController
class AlbumListViewModel{
    //The fetched list of albums & store in this private variable.
    private var albumList:AlbumList = AlbumList()
    
    //To store the selected album info when user selects an album
    private var selectedAlbum:Album?
    
    //API client to fetch the list of Top Albums
    var albumAPIClient:AlbumsAPIClient = {
           return AlbumsAPIClient()
    }()
    
    //use the selected album info while navigating to the album details view
    var selectedAlbumInfo: Album?{
        return selectedAlbum ?? nil
    }

    
    /// To Fetch the top Albums list. The request is currently hardcoded for prototype to fetch the 100 top albums in the RSS feed
    /// - Parameter completion: closure to update the table view
    func fetchTopAlbumsList(completion: @escaping () -> Void) {
        albumAPIClient.fetchTopAlbums { [weak self](rssFeed, errorString) in
            
            guard let albums = rssFeed?.feed.albums else{
                return
            }
            DispatchQueue.main.async { [weak self] in
                self?.albumList = albums
                completion()
            }
        }
    }
    
    /// To validate & fetch the art image at the respective index
    /// - Parameters:
    ///   - index: index of table view cell
    ///   - completion: closure to update the table view with the downloaded image
    func artImageAtIndex(atIndex index: Int, completion: @escaping(_ index:Int) -> Void) -> UIImage? {
        
        //If image is already downlaoded & available, return to update the tableview
        guard let artImage = albumList[index].artWorkImage else {
            //If the image isn't available, send request to download the art image
            self.fetchArtImage(forIndex: index) { (imageAtIndex) in
                DispatchQueue.main.async {
                    //Update the image & reload the table view at the respective index path
                    completion(imageAtIndex)
                }
            }
            return nil
        }
        
        return artImage
    }
    
    /// To download the art image at the index
    /// - Parameters:
    ///   - index: index path
    ///   - completion: closure to update the tableview
    func fetchArtImage(forIndex index: Int, completion: @escaping(_ index:Int) -> Void) {
        
        let stringURL = albumList[index].artworkUrl100
        //download the image
        albumAPIClient.downloadImage(for: index, stringURL: stringURL) { [weak self] (data, index, errorString) in
            
            guard let imageData = data, let image = UIImage(data: imageData) else {
                return
            }
            DispatchQueue.main.async { [weak self] in
                //update the image data in the data source
                self?.albumList[index].artWorkImage = image
                completion(index)
            }
        }
    }
    
    /// To cancel the image fetching at index
    /// - Parameter index: index to cancel
    func cancelImageFetch(forIndex index: Int) {
        let stringURL = albumList[index].artworkUrl100
        albumAPIClient.cancelDownloadingImage(for: stringURL)
    }
    
    //To provide the number of rows to be displayed in tableview
    func numberOfRows(in section: Int) -> Int {
        return self.albumList.count
    }
    
    //to return the album Name at a particular index while rendering the tableview Cell
    func albumName(at index: Int) -> String {
        return self.albumList[index].name
    }
    
    //to return the artist Name at a particular index while rendering the tableview Cell
    func artistName(at index: Int) -> String {
        return self.albumList[index].artistName
    }
    
    /// to get the accessibility label at index
    /// - Parameter index: Index
    func accessibilityLabel(at index: Int) -> String {
        return self.albumList[index].name + Constants.albumByArtist + self.albumList[index].artistName
    }
    
    /// When user selects a cell, before navigating to the details screen, save the selected album info
    /// - Parameter index: index
    func didSelectItem(at index: Int){
        self.selectedAlbum = self.albumList[index]
    }
    
    /// To prefetch the data
    /// - Parameter indexPaths: indexPaths of rows
    func prefetchRows(atIndexPaths indexPaths: [IndexPath]){
        indexPaths.forEach {
            self.fetchArtImage(forIndex: $0.row) {_ in
                return
            }
        }
    }
    
    /// To cancel the prefetching of data
    /// - Parameter indexPaths: indexpaths of rows
    func cancelPrefetchForRows(atIndexPaths indexPaths: [IndexPath]){
        indexPaths.forEach {
            self.cancelImageFetch(forIndex: $0.row)
        }
    }
}
