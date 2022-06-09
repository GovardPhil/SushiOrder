//
//  HeaderView.swift
//  SushiOrder
//
//  Created by ПавелК on 03.02.2022.
//

import UIKit

final class HeaderView: UICollectionReusableView {
    
    static let reuseId = "HeaderView"
    let titleLabel = UILabel(text: "Название секции", font: FontsLibrary.smallTitle)
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        setConstraints()
    }
    
    private func setConstraints () {
        Helper.addSub(views: [titleLabel], to: self)
        Helper.tamicOff(views: [titleLabel])
        
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
