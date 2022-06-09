//
//  DetailView.swift
//  SushiOrder
//
//  Created by ПавелК on 03.02.2022.
//

import UIKit

final class DetailView: UIView {
    
    let imageView = UIImageView(image: UIImage(named: "sushi"))
    let titleLabel = UILabel(text: "Название продукта", font: FontsLibrary.smallTitle)
    let priceLabel = UILabel(text: "3500 р", font: FontsLibrary.fieldButton)
    let descryptionTextView = UITextView()
    let addToCartButton = UIButton(title: "В корзину", bgColor: ColorsLibrary.redButton, textColor: .white, font: FontsLibrary.fieldButton)
    
    
    init() {
        super.init(frame: CGRect())
        setViews()
        setConstraints()
        self.backgroundColor = .white
    }
    
    
    private func setViews () {
        descryptionTextView.text = ""
        descryptionTextView.font = FontsLibrary.cellText
        descryptionTextView.isEditable = false
        
    }
    private func setConstraints () {
        let stack = UIStackView(views: [titleLabel,priceLabel,descryptionTextView,addToCartButton], axis: .vertical, spacing: 12)
        Helper.addSub(views: [stack,imageView], to: self)
        Helper.tamicOff(views: [stack,imageView])
        
        imageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageView.heightAnchor.constraint(equalTo : widthAnchor,multiplier: 0.75).isActive = true
        
        
        stack.topAnchor.constraint(equalTo: imageView.bottomAnchor,constant: 12).isActive = true
        stack.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 20).isActive = true
        stack.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -20).isActive = true
        
        descryptionTextView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        addToCartButton.heightAnchor.constraint(equalToConstant: 40).isActive = true

    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
