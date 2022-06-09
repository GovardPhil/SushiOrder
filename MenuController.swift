//
//  MenuController.swift
//  SushiOrder
//
//  Created by ПавелК on 01.02.2022.
//

import UIKit

final class MenuController: UIViewController {
    
    let menuView = MenuView()
    var classical = [Goods]()
    var burned = [Goods]()
    var maki = [Goods]()
    var sets = [Goods]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = menuView
        menuView.collectionView.dataSource = self
        menuView.collectionView.delegate = self
        getGoods()
    }
    
    private func getGoods () {
        FirestoreService.shared.getGoods { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let goods):
                for good in goods {
                    switch good.category {
                    case "Классические" :
                        self.classical.append(good)
                    case "Запеченные" :
                        self.burned.append(good)
                    case "Маки" :
                        self.maki.append(good)
                    case "Сеты" :
                        self.sets.append(good)
                    default : break
                    }
                }
                self.menuView.collectionView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

// MARK: - MenuController Extension : CollectionView

extension MenuController : UICollectionViewDataSource,UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0 : return classical.count
        case 1 : return burned.count
        case 2 : return sets.count
        case 3 : return maki.count
        default : return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SushiCell.reuseId, for: indexPath) as! SushiCell
        cell.backgroundColor = .white
        cell.layer.cornerRadius = 8
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOpacity = 0.3
        cell.layer.shadowRadius = 4
        var rolls = [Goods]()
        
        switch indexPath.section {
        case 0 : rolls = classical
        case 1 : rolls = burned
        case 2 : rolls = maki
        default : rolls = sets
        }
        let roll = rolls[indexPath.item]
        cell.titleLabel.text = roll.title
        cell.priceLabel.text = "\(roll.price) р."
        StorageService.shared.downloadGoodsPic(title: roll.imageTitle) { result in
            switch result {
                
            case .success(let data ):
                cell.imageView.image = UIImage(data: data)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = DetailController()
        
        switch indexPath.section {
        case 0 : vc.goods = classical[indexPath.item]
        case 1 : vc.goods = burned[indexPath.item]
        case 2 : vc.goods = maki[indexPath.item]
        default : vc.goods = sets[indexPath.item]
        }
        guard let tabBarController = tabBarController else { return }
        guard let controllers = tabBarController.viewControllers else { return }
        vc.delegate = (controllers[1] as? UINavigationController)?.visibleViewController as? CartController
        self.present(vc, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.reuseId, for: indexPath) as! HeaderView
        var title : String?
        switch indexPath.section {
        case 0 : title = classical.count > 0 ? Category.classical.rawValue : nil
        case 1 : title = burned.count > 0 ? Category.burned.rawValue : nil
        case 2 : title = maki.count > 0 ? Category.maki.rawValue : nil
        default : title = sets.count > 0 ? Category.sets.rawValue : nil
        }
        header.titleLabel.text = title
        return header
    }
}
