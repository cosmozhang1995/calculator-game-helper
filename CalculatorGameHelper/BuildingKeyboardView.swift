//
//  BuildingKeyboardView.swift
//  CalculatorGameHelper
//
//  Created by 张家治 on 15/01/2018.
//  Copyright © 2018 张家治. All rights reserved.
//

import UIKit

@IBDesignable class BuildingKeyboardView: GameKeyboardView {
    
    weak var activeButton: KeyboardItemView? = nil
    
    @IBInspectable var plainColor: UIColor? = nil {
        didSet {
            if (self.plainColor == nil) {
                self.plainColor = UIColor.lightGray
            } else {
                for button in self.fnButtons {
                    updateButtonColor(button: button)
                }
            }
        }
    }
    
    @IBInspectable var activeColor: UIColor? = nil {
        didSet {
            if (self.activeColor == nil) {
                self.activeColor = UIColor.lightGray
            } else {
                for button in self.fnButtons {
                    updateButtonColor(button: button)
                }
            }
        }
    }
    
    @IBInspectable var validColor: UIColor? = nil {
        didSet {
            if (self.validColor == nil) {
                self.validColor = UIColor.lightGray
            } else {
                for button in self.fnButtons {
                    updateButtonColor(button: button)
                }
            }
        }
    }
    
    override internal func afterInit() {
        super.afterInit()
        self.addButton(text: "", at: (0,1)).plain = true
        self.addButton(text: "", at: (1,1)).plain = true
        self.addButton(text: "", at: (1,2)).plain = true
        self.addButton(text: "", at: (2,1)).plain = true
        self.addButton(text: "", at: (2,2)).plain = true
        self.okClearButton.disabled = true
    }
    
    override func enableAll() {
        super.enableAll()
        self.okClearButton.disabled = true
        self.hackButton.disabled = true
    }
    
    override func pressed(sender: KeyboardItemView) {
        super.pressed(sender: sender)
    }
    
    func activateButton(button: KeyboardItemView) {
        if (button != self.okClearButton && button != self.hackButton) {
            self.activeButton?.plain = true
            self.activeButton?.color = self.plainColor
            button.plain = false
            button.color = self.activeColor
            self.activeButton = button
        }
    }
    
    func deactivateButton() {
        if (self.activeButton?.text != nil && self.activeButton?.text != "") {
            self.activeButton?.plain = false
        } else {
            self.activeButton?.plain = true
        }
        let activeButton = self.activeButton
        self.activeButton = nil
        if (activeButton != nil) {
            updateButtonColor(button: activeButton!)
        }
    }
    
    func canChangeColorOnTouch(sender: KeyboardItemView) -> Bool {
        return false
    }
    
    func updateButtonColor(button: KeyboardItemView) {
        if (button == self.activeButton) {
            button.color = self.activeColor
        } else if ((button.text ?? "") != "") {
            button.color = self.validColor
        } else {
            button.color = self.plainColor
        }
    }
}
