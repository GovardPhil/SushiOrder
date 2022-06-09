//
//  ProfileView.swift
//  SushiOrder
//
//  Created by ПавелК on 08.02.2022.
//

import UIKit

class ProfileView: UIView {
    
    let avatar = UIImageView()
    let nameTextField = UITextField(placeholder: "")
    let adressTitleLabel = UILabel(text: "Адрес доставки:", font: FontsLibrary.smallButton)
    let adressLabel = UILabel(text: "Улица Большая Магистральная,д3,кв 6", font: FontsLibrary.smallButton)
    let changeAdressButton = UIButton(title: "Изменить адрес", bgColor: ColorsLibrary.darkGreen, textColor: .white, font: FontsLibrary.fieldButton)
    let phoneLabel = UILabel(text: "+79999999999", font: FontsLibrary.smallButton)
    let changePhone = UIButton(title: "Изменить", bgColor: ColorsLibrary.redButton, textColor: .white, font: FontsLibrary.fieldButton)
    let tableView = UITableView()
    let quitButton = UIButton(title: "Выйти", bgColor: ColorsLibrary.redButton, textColor: .white, font: FontsLibrary.fieldButton)
    
    
    
    
    
    init() {
        super.init(frame: CGRect())
        setViews()
        setConstraints()
    }
    
    
    func setViews() {
        backgroundColor = .white
        avatar.backgroundColor = .systemBlue
        avatar.layer.cornerRadius = 55
        avatar.clipsToBounds = true
        nameTextField.text = ""
        nameTextField.borderStyle = .none
        nameTextField.layer.shadowOpacity = 0
        tableView.register(OrderProfileCell.self, forCellReuseIdentifier: OrderProfileCell.reuseId)
        tableView.separatorStyle = .none
        avatar.isUserInteractionEnabled = true
    }
    func setConstraints () {
        
        let topStack = UIStackView(views: [avatar,nameTextField], axis: .horizontal, spacing: 36)
        let phoneStack = UIStackView(views: [phoneLabel,changePhone], axis: .horizontal, spacing: 36)
        
        let stack = UIStackView(views: [topStack,adressTitleLabel,adressLabel,changeAdressButton,phoneStack,tableView,quitButton], axis: .vertical, spacing: 12)
        for view in stack.arrangedSubviews where view is UILabel {
            (view as! UILabel).textColor = ColorsLibrary.darkGreen
            
            Helper.tamicOff(views: [stack,topStack,adressTitleLabel,adressLabel,changeAdressButton,phoneStack,tableView,quitButton,avatar,nameTextField,phoneLabel,changePhone])
            addSubview(stack)
            
            stack.topAnchor.constraint(equalTo: topAnchor, constant: 64).isActive = true
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
            stack.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -100).isActive = true
            
            avatar.heightAnchor.constraint(equalToConstant: 110).isActive = true
            avatar.widthAnchor.constraint(equalToConstant: 110).isActive = true
            
            changeAdressButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
            changePhone.heightAnchor.constraint(equalToConstant: 40).isActive = true
            quitButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
            changePhone.widthAnchor.constraint(equalToConstant: 160).isActive = true
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
