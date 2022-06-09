//
//  CompositionalLayoutManager.swift
//  SushiOrder
//
//  Created by ПавелК on 01.02.2022.
//

import UIKit

final class CompositionalLayoutManager {
    
   private enum Section : Int, CaseIterable {
        case classic, burned, maki, sets
    }
    
    func createCompositionalLayout () -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            guard let _ = Section(rawValue: sectionIndex) else {
                fatalError("Не удалось создать секцию")
            }
            return self.createSection()
        }
        return layout
    }
   private func createSection () -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.47), heightDimension: .fractionalHeight(0.95))
        let item = NSCollectionLayoutItem.init(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.5))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        let spacing : CGFloat = 12
        group.interItemSpacing = .fixed(spacing)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        section.boundarySupplementaryItems = [createHeader()]
        return section
    }
    
  private func createHeader () -> NSCollectionLayoutBoundarySupplementaryItem {
        let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(80))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: size, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        header.zIndex = 2
        return header
    }
}




