//
//  MenuView.swift
//  SushiOrder
//
//  Created by ПавелК on 01.02.2022.
//

import UIKit

class MenuView: UIView {
    
    var collectionView = UICollectionView(frame: CGRect(),collectionViewLayout: CompositionalLayoutManager().createCompositionalLayout())
    
    init() {
        super.init(frame: CGRect())
        setConsraints()
        collectionView.register(SushiCell.self, forCellWithReuseIdentifier: SushiCell.reuseId)
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.reuseId)
        self.backgroundColor = .white
        collectionView.backgroundColor = .white
    }
    
    private func setConsraints () {
        Helper.addSub(views: [collectionView], to: self)
        Helper.tamicOff(views: [collectionView])
        
        collectionView.topAnchor.constraint(equalTo: topAnchor,constant: 70).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 10).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -10).isActive = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
