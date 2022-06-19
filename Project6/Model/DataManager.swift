//
//  DataManager.swift
//  Project6
//
//  Created for MPCS 501030
//

import Foundation
class DataManager {
    //
    // MARK: - Singleton
    //
    public static let sharedInstance = DataManager()
    private let defaults = UserDefaults.standard
    /// List of movies retrieved from iTunes, does not mutate with filters, maintains original fetch data
    private(set) var movies: [Movie]
    /// List of movies retrieved from iTunes, and then filtered based on user input
    private(set) var filteredMovies: [Movie]
    private(set) var priceLimitFilter: Float
    // Set variables to record button status (release date filter)
    private(set) var pressed: Int
    
    private(set) var ratingFilter: String
    
    var priceLimitDisplayString: String {
        return "$\(priceLimitFilter)"
    }
    // Init with default values
    private init() {
        priceLimitFilter = 20
        ratingFilter = "anyRating"
        movies = []
        filteredMovies = []
        pressed = 0
    }
    func refreshMovieData(_ movies: [Movie]) {
        self.movies = movies
        self.filteredMovies = movies
    }
    func update_filtermovie(_ filteredMovies: [Movie]) {
        self.filteredMovies = filteredMovies
    }
    
    func update_filter(priceLimit: Float? = nil, rating: String? = nil) {
        if let priceLimit = priceLimit {
            self.priceLimitFilter = priceLimit
        }
        
        if let rating = rating {
            self.ratingFilter = rating
        }
    }
    
    // Set variables to record network connection status
    func saveNet(condition: Int) {
        defaults.set(condition, forKey: "net")
    }
    
    // View network connection status
    func getNet() -> Int{
        let condition = defaults.integer(forKey: "net")
        if(condition != nil){
                return condition
        }else{
            return 0
        }
    }
    
    // Save the current search term
    func saveSearchItems(searchItems: String) {
        defaults.set(searchItems, forKey: "search")
        print(defaults.string(forKey: "search") ?? "no")
    }
    
    // Get the current search term
    func getSearchItems() -> String{
        let userid = defaults.string(forKey: "search")
        if(userid != nil){
                return userid!
        }else{
            return "Love"
        }
    }
    
    // Sort by movie release date
    func orderDate(pressed: Int){
        if pressed == 0{
            self.movies = self.movies.sorted(by: { (obj1, obj2) -> Bool in
                let dateFormater = DateFormatter()
                dateFormater.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                let date1 = dateFormater.date(from: (obj1.releaseDate)!)
                let date2 = dateFormater.date(from: (obj2.releaseDate)!)
                return date1?.compare(date2!) == .orderedDescending
            })
            self.pressed = 1
        } else{
            self.movies = self.movies.sorted(by: { (obj1, obj2) -> Bool in
                let dateFormater = DateFormatter()
                dateFormater.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                let date1 = dateFormater.date(from: (obj1.releaseDate)!)
                let date2 = dateFormater.date(from: (obj2.releaseDate)!)
                return date1?.compare(date2!) == .orderedAscending
            })
            self.pressed = 0
        }
        
    }
}
