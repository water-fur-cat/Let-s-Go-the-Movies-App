//
//  Movie.swift
//  Project6
//
//  Created for MPCS 501030
//

import Foundation

// modify to class
class movielist: Codable {
    let results: [Movie]
}

/// A move type with data matching the iTunes API (note that the names have historically music-like names)
struct Movie : Codable, Hashable {
    let trackName: String?
    let trackPrice: Float?
    let contentAdvisoryRating: String?
    let artworkUrl100: String?
    let longDescription: String?
    let previewUrl: String?
    let releaseDate: String?

    var trackPrice_TOSTRING: String {
        if let trackPrice = trackPrice {
            return "$\(trackPrice)"
        } else {
            return "Unknown Price"
        }
    }
}


