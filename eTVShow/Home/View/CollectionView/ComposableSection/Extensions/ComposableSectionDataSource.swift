//
//  ComposableSectionDataSource.swift
//  eTVShow
//
//  Created by Aldair Carrillo on 26/12/22.
//

import UIKit

// MARK: DataSource
internal extension ComposableSection {

    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource
        <Section, AnyHashable>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, movieItem: AnyHashable) -> UICollectionViewCell? in
                
            let sectionType = self.sectionType
            switch sectionType {
            case .grid, .horizontal:
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: TVShowCell.reuseIdentifier,
                    for: indexPath) as? TVShowCell else { fatalError("Could not create new cell") }
                let item = movieItem as! TVShow
                cell.configure(tvShow: item)
                return cell
            }
        }
        
    }
        
    func snapshotForCurrentState(_ tvShows: [TVShow]) -> NSDiffableDataSourceSnapshot<Section, AnyHashable> {
            
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
        snapshot.appendSections([sectionType])
        snapshot.appendItems(tvShows)
            
        return snapshot
    }
    
}
