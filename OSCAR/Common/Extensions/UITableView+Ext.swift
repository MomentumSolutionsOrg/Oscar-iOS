//
//  UITableView+Ext.swift
//  Expert
//
//  Created by Mostafa Samir on 30/05/2021.
//

import UIKit

extension UITableView {
    
    func registerCellNib<Cell: UITableViewCell>(cellClass: Cell.Type) {
        self.register(UINib(nibName: String(describing: Cell.self), bundle: nil), forCellReuseIdentifier: String(describing: Cell.self))
    }
    
    func dequeue<Cell: UITableViewCell>() -> Cell {
        let identifier = String(describing: Cell.self)
        guard let cell = self.dequeueReusableCell(withIdentifier: identifier) as? Cell else {
            fatalError("Error in cell")
        }
        
        return cell
    }
    
    func setEmptyView(title: String, message: String) {
        let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
        self.separatorStyle = .none
        let titleLabel = UILabel()
        let messageLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.textColor = UIColor(hexString: "#6D6E71")
        titleLabel.font = UIFont.systemFont(ofSize: 18,weight: .semibold)
        messageLabel.textColor = UIColor(hexString: "#6D6E71")
        messageLabel.font = UIFont.systemFont(ofSize: 14,weight: .regular)
        
        emptyView.addSubview(titleLabel)
        emptyView.addSubview(messageLabel)
        titleLabel.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: emptyView.leadingAnchor, constant: 16).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: emptyView.trailingAnchor, constant: -16).isActive = true
        
        messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        messageLabel.leftAnchor.constraint(equalTo: emptyView.leftAnchor, constant: 20).isActive = true
        messageLabel.rightAnchor.constraint(equalTo: emptyView.rightAnchor, constant: -20).isActive = true
        
        titleLabel.text = title
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        messageLabel.text = message
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        
        self.backgroundView = emptyView
    }
    
    
    func setEmptyView(with image:UIImage,width:CGFloat,height:CGFloat) {
        let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
        self.separatorStyle = .none
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        emptyView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor),
            imageView.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: height),
            imageView.widthAnchor.constraint(equalToConstant: width),
        ])
        self.backgroundView = emptyView
    }
    
    func restore() {
        self.backgroundView = nil
    }
    
    func reloadDataOnMainThread(){
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.reloadData()
        }
    }
    
    func setupGradient(with colors:[UIColor]) {
        let gradientLayer = CAGradientLayer()
        self.backgroundView = UIView(frame: self.frame)
        self.layer.borderWidth = 0
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.shouldRasterize = true
        gradientLayer.frame = self.frame
        self.backgroundView?.layer.addSublayer(gradientLayer)
        //self.sendSubviewToBack(self.layer)
    }
}
