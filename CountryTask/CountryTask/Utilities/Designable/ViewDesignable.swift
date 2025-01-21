//
//  ViewDesignable.swift
//  Jibley Customer App
//
//  Created by Es .
//  Copyright © 2018 Es. All rights reserved.
//

import UIKit

//  @IBDesignable

class ViewDesignable: UIView {
    
    
    @IBInspectable var cornerRadius: Float = 6.0 {
        didSet{
            setView()
        }
    }
    @IBInspectable var borderWith: CGFloat = 0.0 {
        didSet {
            setView()
        }
    }
    @IBInspectable var shadowOpacity: Float = 39.5 {
        didSet{
            setView()
        }
    }
    @IBInspectable var shadowRadius: Float = 4.0 {
        didSet{
            setView()
        }
    }
    @IBInspectable var shadowOffset: CGSize = CGSize(width: 1.0, height: 1.0) {
        didSet{
            setView()
        }
    }
    @IBInspectable var shadowColor:CGColor = UIColor(red: 188.0/255.0, green:
        128.0/255.0, blue: 47.0/255.0, alpha: 7.0).cgColor {
        didSet{
            setView()
        }
    }
    
    @IBInspectable var borderColor:CGColor = UIColor(red: 217.0/255.0, green:
        217.0/255.0, blue: 217.0/255.0, alpha: 7.0).cgColor {
        didSet{
            setView()
        }
    }
    
    @IBInspectable
    var shadowColor2: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
    
    @IBInspectable
    var borderColor2: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    override func prepareForInterfaceBuilder() {
        setView()
    }
    
    func setView() {
        layer.cornerRadius = CGFloat(cornerRadius)
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = shadowOpacity
        layer.borderWidth = borderWith
       // layer.borderColor = borderColor
        layer.shadowRadius = CGFloat(shadowRadius)
        
    }
}

