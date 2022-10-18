//
//  UICollectionView+Ext.swift
//  Expert
//
//  Created by Mostafa Samir on 30/05/2021.
//

import UIKit

extension UICollectionView {
        
    func registerCellNib<Cell: UICollectionViewCell>(cellClass: Cell.Type) {
        self.register(UINib(nibName: String(describing: Cell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: Cell.self))
    }

    func dequeue<Cell: UICollectionViewCell>(indexPath: IndexPath) -> Cell{
        let identifier = String(describing: Cell.self)
        
        guard let cell = self.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? Cell else {
            fatalError("Error in cell")
        }
        return cell
    }
    
    func setEmptyView(title: String, message: String,alignment:NSTextAlignment = .center) {
        let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
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
        messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        messageLabel.leftAnchor.constraint(equalTo: emptyView.leftAnchor, constant: 20).isActive = true
        messageLabel.rightAnchor.constraint(equalTo: emptyView.rightAnchor, constant: -20).isActive = true
        titleLabel.text = title
        messageLabel.text = message
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = alignment
        
//        if LanguageManager.shared.isArabicLanguage() {
//
//        }
       
        self.backgroundView = emptyView
    }
    func setEmptyView(with image:UIImage,width:CGFloat,height:CGFloat) {
        let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
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
    
    func setEmptyView(message: String,alignment:NSTextAlignment = .center) {
        let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
        let messageLabel = UILabel()
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.textColor = UIColor(hexString: "#9E9E9E")
        messageLabel.font = UIFont.systemFont(ofSize: 16,weight: .regular)
        emptyView.addSubview(messageLabel)
        messageLabel.leadingAnchor.constraint(equalTo: emptyView.leadingAnchor,constant: 12).isActive = true
        messageLabel.trailingAnchor.constraint(equalTo: emptyView.trailingAnchor,constant: -12).isActive = true
        messageLabel.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor).isActive = true
        messageLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        messageLabel.text = message
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = alignment
        if LanguageManager.shared.isArabicLanguage() {
            messageLabel.semanticContentAttribute = .forceRightToLeft
        }else {
            messageLabel.semanticContentAttribute = .forceLeftToRight
            messageLabel.transform = .identity
        }
        
        self.backgroundView = emptyView
    }
    
    func restore() {
        self.backgroundView = nil
    }
    
    func reloadDataOnMainThread(){
        DispatchQueue.main.async {
            self.reloadData()
        }
    }
}
