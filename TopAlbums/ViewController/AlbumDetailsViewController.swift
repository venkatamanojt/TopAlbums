//
//  AlbumDetailsViewController.swift
//  TopAlbums
//
//  Created by Venkata Manoj Tunuguntla on 1/11/20.
//  Copyright © 2020 Venkata Manoj Tunuguntla. All rights reserved.
//

import UIKit

/// Album Details View Controller class
class AlbumDetailsViewController: UIViewController {
    
    private var albumDetailViewModel: AlbumDetailViewModel = AlbumDetailViewModel()
    
    private let selectedAlbumNameLabel:UILabel = {
        let albumNameLabel = UILabel()
        albumNameLabel.translatesAutoresizingMaskIntoConstraints = false
        albumNameLabel.adjustsFontForContentSizeCategory = true
        albumNameLabel.numberOfLines = 0
        albumNameLabel.font = UIFont.preferredFont(forTextStyle: .title1)
        albumNameLabel.lineBreakMode = .byWordWrapping
        albumNameLabel.textColor = .black
        albumNameLabel.isAccessibilityElement = true
        albumNameLabel.textAlignment = .center
        return albumNameLabel
    }()
    
    private let selectedArtistNameLabel:UILabel = {
        let artistNameLabel = UILabel()
        artistNameLabel.translatesAutoresizingMaskIntoConstraints = false
        artistNameLabel.adjustsFontForContentSizeCategory = true
        artistNameLabel.font = UIFont.preferredFont(forTextStyle: .body)
        artistNameLabel.numberOfLines = 0
        artistNameLabel.textColor = .black
        artistNameLabel.textAlignment = .center
        artistNameLabel.isAccessibilityElement = true
        return artistNameLabel
    }()
    
    private let genreLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.numberOfLines = 0
        label.textColor = .black
        label.textAlignment = .center
        label.isAccessibilityElement = true
        return label
    }()
    
    private let artImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.isAccessibilityElement = false
        return imageView
    }()
    
    private let releaseDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.textColor = .black
        label.textAlignment = .center
        label.isAccessibilityElement = true
        return label
    }()
    
    private let copyRightInfoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: .caption2)
        label.textColor = .black
        label.textAlignment = .center
        label.isAccessibilityElement = true
        return label
    }()
    
    private var navigateToMusicButton: UIButton = {
        let iTunesButton = UIButton()
        iTunesButton.backgroundColor = UIColor.red
        iTunesButton.setTitle(Constants.navigateToMusic, for: .normal)
        iTunesButton.isAccessibilityElement = true
        return iTunesButton
    }()
    
    /// Convenience initalizer
    /// - Parameter albumListViewModel: album List View Model
    convenience init(albumListViewModel:AlbumListViewModel) {
        self.init()
        self.albumDetailViewModel.albumListViewModel = albumListViewModel
    }
    
    
    /// Parent StackView to manage the view w.r.t the landscape & portrait orientations
    private lazy var detailParentStackView:UIStackView = {
        let stackView = UIStackView(frame: self.view.bounds)
        updateStackView(stackView, traitCollection: view.traitCollection)
        stackView.alignment = .fill
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    /// Child stack view to hold all the album details information labels & navigation button.
    private lazy var detailChildStackView:UIStackView = {
        let stackView = UIStackView(frame: self.view.bounds)
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override func loadView() {
        super.loadView()
        self.initializeView()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    private func initializeView() {
        self.view.backgroundColor = .white
        self.title = albumDetailViewModel.albumName
        initializeDetailsView()
    }
    
    /// Initialize the details View
    private func initializeDetailsView() {
        let inset = CGFloat(10)
        let musicButtonInset = CGFloat(20)
        
        //Fetch the information from the view model & add it to the stackView
        artImageView.image = albumDetailViewModel.artImage
        detailParentStackView.addArrangedSubview(artImageView)
        
        selectedAlbumNameLabel.text = albumDetailViewModel.albumName
        selectedAlbumNameLabel.accessibilityLabel = albumDetailViewModel.albumNameAccessibilityLabel
        detailChildStackView.addArrangedSubview(selectedAlbumNameLabel)
        
        selectedArtistNameLabel.text =  albumDetailViewModel.artistName
        selectedArtistNameLabel.accessibilityLabel = albumDetailViewModel.artistNameAccessibilityLabel
        detailChildStackView.addArrangedSubview(selectedArtistNameLabel)
        
        genreLabel.text = albumDetailViewModel.selectedAlbumGenres
        detailChildStackView.addArrangedSubview(genreLabel)
        
        releaseDateLabel.text = albumDetailViewModel.releaseDate
        detailChildStackView.addArrangedSubview(releaseDateLabel)
        
        copyRightInfoLabel.text = albumDetailViewModel.copyRightInfo
        detailChildStackView.addArrangedSubview(copyRightInfoLabel)
        
        navigateToMusicButton.addTarget(self, action: #selector(navigateToiTunesAction), for: .touchUpInside)
        //Add the UI Elements to the child & parent stackViews.
        detailChildStackView.addArrangedSubview(navigateToMusicButton)
        detailParentStackView.addArrangedSubview(detailChildStackView)
        
        self.view.addSubview(detailParentStackView)
        //set up the constraints for the Parent StackView & naviate to music button
        NSLayoutConstraint.activate([
            detailParentStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: inset),
            detailParentStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -inset),
            detailParentStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            detailParentStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -musicButtonInset),
            navigateToMusicButton.leadingAnchor.constraint(equalTo: detailChildStackView.leadingAnchor, constant: musicButtonInset),
            navigateToMusicButton.trailingAnchor.constraint(equalTo: detailChildStackView.trailingAnchor, constant: -musicButtonInset)
        ])
    }
    
    /// To Navigate to Music App
    /// - Parameter sender: Music Button
    @objc func navigateToiTunesAction(sender: UIButton!) {
        
        if let url = URL(string: albumDetailViewModel.musicURL) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    /// When the device orientation changes
    /// - Parameter previousTraitCollection: Trait Collection
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        self.updateStackView(detailParentStackView, traitCollection: view.traitCollection)
        detailParentStackView.layoutIfNeeded()
    }
    
    /// To update the stackview orientation based on the trait collection state
    /// - Parameters:
    ///   - stackView: Stack View to update
    ///   - traitCollection: Trait Collection
    private func updateStackView(_ stackView:UIStackView, traitCollection: UITraitCollection) {
        //Of the orientation is landscape, toggle the stackview axis to Horizontal, otherwise keep it vertical
        if traitCollection.verticalSizeClass == .compact {
            stackView.axis = .horizontal
            stackView.distribution = .fillEqually
            
        } else {
            stackView.axis = .vertical
            stackView.distribution = .fillProportionally
        }
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

