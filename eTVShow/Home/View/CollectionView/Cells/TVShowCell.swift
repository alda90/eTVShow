//
//  TVShowCell.swift
//  eTVShow
//
//  Created by Aldair Carrillo on 26/12/22.
//

import Foundation
import UIKit
import SDWebImage

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/// MARK: The cache has some conflicts, it has to be fixed. And I has to be improved
/// with local storage like Realm or CoreData
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class TVShowCell: UICollectionViewCell {
    static let reuseIdentifier = "tvShowCell"
    private let cache = NSCache<NSString, UIImage>()
    
    private lazy var posterImage: UIImageView = {
        let image  = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleToFill
        image.clipsToBounds = false
        return image
    }()
    
    private lazy var lblTitle: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = UIColor(named: "principal")
        lbl.font = UIFont.boldSystemFont(ofSize: 16.0)
        lbl.numberOfLines = 1
        lbl.lineBreakMode = .byTruncatingTail
        return lbl
    }()
    
    private lazy var lblReleaseDate: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = UIColor(named: "principal")
        lbl.font = UIFont.boldSystemFont(ofSize: 12.0)
        lbl.numberOfLines = 1
        return lbl
    }()
    
    private lazy var lblRating: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = UIColor(named: "principal")
        lbl.font = UIFont.boldSystemFont(ofSize: 12.0)
        lbl.numberOfLines = 1
        lbl.textAlignment = .right
        return lbl
    }()
    
    private lazy var lblOverview: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .white
        lbl.font = UIFont.boldSystemFont(ofSize: 10.0)
        lbl.numberOfLines = 4
        lbl.lineBreakMode = .byTruncatingTail
        return lbl
    }()
    
    private var id: String?

    var posterPathURL: URL? {
        didSet {
            setupImage()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(tvShow: TVShow) {
        id = String(describing: tvShow.id)
        posterPathURL = tvShow.posterPathURL()
        lblTitle.text = tvShow.originalName ?? ""
        let star = "\u{2606}"
        lblRating.text = "\(star) \(String(describing: tvShow.voteAverage ?? 0.0))"
        lblOverview.text = tvShow.overview
        
        if let firstAirDate = tvShow.firstAirDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            let newDateFormatter = DateFormatter()
            newDateFormatter.dateFormat = "MMM d, yyyy"
            
            lblReleaseDate.text = newDateFormatter.string(from: dateFormatter.date(from: firstAirDate ) ?? Date())
        }
    }
}

private extension TVShowCell {
    func setupView() {
        contentView.addSubview(posterImage)
        contentView.addSubview(lblTitle)
        contentView.addSubview(lblReleaseDate)
        contentView.addSubview(lblRating)
        contentView.addSubview(lblOverview)
        
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true
        contentView.backgroundColor = UIColor(named: "backgroundSplash")
        
        let viewHeight = self.bounds.height

        NSLayoutConstraint.activate([
            posterImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            posterImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            posterImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            posterImage.heightAnchor.constraint(equalToConstant: viewHeight - (viewHeight / 3)),
            
            lblTitle.topAnchor.constraint(equalTo: posterImage.bottomAnchor, constant: 8),
            lblTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            lblTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            lblTitle.heightAnchor.constraint(equalToConstant: 25),
            
            lblReleaseDate.topAnchor.constraint(equalTo: lblTitle.bottomAnchor, constant: 8),
            lblReleaseDate.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            lblReleaseDate.trailingAnchor.constraint(equalTo: lblRating.leadingAnchor, constant: 4),
            lblReleaseDate.heightAnchor.constraint(equalToConstant: 15),
            
            lblRating.topAnchor.constraint(equalTo: lblTitle.bottomAnchor, constant: 8),
            lblRating.leadingAnchor.constraint(equalTo: lblReleaseDate.trailingAnchor, constant: 4),
            lblRating.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            lblRating.widthAnchor.constraint(equalToConstant: 50),
            lblRating.heightAnchor.constraint(equalToConstant: 15),
            
            lblOverview.topAnchor.constraint(equalTo: lblReleaseDate.bottomAnchor, constant: 8),
            lblOverview.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            lblOverview.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            lblOverview.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    func setupImage() {
        if let cacheImage = cache.object(forKey: NSString(string: id ?? "image")) {
            posterImage.image = cacheImage
        } else {
            if let url = posterPathURL {
                posterImage.sd_setImage(with: url) { [weak self] image, error, _, _ in
                    guard let self = self else { return }
                    if let image = image {
                        self.posterImage.image = image
                        self.cache.setObject(image, forKey: NSString(string: self.id ?? "image"))
                    }
                }
            }
        }
    }
}
