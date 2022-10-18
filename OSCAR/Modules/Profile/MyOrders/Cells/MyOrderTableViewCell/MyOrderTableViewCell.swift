//
//  MyOrderTableViewCell.swift
//  OSCAR
//
//  Created by Mostafa Samir on 04/08/2021.
//

import UIKit

class MyOrderTableViewCell: UITableViewCell {
    @IBOutlet weak var orderIdLabel: UILabel!
    @IBOutlet weak var verticalView: BorderView!
    @IBOutlet weak var orderDetailsView: BorderView!
    @IBOutlet weak var orderDateLabel: UILabel!
    @IBOutlet weak var orderStatusLabel: UILabel!
    
    var orderId = 0
    var orderStatus: Constants.OrderStatus = .checkingStatus {
        didSet {
            switch orderStatus {
            case .assigned:
                setStatusAssigned()
            case .preparing:
                setStatusPreparing()
            case .onTheWay:
                setStatusOnTheWay()
            case .completed:
                setStatusCompleted()
            case .pending:
                setStatusPending()
            case .checkingStatus:
                setStatusChecking()
            }
        }
    }

    func configureCell(with order: Order) {
        self.orderId = order.id ?? 0
        orderIdLabel.text = "#" + (order.id?.description ?? "")
        orderDateLabel.text = order.createdAt
        orderStatusLabel.text = order.orderStatus
        orderStatus = .checkingStatus
        updateStatus(for: order)
    }
    
    private func updateStatus(for order: Order) {
        
        OrderFireBaseHelper.shared.getOrder(for: order.logistaUserID ?? "Zhlh9jyNCtTmWh8MeKJwSB3QYBp2", with: order.logistaOrderID ?? "0") { [weak self] result in
            switch result {
            case .success(let logistaOrder):
                if order.id == self?.orderId {
                    self?.setStatus(for: logistaOrder.status ?? 0)
                }
                
            case .failure(let error):
                print(error)
                self?.orderStatus = .pending
            }
        }
        
    }
    
    private func setStatus(for status: Int) {
        switch status {
        case 0:
            orderStatus = .assigned
        case 1:
            orderStatus = .preparing
        case 3:
            orderStatus = .onTheWay
        case 4:
            orderStatus = .completed
        default:
            orderStatus = .pending
        }
    }
    
    private func setStatusChecking() {
        verticalView.backgroundColor = UIColor.buttonBackground
        orderDetailsView.backgroundColor = .white
        orderStatusLabel.text = "check_status".localized
    }
    
    private func setStatusPending() {
        verticalView.backgroundColor = UIColor.buttonBackground
        orderDetailsView.backgroundColor = .white
        orderStatusLabel.text = "pending".localized
    }
    
    private func setStatusAssigned() {
        verticalView.backgroundColor = UIColor.buttonBackground
        orderDetailsView.backgroundColor = .white
        orderStatusLabel.text = "assigned".localized
    }
    
    private func setStatusPreparing() {
        verticalView.backgroundColor = UIColor(hexString: "#FFC72E")
        orderDetailsView.backgroundColor = UIColor(hexString: "#FCE777").withAlphaComponent(0.5)
        orderStatusLabel.text = "preparing".localized
    }
    
    private func setStatusOnTheWay() {
        verticalView.backgroundColor = UIColor(hexString: "#01C6C6")
        orderDetailsView.backgroundColor = UIColor(hexString: "#77E2FC").withAlphaComponent(0.5)
        orderStatusLabel.text = "on_the_way".localized
    }
    
    private func setStatusCompleted() {
        verticalView.backgroundColor = UIColor(hexString: "#23B700")
        orderDetailsView.backgroundColor = UIColor(hexString: "#77FC81").withAlphaComponent(0.5)
        orderStatusLabel.text = "completed".localized
    }
}
