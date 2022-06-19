//
//  MoviesCollectionViewController.swift
//  Project6
//
//  Created for MPCS 501030
//

import UIKit

class MoviesCollectionViewController: UICollectionViewController {
    
    var dataSource: UICollectionViewDiffableDataSource<Int, Movie>!
    
    //
    // MARK: - Lifecycle
    //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up a search controller to show in the `NavigationBar`
        // Note that we are not using the full `SearchResults` functionality, we
        // are really only using it to present a `UISearchBar`
        let srchCtr = UISearchController(searchResultsController: nil)
        srchCtr.searchBar.delegate = self
        srchCtr.searchBar.text = DataManager.sharedInstance.getSearchItems()
        srchCtr.searchBar.delegate = self
        srchCtr.searchBar.showsCancelButton = true
        navigationItem.hidesSearchBarWhenScrolling = true
        navigationItem.searchController = srchCtr
        DataManager.sharedInstance.saveNet(condition: 1)
        
        let searchItems =
            srchCtr.searchBar.text!
        
        // Use the `MovieClient` to fetch a list of movies
        print("DEBUG ----> about to fetch movies")
        MovieClient.fetchMovies(searchItem: searchItems) { [weak self] moviesData, error in
            guard let moviesData = moviesData, error == nil else {
                print(error ?? NSError())
                return
            }
            
            DataManager.sharedInstance.refreshMovieData(moviesData.results)
            /// Update the collection view based on the current state of the `data` property
            var snapshot = NSDiffableDataSourceSnapshot<Int, Movie>()
            snapshot.appendSections([0])
            snapshot.appendItems(DataManager.sharedInstance.movies)
            
            self?.dataSource.apply(snapshot)
        }
        
        // Create the layout for the collection view
        collectionView.collectionViewLayout = makeLayout()
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) { collectionView, indexPath, state in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell",
                                                          for: indexPath) as! MoviesCollectionViewCell
            cell.titleLabel.text = state.trackName
            cell.priceLabel.text = state.trackPrice_TOSTRING
            cell.ratingLabel.text = state.contentAdvisoryRating
            // FIXME: Use the new iOS15 Asycn Image API and include a placeholder mage
            cell.imageView.image = UIImage(systemName: "swift")
            MovieClient.getImage ( url: state.artworkUrl100 ?? "", completion: { (image, error) in
                guard let image = image, error == nil else {
                    print(error ?? "")
                    return
                }
                let decodedImage = image.preparingForDisplay()!
                cell.imageView.image = decodedImage
                let bgcolor = image.getAverageColour as UIColor?
                let semi = bgcolor?.withAlphaComponent(0.5)
                cell.backgroundColor = semi
                
//                print(decodedImage.getAverageColour)
//                print("cell background")
            })
                
            
            return cell
        }
    
        /// Update the collection view based on the current state of the `data` property
        var snapshot = NSDiffableDataSourceSnapshot<Int, Movie>()
        snapshot.appendSections([0])
        snapshot.appendItems(DataManager.sharedInstance.movies)
        
        dataSource.apply(snapshot)
    }

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
}

//
// MARK: - Navigation
//

extension MoviesCollectionViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // There are two segue possible from this view controller: the popover filter or the detail view controller
        if segue.identifier == "popover" {
            let filtersViewController = segue.destination as? FiltersViewController
            filtersViewController?.delegate = self
            segue.destination.preferredContentSize = CGSize(width: 300, height: 200)
            
            if let presentationController = segue.destination.popoverPresentationController { // 1
                presentationController.delegate = self // 2
            }
        } else {
            guard let detailViewController = segue.destination as? DetailViewController,
                  let selectedRow = collectionView.indexPathsForSelectedItems?.first?.row else {
                return
            }
            
            detailViewController.movie = DataManager.sharedInstance.filteredMovies[selectedRow]
        }
    }
}

//
// MARK: - Protocol Extensions
//

extension MoviesCollectionViewController: UIPopoverPresentationControllerDelegate {
    
    /// Delegate method to enforce the correct popover style
    func adaptivePresentationStyle(for controller: UIPresentationController,
                                   traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}

extension MoviesCollectionViewController: MoviesFilterDelegate {

