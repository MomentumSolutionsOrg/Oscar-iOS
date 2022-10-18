//
//  RingView.swift
//  Expert
//
//  Created by Momentum Solutions Co. on 01/06/2021.
//  Copyright © 2021 Mostafa Samir. All rights reserved.
//

import UIKit

//class RingView: UIView {
//    
//    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        drawRingFittingInsideView()
//        self.layer.cornerRadius = self.frame.height / 2
//        self.clipsToBounds = true
//    }
//    
//    internal func drawRingFittingInsideView() -> () {
//        let halfSize:CGFloat = min( bounds.size.width/2, bounds.size.height/2)
//        let desiredLineWidth:CGFloat = 1.5 // your desired value
//            
//        let circlePath = UIBezierPath(
//                arcCenter: CGPoint(x:halfSize,y:halfSize),
//                radius: CGFloat( halfSize - (desiredLineWidth/2) ),
//                startAngle: CGFloat(0),
//            endAngle:CGFloat(Double.pi * 2),
//                clockwise: true)
//    
//         let shapeLayer = CAShapeLayer()
//        shapeLayer.path = circlePath.cgPath
//        shapeLayer.fillColor = UIColor.clear.cgColor
//        shapeLayer.strokeColor = UIColor.darkTextColor?.cgColor
//        shapeLayer.lineWidth = desiredLineWidth
//        layer.addSublayer(shapeLayer)
//     }
//}
