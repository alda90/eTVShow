//
//  ComposableSectionDelegate.swift
//  eTVShow
//
//  Created by Aldair Carrillo on 26/12/22.
//

import UIKit

extension ComposableSection: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let source = dataSource,
              let item = source.itemIdentifier(for: indexPath),
              let movie = item as? TVShow else { return }
        
        output.callToAction.send(movie)
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
    }
}
