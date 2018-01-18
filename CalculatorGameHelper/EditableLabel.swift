//
//  EditableLabel.swift
//  CalculatorGameHelper
//
//  Created by 张家治 on 16/01/2018.
//  Copyright © 2018 张家治. All rights reserved.
//

import UIKit

@objc protocol EditableLabelDelegate: NSObjectProtocol {
    @objc optional func editableLabelPressed(sender: EditableLabel)
    @objc optional func editableLabelDidActivated(sender: EditableLabel)
    @objc optional func editableLabelDidDeactivated(sender: EditableLabel)
}

@IBDesignable class EditableLabel: UILabel {
    @IBInspectable var borderColor: UIColor? = nil {
        didSet {
            updateStyle()
        }
    }
    @IBInspectable var borderColorActive: UIColor? = nil {
        didSet {
            updateStyle()
        }
    }
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            updateStyle()
        }
    }
    @IBInspectable var borderWidthActive: CGFloat = 0 {
        didSet {
            updateStyle()
        }
    }
    @IBInspectable var borderRadius: CGFloat = -1 {
        didSet {
            updateStyle()
            if (self.padding < 0 && self.borderRadius > 0) {
                self.padding = self.borderRadius
            }
        }
    }
    
    @IBInspectable var padding: CGFloat = -1 {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    @IBOutlet weak var delegate: EditableLabelDelegate? = nil
    
    var active: Bool = false {
        didSet {
            if (self.active) {
                self.delegate?.editableLabelDidActivated?(sender: self)
            } else {
                self.delegate?.editableLabelDidDeactivated?(sender: self)
            }
            updateStyle()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.afterInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.afterInit()
    }
    
    private func afterInit() {
        self.isUserInteractionEnabled = true
        self.updateStyle()
    }
    
    private func updateStyle() {
        let borderColor: UIColor = self.borderColor ?? UIColor.lightGray
        let borderColorActive: UIColor = self.borderColorActive ?? UIColor.lightText
        let borderWidth: CGFloat = (self.borderWidth > 0) ? self.borderWidth : 1
        let borderWidthActive: CGFloat = (self.borderWidthActive > 0) ? self.borderWidthActive : borderWidth
        let borderRadius: CGFloat = (self.borderRadius >= 0) ? self.borderRadius : 4
        if (self.active) {
            self.layer.borderWidth = borderWidthActive
            self.layer.borderColor = borderColorActive.cgColor
            self.layer.cornerRadius = borderRadius
        } else {
            self.layer.borderWidth = borderWidth
            self.layer.borderColor = borderColor.cgColor
            self.layer.cornerRadius = borderRadius
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.delegate?.editableLabelPressed?(sender: self)
    }
    
    override func drawText(in rect: CGRect) {
        let padding:  CGFloat
        if (self.padding >= 0) {
            padding = self.padding
        } else if (self.borderRadius >= 0) {
            padding = self.borderRadius
        } else {
            padding = 4
        }
        let insets = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }
}
