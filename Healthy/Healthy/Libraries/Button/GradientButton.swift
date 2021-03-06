//
//  GradientButton.swift
//  PtitMe
//
//  Created by kienpt on 02/18/19.
//  Copyright © 2019 Mobileteam. All rights reserved.
//

import UIKit

@IBDesignable class GradientButton: UIButton {
    
    // MARK: - Inspectable
    @IBInspectable var borderWidth: CGFloat = 0.0
    @IBInspectable var borderColor: UIColor = .clear
    @IBInspectable var cornerRadius: CGFloat = 0.0
    @IBInspectable var startColor: UIColor = .white
    @IBInspectable var endColor: UIColor = .white
    @IBInspectable var direction: Int = 0
    
    @IBInspectable var cornerTopLeft: Bool = true
    @IBInspectable var cornerTopRight: Bool = true
    @IBInspectable var cornerBottomLeft: Bool = true
    @IBInspectable var cornerBottomRight: Bool = true
    
    @IBInspectable var spacing: CGFloat = 0.0
    
    // MARK: - Setup
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
    }
    
    // MARK: - Drawing
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        // Refresh clipping & masking
        clipsToBounds = true
        layer.masksToBounds = true
        
        // Remove last gradient layer
        if let removeLayer = layer.sublayers?.filter({ $0 is GradientLayer }).first {
            removeLayer.removeFromSuperlayer()
        }
        
        // Add new gradient layer
        let gradientLayer = GradientLayer(startColor: startColor,
                                          endColor: endColor,
                                          direction: GradientDirection(rawValue: direction) ?? .leftToRight)
        gradientLayer.frame = bounds
        
        // Create rounded path and shape layer for it
        var cornerList = UIRectCorner()
        if cornerTopLeft { cornerList.insert(.topLeft) }
        if cornerTopRight { cornerList.insert(.topRight) }
        if cornerBottomLeft { cornerList.insert(.bottomLeft) }
        if cornerBottomRight { cornerList.insert(.bottomRight) }
        let roundedRect = borderColor == .clear ? bounds : CGRect(x: borderWidth / 2, y: borderWidth / 2, width: rect.width - borderWidth, height: rect.height - borderWidth)
        let roundPath = UIBezierPath(roundedRect: roundedRect, byRoundingCorners: cornerList, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        if !cornerTopLeft {
            roundPath.move(to: CGPoint(x: 0, y: borderWidth / 2))
            roundPath.addLine(to: CGPoint(x: borderWidth / 2, y: borderWidth / 2))
        }
        
        roundPath.lineWidth = borderWidth
        borderColor.setStroke()
        roundPath.stroke()
        
        let insetAmount = spacing / 2
        imageEdgeInsets = UIEdgeInsets(top: 0, left: -insetAmount, bottom: 0, right: insetAmount)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: -insetAmount)
        contentEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: insetAmount)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = gradientLayer.bounds
        shapeLayer.path = roundPath.cgPath
        gradientLayer.mask = shapeLayer
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    // MARK: - Builder
    func set(buttonBorderColor: UIColor, gradientStart: UIColor, gradientEnd: UIColor, gradientDirection: GradientDirection, cornerTopLeft: Bool, cornerTopRight: Bool, cornerBottomLeft: Bool, cornerBottomRight: Bool, spacing: CGFloat) {
        borderColor = buttonBorderColor
        startColor = gradientStart
        endColor = gradientEnd
        direction = gradientDirection.value
        self.cornerTopLeft = cornerTopLeft
        self.cornerTopRight = cornerTopRight
        self.cornerBottomLeft = cornerBottomLeft
        self.cornerBottomRight = cornerBottomRight
        self.spacing = spacing
        setNeedsDisplay()
    }
    
    func setCornerRadius(_ value: CGFloat) {
        cornerRadius = value
        setNeedsDisplay()
    }
    
    func centerTextAndImage(spacing: CGFloat) {
        
        let insetAmount = spacing / 2
        imageEdgeInsets = UIEdgeInsets(top: 0, left: -insetAmount, bottom: 0, right: insetAmount)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: -insetAmount)
        contentEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: insetAmount)
        setNeedsDisplay()
    }
}
