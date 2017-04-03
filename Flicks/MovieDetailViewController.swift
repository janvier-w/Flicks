//
//  MovieDetailViewController.swift
//  Flicks
//
//  Created by Janvier Wijaya on 4/2/17.
//  Copyright © 2017 Janvier Wijaya. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var posterImageView: UIImageView!
  @IBOutlet weak var infoView: UIView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var overviewLabel: UILabel!

  var movie: NSDictionary!

  override func viewDidLoad() {
    super.viewDidLoad()

    scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: infoView.frame.origin.y + infoView.frame.size.height)

    let title = movie["original_title"] as? String
    titleLabel.text = title

    let overview = movie["overview"] as? String
    overviewLabel.text = overview
    overviewLabel.sizeToFit()

    if let posterPath = movie["poster_path"] as? String {
      let baseUrl = "https://image.tmdb.org/t/p/w500"
      let imageUrl = URL(string: baseUrl + posterPath)
      posterImageView.setImageWith(imageUrl!)
    }
  }
}
