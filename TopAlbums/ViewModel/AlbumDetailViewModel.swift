//
//  AlbumDetailViewModel.swift
//  TopAlbums
//
//  Created by Venkata Manoj Tunuguntla on 1/12/20.
//  Copyright © 2020 Venkata Manoj Tunuguntla. All rights reserved.
//

import Foundation
import UIKit

/// View Model to fetch the album details & update the data in the ViewController
class AlbumDetailViewModel{
    
    var albumListViewModel:AlbumListViewModel?
    
    /// selected album info to be presented on the details screen
    var selectedAlbum: Album?{
        return albumListViewModel?.selectedAlbumInfo ?? nil
    }
    
    /// album name
    var albumName: String{
        return selectedAlbum?.name ?? ""
    }
    
    /// Accessibility label for album name
    var albumNameAccessibilityLabel: String{
        return Constants.album + albumName
    }
    
    /// Accessibility label for artist name
    var artistNameAccessibilityLabel: String{
        return Constants.artist + artistName
    }
    
    /// artist name
    var artistName: String{
        return selectedAlbum?.artistName ?? ""
    }
    
    /// Copy Right info
    var copyRightInfo: String{
        return selectedAlbum?.copyright ?? ""
    }
    
    /// Release Date
    var releaseDate: String{
        return Constants.releaseDate + (selectedAlbum?.releaseDate ?? "")
    }
    
    /// selected album genres
    var selectedAlbumGenres:String{
        let genres = Constants.genre + (selectedAlbum?.genres.map { "\($0.name)" }.joined(separator: ", ") ?? "")
        return genres
    }
    
    /// Art Image
    var artImage:UIImage {
        return selectedAlbum?.artWorkImage ?? UIImage()
    }
    
    /// Music URL to open in the Music app
    var musicURL:String{
        return selectedAlbum?.url ?? ""
    }
}
