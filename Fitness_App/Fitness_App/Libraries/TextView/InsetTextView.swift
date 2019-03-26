//
//  InsetTextView.swift
//  PtitMe
//
//  Created by kienpt on 02/18/19.
//  Copyright © 2019 Mobileteam. All rights reserved.
//

import UIKit

@IBDesignable class InsetTextView: UITextView {
    
    @IBInspectable var insetTop: CGFloat = 14
    @IBInspectable var insetLeft: CGFloat = 10
    @IBInspectable var insetBottom: CGFloat = 0
    @IBInspectable var insetRight: CGFloat = 10
    
    private var insets: UIEdgeInsets {
        return UIEdgeInsets(top: insetTop, left: insetLeft, bottom: insetBottom, right: insetRight)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.clipsToBounds = true
        textContainerInset = insets
    }
    
    override func draw(_ rect: CGRect) {
        textContainerInset = insets
        super.draw(rect.inset(by: insets))
    }

    override func firstRect(for range: UITextRange) -> CGRect {
        return bounds.inset(by: insets)
    }
    
    override func alignmentRect(forFrame frame: CGRect) -> CGRect {
        return bounds.inset(by: insets)
    }
}
