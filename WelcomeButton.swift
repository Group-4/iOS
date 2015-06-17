//
//  WelcomeButton.swift
//  PictureQ
//
//  Created by jpk on 6/17/15.
//  Copyright (c) 2015 Parker Kirby. All rights reserved.
//

import UIKit

@IBDesignable class WelcomeButton: UIButton {

    @IBInspectable var fillColor: UIColor = UIColor.blackColor()
    @IBInspectable var strokeColor: UIColor = UIColor.clearColor()
    @IBInspectable var cornerRadius: CGFloat = 10
    @IBInspectable var strokeWidth: CGFloat = 1
    
    override func drawRect(rect: CGRect) {
        
        var context = UIGraphicsGetCurrentContext()
        
        let insetRect = CGRectInset(rect, strokeWidth / 2, strokeWidth / 2)
        let path = UIBezierPath(roundedRect: insetRect, cornerRadius: cornerRadius)
        
        fillColor.set()
        CGContextAddPath(context, path.CGPath)
        CGContextFillPath(context)
        
        strokeColor.set()
        CGContextSetLineWidth(context, strokeWidth)
        CGContextAddPath(context, path.CGPath)
        CGContextStrokePath(context)
        
    }

}
