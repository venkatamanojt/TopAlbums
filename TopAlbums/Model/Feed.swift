//
//  Feed.swift
//  TopAlbums
//
//  Created by Venkata Manoj Tunuguntla on 1/12/20.
//  Copyright © 2020 Venkata Manoj Tunuguntla. All rights reserved.
//

import Foundation
import UIKit

///Model classes for the RSSFeed Top Albums
typealias AlbumList = [Album]

// MARK: - RssFeed
struct RssFeed: Codable {
    let feed: Feed
}

// MARK: - Feed
struct Feed: Codable {
    let title: String
    let id: String
    let author: Author
    let links: [Link]
    let copyright, country: String
    let icon: String
    let updated: String
    let albums: AlbumList
    
    enum CodingKeys: String, CodingKey {
        case title, id, author, links, copyright, country, icon, updated
        case albums = "results"
    }
}

// MARK: - Author
struct Author: Codable {
    let name: String
    let uri: String
}

// MARK: - Link
struct Link: Codable {
    let selfLink: String?
    let alternate: String?

    enum CodingKeys: String, CodingKey {
        case selfLink = "self"
        case alternate
    }
}
 

// MARK: - Album (Result)
struct Album: Codable {
    let artistName, id, releaseDate, name: String
    let kind: Kind
    let copyright, artistID: String
    let contentAdvisoryRating: String?
    let artistURL: String
    var artWorkImage: UIImage?
    let artworkUrl100: String
    let genres: [Genre]
    let url: String

    enum CodingKeys: String, CodingKey {
        case artistName, id, releaseDate, name, kind, copyright
        case artistID = "artistId"
        case contentAdvisoryRating
        case artistURL = "artistUrl"
        case artworkUrl100, genres, url
    }
}

// MARK: - Genre
struct Genre: Codable {
    let genreID, name: String
    let url: String

    enum CodingKeys: String, CodingKey {
        case genreID = "genreId"
        case name, url
    }
}

enum Kind: String, Codable {
    case album = "album"
}
