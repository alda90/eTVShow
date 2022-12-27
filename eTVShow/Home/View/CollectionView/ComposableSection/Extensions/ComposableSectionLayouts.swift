//
//  ComposableSectionLayouts.swift
//  eTVShow
//
//  Created by Aldair Carrillo on 26/12/22.
//

import UIKit

// MARK: Layout Sections
internal extension ComposableSection {
    
    func generateLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [self] (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let isWideView = layoutEnvironment.container.effectiveContentSize.width > 375
            
            let sectionLayoutKind = sectionType
            switch (sectionLayoutKind) {
            case .horizontal: return self.generateHorizontalLayout(isWide: isWideView)
            case .grid: return self.generateGridLayout(isWide: isWideView)
            }
        }
        
        return layout
    }
    
    
    func generateHorizontalLayout(isWide: Bool) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupFractionalWidth = 0.475
        let groupHeight = NSCollectionLayoutDimension.fractionalWidth(isWide ? 0.75 : 0.95)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(CGFloat(groupFractionalWidth)),
            heightDimension: groupHeight)
        if #available(iOS 16.0, *) {
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 1)
            group.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .groupPaging
            
            return section
        } else {
            // Fallback on earlier versions
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
            
            group.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .groupPaging
            
            return section
        }
        
    }
    
    
    func generateGridLayout(isWide: Bool) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 3, leading: 4, bottom: 3, trailing: 4)
        
        let groupFractionalWidth = isWide ? 0.5 : 0.95
        let groupHeight = NSCollectionLayoutDimension.fractionalWidth(0.95)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(CGFloat(groupFractionalWidth)),
            heightDimension: groupHeight)
        if #available(iOS 16.0, *) {
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 2)
            group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 0)
            
            let section = NSCollectionLayoutSection(group: group)
            
            return section
        } else {
            // Fallback on earlier versions
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
            group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 0)
            
            let section = NSCollectionLayoutSection(group: group)
            
            return section
        }
        
    }
    
}
