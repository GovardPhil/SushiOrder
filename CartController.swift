//
//  CartController.swift
//  SushiOrder
//
//  Created by ПавелК on 07.02.2022.
//

import UIKit

// MARK: Protocol CartDelegate
protocol CartDelegate {
    func addToCart (position : inout Position) -> Void
}

final class CartController: UIViewController {
    
    let cartView = CartView()
    var positions = [Position]()
    var delegate : ProfileDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = cartView
        cartView.tableView.dataSource = self
        cartView.tableView.delegate = self
        updateViews()
        addTargets()
    }
    
    private func updateViews () {
        var sum = 0
        for position in positions {
            sum += (position.count * position.price)
        }
        cartView.sumLabel.text = "\(sum) р."
        cartView.tableView.reloadData()
    }
    
    @objc func sendOrder () {
        let order = Order(positions: self.positions, clientId:AuthService.shared.currentUser!.uid)
        FirestoreService.shared.send(order: order) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let order) :
                print ("Ваш заказ от \(order.date) был принят")
                self.positions.removeAll()
                self.updateViews()
                self.delegate?.updateTableView()
            case .failure(let error) :
                print(error.localizedDescription)
            }
        }
    }
    private func addTargets () {
        cartView.clearButton.addTarget(self, action: #selector(clearCart), for: .touchUpInside)
        cartView.orderButton.addTarget(self, action: #selector(sendOrder), for: .touchUpInside)
    }
    
    @objc func clearCart () {
        positions.removeAll()
        updateViews()
    }
}



// MARK: - Extension CartController : UITableView

extension CartController : UITableViewDataSource, UITableViewDelegate, CartDelegate {
    
    func addToCart(position: inout Position) {
        for (index,pos) in positions.enumerated() {
            if pos.title == position.title {
                position.count += pos.count
                positions.remove(at: index)
            }
        }
        self.positions.append(position)
        updateViews()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return positions.count
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Удалить") { _, _, _ in
            self.positions.remove(at: indexPath.row)
            self.updateViews()
        }
        let config = UISwipeActionsConfiguration(actions: [deleteAction])
        return config
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PositionCell.reuseId) as! PositionCell
        let position = positions[indexPath.row]
        cell.titleLabel.text = position.title
        cell.countlabel.text = "\(position.count) шт."
        cell.priceLabel.text = "\(position.count * position.price) руб."
        return cell
    }
}
