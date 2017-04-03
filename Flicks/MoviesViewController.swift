//
//  MoviesViewController.swift
//  Flicks
//
//  Created by Janvier Wijaya on 4/1/17.
//  Copyright © 2017 Janvier Wijaya. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  @IBOutlet weak var errorLabel: UILabel!
  @IBOutlet weak var errorView: UIView!
  @IBOutlet weak var tableView: UITableView!

  var movies: [NSDictionary] = []
  var endpoint: String!

  override func viewDidLoad() {
    super.viewDidLoad()

    tableView.dataSource = self
    tableView.delegate = self

    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
    tableView.insertSubview(refreshControl, at: 0)

    refreshControlAction(refreshControl);
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()

    tableView.contentInset.top = topLayoutGuide.length
    tableView.contentInset.bottom = bottomLayoutGuide.length
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return movies.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
    let movie = movies[indexPath.row]

    let title = movie["original_title"] as? String
    cell.titleLabel.text = title

    let overview = movie["overview"] as? String
    cell.overviewLabel.text = overview

    if let posterPath = movie["poster_path"] as? String {
      // let baseUrl = "https://image.tmdb.org/t/p/w500"
      // let baseUrl = "https://image.tmdb.org/t/p/w45"
      let baseUrl = "https://image.tmdb.org/t/p/original"
      let imageUrl = URL(string: baseUrl + posterPath)
      cell.posterImageView.setImageWith(imageUrl!)
    }

    return cell
  }

  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let cell = sender as! UITableViewCell
    let indexPath = tableView.indexPath(for: cell)
    let movie = movies[indexPath!.row]

    let detailViewController = segue.destination as! MovieDetailViewController
    detailViewController.movie = movie
  }

  func refreshControlAction(_ refreshControl: UIRefreshControl) {
    let apiKey = "3c88efa87d5b0c99424a9a59352da5f0"
    let url = URL(string: "https://api.themoviedb.org/3/movie/\(endpoint!)?api_key=\(apiKey)")
    let request = URLRequest(url: url!)
    let session = URLSession(
        configuration: URLSessionConfiguration.default,
        delegate: nil,
        delegateQueue: OperationQueue.main
    )

    // Display HUD right before a request is made
    MBProgressHUD.showAdded(to: self.view, animated: true)
    
    let task: URLSessionDataTask = session.dataTask(
        with: request as URLRequest,
        completionHandler: { (data, response, error) in
          if error != nil {
            self.errorLabel.text = "Network Error"
            self.errorView.isHidden = false
          } else if let data = data {
            self.errorView.isHidden = true

            if let responseDictionary = try! JSONSerialization.jsonObject(
                with: data, options: []) as? NSDictionary {
              self.movies = responseDictionary["results"] as! [NSDictionary]
              self.tableView.reloadData()

              refreshControl.endRefreshing()
            }
          }

          // Hide HUD once the network request comes back (must be done on main UI thread)
          MBProgressHUD.hide(for: self.view, animated: true)
    });
    task.resume()
  }
}
