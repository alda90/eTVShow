//
//  ComposableSection.swift
//  eTVShow
//
//  Created by Aldair Carrillo on 26/12/22.
//

import UIKit
import Combine

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/// MARK:  This distribution is clearer to read than having an only file the
/// composablecollectionview. But also this could be better with a generics implementation.
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

public class ComposableSection: NSObject {
    
    public enum Section: String, CaseIterable {
        case grid = "TV Shows"
        case horizontal = "Tv Shows"
    }
    
    internal var collectionView: UICollectionView
    private var viewController: UIViewController
    internal var sectionType: Section
    
    internal static let sectionFooterElementKind = "section-footer-element-kind"
    
    internal var dataSource: UICollectionViewDiffableDataSource<Section, AnyHashable>?
    private var subscriptions = Set<AnyCancellable>()
    
    var output: ComposableSectionOutput = ComposableSectionOutput()
    
    public init(collectionView: UICollectionView, viewController: UIViewController, sectionType: Section) {
        self.collectionView = collectionView
        self.viewController = viewController
        self.sectionType = sectionType
        super.init()
    }
    
    func setupCollectionView() {
        collectionView.setCollectionViewLayout(generateLayout(), animated: false)
        collectionView.register(TVShowCell.self, forCellWithReuseIdentifier: TVShowCell.reuseIdentifier)
        collectionView.delegate = self
    }
    
    func bind() -> ComposableSectionOutput {
        return output
    }

    func updateSnapshot(tvShows: [TVShow]) {
        configureDataSource()
        let snapshot = snapshotForCurrentState(tvShows)
        if let dataSource = self.dataSource {
            dataSource.apply(snapshot, animatingDifferences: false)
        }
    }
    
}

