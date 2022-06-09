//
//  DetailController.swift
//  SushiOrder
//
//  Created by ПавелК on 03.02.2022.
//

import UIKit

final class DetailController: UIViewController {
    
    let detailview = DetailView()
    var goods = Goods(id: "", title: "", price: 0, description: "", imageTitle: "", category: "")
    var delegate : CartDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = detailview
        configViews()
        addTargets()
        downloadPic()
    }
    
    private func addTargets () {
        detailview.addToCartButton.addTarget(self, action: #selector(showAddToCartAlert), for: .touchUpInside)
    }
    private func downloadPic () {
        StorageService.shared.downloadGoodsPic(title: goods.imageTitle) { [weak self] result in
            guard let self = self else { return }
            switch result {
                
            case .success(let data):
                guard let image = UIImage(data: data) else { return }
                self.detailview.imageView.image = image
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    @objc func showAddToCartAlert () {
        
        let alert = UIAlertController(title: "Введите количество:", message: nil, preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "Количество"
            textField.keyboardType = .numberPad
        }
        let addToCartButton = UIAlertAction(title: "Добавить", style: .default) { _ in
            
            guard let countText = alert.textFields![0].text else {
                return
            }
            guard let count = Int(countText) else {return}
            var position = Position(title: self.goods.title, price: self.goods.price, count: count)
            self.delegate?.addToCart(position: &position)
            self.dismiss(animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .destructive, handler: nil)
        alert.addAction(addToCartButton)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func configViews () {
        detailview.titleLabel.text = goods.title
        detailview.priceLabel.text = "\(goods.price) руб."
        detailview.descryptionTextView.text = goods.description
        detailview.imageView.image = UIImage(named: goods.imageTitle)
    }
}
