//
//  CustomTabBar.swift
//  OSCAR
//
//  Created by Momentum Solutions Co. on 22/06/2021.
//

import UIKit

class CustomizedTabBar: UITabBar {

    private var shapeLayer: CALayer?

    private func addShape() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = createPathCircle()
        shapeLayer.fillColor = UIColor.white.cgColor

        if let oldShapeLayer = self.shapeLayer {
            self.layer.replaceSublayer(oldShapeLayer, with: shapeLayer)
        } else {
            self.layer.insertSublayer(shapeLayer, at: 0)
        }
        self.shapeLayer = shapeLayer
        self.layer.cornerRadius = 15
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 2
        self.layer.shadowOpacity = 0.16
        self.layer.masksToBounds = false
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
          var size = super.sizeThatFits(size)
          size.height += 10
          return size
     }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.addShape()
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
            guard !clipsToBounds && !isHidden && alpha > 0 else { return nil }
            for member in subviews.reversed() {
                let subPoint = member.convert(point, from: self)
                guard let result = member.hitTest(subPoint, with: event) else { continue }
                return result
            }
            return nil
        }

    func createPathCircle() -> CGPath {

        let radius: CGFloat = 37.0
        let path = UIBezierPath()
        let centerWidth = self.frame.width / 2

        
        path.addArc(withCenter: CGPoint(x: 15, y: 15), radius: 15, startAngle: -.pi, endAngle: .pi / 2, clockwise: true)
        path.move(to: CGPoint(x: 15, y: 0))
        path.addLine(to: CGPoint(x: (centerWidth - radius * 2), y: 0))
        path.addArc(withCenter: CGPoint(x: centerWidth, y: 0), radius: radius, startAngle: CGFloat(180).degreesToRadians, endAngle: CGFloat(0).degreesToRadians, clockwise: false)
        path.addLine(to: CGPoint(x: self.frame.width - 15, y: 0))
        path.addArc(withCenter: CGPoint(x: self.frame.width - 15, y: 15), radius: 15, startAngle: CGFloat(90).degreesToRadians, endAngle: CGFloat(0).degreesToRadians, clockwise: true)
        //path.addLine(to: CGPoint(x: self.frame.width, y: 15))
        path.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height))
        path.addLine(to: CGPoint(x: 0, y: self.frame.height))
        path.addLine(to: CGPoint(x: 0, y: 15))
        return path.cgPath
    }
}

extension CGFloat {
    var degreesToRadians: CGFloat { return self * .pi / 180 }
    var radiansToDegrees: CGFloat { return self * 180 / .pi }
}
