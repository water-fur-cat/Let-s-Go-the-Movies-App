//
//  DetailViewController.swift
//  Project6
//
//  Created for MPCS 501030
//

import UIKit

class DetailViewController: UIViewController {

    //
    // MARK: - IBOutlets
    //
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var ratingLabel: UILabel!
    @IBOutlet private var priceLabel: UILabel!
    @IBOutlet weak var textviewDesc: UITextView!
    @IBOutlet weak var DateLabel: UILabel!
    @IBOutlet weak var poster: UIImageView!

    var movie: Movie!

    //
    // MARK: - Lifecycle
    //
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = movie.trackName
        ratingLabel.text = "Rated \(String(describing: movie.contentAdvisoryRating))"
        priceLabel.text = movie.trackPrice_TOSTRING

//        print(movie.longDescription)
//        print("fine")
        
        // add a release date metrics
        let dateFormetter = DateFormatter()
        dateFormetter.locale = Locale(identifier: "en_US")
        dateFormetter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let datetime = dateFormetter.date(from: movie.releaseDate!)
        DateLabel.text = datetime?.formatted(date: .long, time: .omitted)
        poster.image = UIImage(systemName: "swift")
        MovieClient.getImage ( url: movie.artworkUrl100 ?? "", completion: { (image, error) in
            guard let image = image, error == nil else {
                print(error ?? "")
                return
            }
            self.poster.image = image
        })
        textviewDesc.textColor = .black
        textviewDesc.text = movie.longDescription
    }

    //
    // MARK: - IBActions
    //
    
    /// Open the current movie preview in Safari using system `UIApplication` method
    /// - Parameter sender: The button that was tapped
    @IBAction func openSafari(_ sender: UIBarButtonItem) {
        //FIXME: Link to Safari to show preview
        UIApplication.shared.open(NSURL(string: movie.previewUrl!)! as URL)
    }
}
