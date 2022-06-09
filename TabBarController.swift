//
//  TabBarController.swift
//  SushiOrder
//
//  Created by ПавелК on 07.02.2022.
//

import UIKit

final class TabBarController: UITabBarController {
    
    var userId : String
    
    init(userId : String) {
        self.userId = userId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createControllers()
    }
    
    private func createControllers () {
        var customUser = CustomUser(userName: "", imageUrl: "", id: "", phoneNumber: 0, adress: "")
        FirestoreService.shared.getProfile(userId: userId) { result in
            switch result {
            case .success(let user):
                customUser = user
                let cartVc = CartController()
                let profileVc = ProfileController(customUser: customUser)
                cartVc.delegate = profileVc
                
                self.viewControllers = [self.generateController(rootVc: MenuController(),
                                                                title: "Меню",
                                                                image: UIImage(systemName: "circles.hexagongrid.fill")!),
                                        self.generateController(rootVc: cartVc,
                                                                title: "Корзина",
                                                                image: UIImage(systemName: "cart.fill")!),
                                        self.generateController(rootVc: profileVc,
                                                                title: "Профиль",
                                                                image: UIImage(systemName: "person.crop.circle.fill")!)]
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        tabBar.tintColor = ColorsLibrary.darkGreen
        tabBar.backgroundColor = ColorsLibrary.lightGreen
    }
    
    private func generateController (rootVc : UIViewController,title : String, image : UIImage) -> UIViewController {
        let navVc = UINavigationController(rootViewController: rootVc)
        navVc.tabBarItem.image = image
        navVc.tabBarItem.title = title
        return navVc
    }
}
