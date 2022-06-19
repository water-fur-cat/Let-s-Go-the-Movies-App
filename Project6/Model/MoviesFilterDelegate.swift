//
//  MoviesFilterDelegate.swift
//  Project6
//
//  Created for MPCS 501030
//

import Foundation

protocol MoviesFilterDelegate: AnyObject {
    func changeFilter(price: Float, rating: String)
}