    // FIXME: Update the collection view based on the popover filters (including the release date)
    /// Update the collection view based on the popover filter selections
    func changeFilter(price: Float, rating: String) {
        let filteredMovies = DataManager.sharedInstance.movies.filter { movie in
            let isBelowSelectedPriceLimit = movie.trackPrice ?? 0 < price
            let matchesSelectedRating = (rating == "anyRating" || movie.contentAdvisoryRating == rating)
//            print(rating)
//            print(matchesSelectedRating)
//            print(isBelowSelectedPriceLimit)
            
            return isBelowSelectedPriceLimit && matchesSelectedRating
        }
        
        DataManager.sharedInstance.update_filtermovie(filteredMovies)
        
        /// Update the collection view based on the current state of the `data` property
        var snapshot = NSDiffableDataSourceSnapshot<Int, Movie>()
        snapshot.appendSections([0])
        snapshot.appendItems(DataManager.sharedInstance.filteredMovies)
        
        dataSource.apply(snapshot)
    }
}

extension MoviesCollectionViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // FIXME: Search after enter
        print("Clicked")
        searchBar.delegate = self
        let searchItems = searchBar.text!
//        DataManager.sharedInstance.saveSearchItems(searchItems: searchItems)
        
        MovieClient.fetchMovies(searchItem: searchItems) { [weak self] moviesData, error in
            guard let moviesData = moviesData, error == nil else {
                print(error ?? NSError())
                print("----------------------")
                return
            }
            
            DataManager.sharedInstance.refreshMovieData(moviesData.results)
            if DataManager.sharedInstance.getNet() == 0{
                searchBar.text = DataManager.sharedInstance.getSearchItems()
//                print(DataManager.sharedInstance.getSearchItems())
//                print(searchBar.text)
            } else{
                DataManager.sharedInstance.saveSearchItems(searchItems: searchItems)
            }
            /// Update the collection view based on the current state of the `data` property
            var snapshot = NSDiffableDataSourceSnapshot<Int, Movie>()
            snapshot.appendSections([0])
            snapshot.appendItems(DataManager.sharedInstance.movies)
            
            self?.dataSource.apply(snapshot)
        }
        
        // Create the layout for the collection view
        collectionView.collectionViewLayout = makeLayout()
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) { collectionView, indexPath, state in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell",
                                                          for: indexPath) as! MoviesCollectionViewCell
            cell.titleLabel.text = state.trackName
            cell.priceLabel.text = state.trackPrice_TOSTRING
            cell.ratingLabel.text = state.contentAdvisoryRating
            
            // FIXME: Use the new iOS15 Asycn Image API and include a placeholder mage
            cell.imageView.image = UIImage(systemName: "swift")
            MovieClient.getImage ( url: state.artworkUrl100 ?? "", completion: { (image, error) in
                guard let image = image, error == nil else {
                    print(error ?? "")
                    return
                }
                let decodedImage = image.preparingForDisplay()!
                cell.imageView.image = decodedImage
                let bgcolor = image.getAverageColour as UIColor?
                let semi = bgcolor?.withAlphaComponent(0.5)
                cell.backgroundColor = semi
            })
            
            return cell
        }
    
        /// Update the collection view based on the current state of the `data` property
        var snapshot = NSDiffableDataSourceSnapshot<Int, Movie>()
        snapshot.appendSections([0])
        snapshot.appendItems(DataManager.sharedInstance.movies)
        
        dataSource.apply(snapshot)
    }
}

//
// MARK: - Collection View Setup
//

private extension MoviesCollectionViewController {
    
    //FIXME: Update the layout as you see fit to make it look "good"
    func makeLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (section: Int, environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: NSCollectionLayoutDimension.fractionalWidth(1.0),
                                                                                 heightDimension: NSCollectionLayoutDimension.absolute(200)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),  heightDimension: .absolute(200))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
            return section
        }
    }

}


// Find the average color of the movie poster image and use it as the cell's backgroundColor
extension UIImage {
    var getAverageColour: UIColor? {
        //A CIImage object is the image data you want to process.
        guard let inputImage = CIImage(image: self) else { return nil }
        // A CIVector object representing the rectangular region of inputImage .
        let extentVector = CIVector(x: inputImage.extent.origin.x, y: inputImage.extent.origin.y, z: inputImage.extent.size.width, w: inputImage.extent.size.height)
        
        guard let filter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: extentVector]) else { return nil }
        guard let outputImage = filter.outputImage else { return nil }

        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: [.workingColorSpace: kCFNull])
        context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: .RGBA8, colorSpace: nil)

        return UIColor(red: CGFloat(bitmap[0]) / 255, green: CGFloat(bitmap[1]) / 255, blue: CGFloat(bitmap[2]) / 255, alpha: CGFloat(bitmap[3]) / 255)
    }
}
