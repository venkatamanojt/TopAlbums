//
//  TopAlbumsViewController.swift
//  TopAlbums
//
//  Created by Venkata Manoj Tunuguntla on 1/11/20.
//  Copyright © 2020 Venkata Manoj Tunuguntla. All rights reserved.
//

import UIKit

/// View controller to display the list of Top Albums in RSS feed
class TopAlbumsViewController: UIViewController {
    
    /// albums table view
    private var albumTableView = UITableView()
    private var activityIndicatorView = UIActivityIndicatorView(style: .large)
    //View Model to fetch the data & also to do the processing
    var albumListViewModel: AlbumListViewModel = AlbumListViewModel()
    
    override func loadView() {
        super.loadView()
        initializeAlbumsView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    /// Initialization
    private func initializeAlbumsView() {
        self.title = Constants.navigationBarTitle
        self.initalizeAlbumTableView()
        //Update the data in the viewcontroller
        albumListViewModel.fetchTopAlbumsList { [weak self] in
            self?.activityIndicatorView.isHidden = true
            self?.activityIndicatorView.stopAnimating()
            self?.albumTableView.reloadData()
        }
    }
    
    /// Initialize tableview
    private func initalizeAlbumTableView() {
        albumTableView = UITableView(frame: self.view.bounds, style: .plain)
        albumTableView.delegate = self
        albumTableView.dataSource = self
        albumTableView.prefetchDataSource = self
        albumTableView.backgroundColor = .white
        //Accessibility: Group the different items in the album cell into one element for easier navigation
        albumTableView.isAccessibilityElement = false
        albumTableView.shouldGroupAccessibilityChildren = true
        albumTableView.translatesAutoresizingMaskIntoConstraints = false
        albumTableView.register(AlbumTableViewCell.self, forCellReuseIdentifier: Constants.reuseIdentifier)
        view.addSubview(albumTableView)
        
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.isHidden = false
        activityIndicatorView.startAnimating()
        view.addSubview(activityIndicatorView)
        
        //Add the constraints for the tableview, activity indicator View
        NSLayoutConstraint.activate([
            albumTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            albumTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            albumTableView.topAnchor.constraint(equalTo: view.topAnchor),
            albumTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

// Mark: TableView DataSource
extension TopAlbumsViewController : UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.reuseIdentifier, for: indexPath) as? AlbumTableViewCell else {
            return UITableViewCell()
        }
        
        //If the image is already downloaded, render it, if not fetch it
        if let artImage = albumListViewModel.artImageAtIndex(atIndex: indexPath.row, completion: { [weak self] (rowAtIndex) in
            //If the downloaded image (cell) isn't in visible scope, don't reload the tableview, else reload the respective rows
            DispatchQueue.main.async {
                let indexPath = IndexPath(row: rowAtIndex, section: 0)
                if self?.albumTableView.indexPathsForVisibleRows?.contains(indexPath) ?? false {
                    self?.albumTableView.reloadRows(at: [indexPath], with: .fade)
                }
            }
        }) {
            cell.artImageView.isHidden = false
            cell.artImageView.image = artImage
        } else {
            cell.artImageView.isHidden = true
        }
        cell.isAccessibilityElement = true
        cell.accessibilityLabel = albumListViewModel.accessibilityLabel(at: indexPath.row)
        cell.accessibilityTraits = .button
        cell.albumNameLabel.text = albumListViewModel.albumName(at: indexPath.row)
        cell.artistNameLabel.text = albumListViewModel.artistName(at: indexPath.row)
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albumListViewModel.numberOfRows(in: section)
    }
}

// Mark: TableView Delegate
extension TopAlbumsViewController : UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        albumListViewModel.didSelectItem(at: indexPath.row)
        albumTableView.deselectRow(at: indexPath, animated: true)
        //Navigate to the details view controller
        let albumDetailsViewController = AlbumDetailsViewController(albumListViewModel: albumListViewModel)
        self.navigationController?.pushViewController(albumDetailsViewController, animated: true)
    }
}

//Mark: TableView Prefetch Delegate
extension TopAlbumsViewController: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        albumListViewModel.prefetchRows(atIndexPaths: indexPaths)
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        albumListViewModel.cancelPrefetchForRows(atIndexPaths: indexPaths)
    }
}
