//
//  AlbumTableViewCell.swift
//  TopAlbums
//
//  Created by Venkata Manoj Tunuguntla on 1/12/20.
//  Copyright © 2020 Venkata Manoj Tunuguntla. All rights reserved.
//

import UIKit

/// Album Table View Cell
class AlbumTableViewCell: UITableViewCell {
    
    let artImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let albumNameLabel:UILabel = {
        
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.textColor = .black
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let artistNameLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.numberOfLines = 0
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var albumStackView:UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var infoStackView:UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .top
        stackView.distribution = .fillProportionally
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    private func configure() {
        let inset = CGFloat(10)
        //Add items to the stackview
        infoStackView.addArrangedSubview(albumNameLabel)
        infoStackView.addArrangedSubview(artistNameLabel)

        albumStackView.addArrangedSubview(artImageView)
        albumStackView.addArrangedSubview(infoStackView)
        
        self.contentView.addSubview(albumStackView)
        
        NSLayoutConstraint.activate([
            albumStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            albumStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
            albumStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: inset),
            albumStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -inset)
        ])
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
