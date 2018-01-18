//
//  CalculatorScreenView.swift
//  CalculatorGameHelper
//
//  Created by 张家治 on 17/01/2018.
//  Copyright © 2018 张家治. All rights reserved.
//

import UIKit

@IBDesignable class CalculatorScreenView: NibView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    @IBOutlet private weak var stepNumberLabel: UILabel!
    @IBOutlet private weak var targetNumberLabel: UILabel!
    @IBOutlet private weak var numberLabel: UILabel!
    
    @IBInspectable private var errorColor: UIColor = UIColor(displayP3Red: 1, green: 0.2, blue: 0.2, alpha: 1) {
        didSet {
            self.updateStepsStatus()
            self.updateTargetStatus()
            self.updateNumberStatus()
        }
    }
    @IBInspectable private var labelCornerRadius: CGFloat = 6 {
        didSet {
            self.stepNumberLabel.layer.cornerRadius = self.labelCornerRadius
            self.targetNumberLabel.layer.cornerRadius = self.labelCornerRadius
            self.numberLabel.layer.cornerRadius = self.labelCornerRadius
        }
    }
    
    var steps: Int = 0 {
        didSet {
            self.stepNumberLabel.text = String(self.steps)
        }
    }
    var target: Int = 0 {
        didSet {
            self.targetNumberLabel.text = String(self.target)
        }
    }
    var number: Int = 0 {
        didSet {
            self.numberLabel.text = String(self.number)
        }
    }
    
    var stepsError: Bool = false {
        didSet {
            self.updateStepsStatus()
        }
    }
    var targetError: Bool = false {
        didSet {
            self.updateTargetStatus()
        }
    }
    var numberError: Bool = false {
        didSet {
            self.updateNumberStatus()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func updateStepsStatus() {
        self.stepNumberLabel.backgroundColor = self.stepsError ? self.errorColor : UIColor.clear
    }
    private func updateTargetStatus() {
        self.targetNumberLabel.backgroundColor = self.targetError ? self.errorColor : UIColor.clear
    }
    private func updateNumberStatus() {
        self.numberLabel.backgroundColor = self.numberError ? self.errorColor : UIColor.clear
    }

}
