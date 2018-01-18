//
//  BuilderKeyboardView.swift
//  CalculatorGameHelper
//
//  Created by 张家治 on 12/01/2018.
//  Copyright © 2018 张家治. All rights reserved.
//

import UIKit

@objc protocol KeyboardViewDelegate: NSObjectProtocol {
    func pressed(sender: KeyboardView, button: KeyboardItemView)
}

@IBDesignable class KeyboardView: NibView, KeyboardItemViewDelegate {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    @IBOutlet weak var delegate: KeyboardViewDelegate?
    
    var buttons = [KeyboardItemView]([])
    @IBInspectable var rows: Int = 0
    @IBInspectable var cols: Int = 0
    @IBInspectable var keys: String! {
        didSet {
            self.buttons.removeAll()
            let words = self.keys.split(separator: ",")
            for word in words {
                self.addButton(word.trimmingCharacters(in: CharacterSet(charactersIn: " ")))
            }
        }
    }
    private var _buttonBorderRadius: CGFloat? = nil {
        didSet {
            for button in self.buttons {
                button.borderRadius = self._buttonBorderRadius
            }
        }
    }
    @IBInspectable var buttonBorderRadius: CGFloat {
        get {
            return self._buttonBorderRadius ?? -1
        }
        set (val) {
            self._buttonBorderRadius = val >= 0 ? val : nil
        }
    }
    
    let buttonGap: CGSize = CGSize(width: 2, height: 2)
    
    override internal var nibname: String? { return "KeyboardView" }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func addSubviews() {
        self.buttons.removeAll()
    }
    
    @discardableResult func addButton(_ text: String) -> KeyboardItemView {
        return self.addButton(KeyboardItem(text: text))
    }
    
    @discardableResult func addButton(_ info: KeyboardItem) -> KeyboardItemView {
        let decoratedInfo = KeyboardItem(
            text: info.text,
            row: info.row,
            col: info.col,
            rowSpan: info.rowSpan,
            colSpan: info.colSpan,
            color: info.color,
            blank: info.blank,
            plain: info.plain,
            borderRadius: info.borderRadius ?? self._buttonBorderRadius)
        let buttonView = KeyboardItemView(decoratedInfo, frame: CGRect(x:0,y:0,width:0,height:0))
        buttonView.delegate = self
        self.buttons.append(buttonView)
        self.view?.addSubview(buttonView)
        return buttonView
    }
    
    func removeButton(button: KeyboardItemView) {
        for (i, item) in self.buttons.enumerated() {
            if (item == button) {
                self.buttons.remove(at: i)
                break
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let viewFrame = self.view!.frame
        let buttonSize = CGSize(
            width: (viewFrame.width - self.buttonGap.width * CGFloat(self.cols + 1)) / CGFloat(self.cols),
            height: (viewFrame.height - self.buttonGap.height * CGFloat(self.rows + 1)) / CGFloat(self.rows)
        )
        let buttonGrid = CGSize(
            width: buttonGap.width + buttonSize.width,
            height: buttonGap.height + buttonSize.height
        )
        var taken = [Bool](repeating: false, count: self.rows * self.cols)
        for item in self.buttons {
            let ir: Int, ic: Int, ii: Int
            if (item.col != nil && item.row != nil) {
                ir = item.row!
                ic = item.col!
                ii = ir * self.cols + ic
            } else {
                ii = { () -> Int in
                    for (i, t) in taken.enumerated() {
                        if (!t) {
                            return i
                        }
                    }
                    return taken.count
                }()
                ir = ii / self.cols
                ic = ii - ir * self.cols
            }
            if (ii >= taken.count) {
                continue
            }
            let rspan = item.rowSpan
            let cspan = item.colSpan
            if (!item.blank) {
                item.frame = CGRect(
                    x: buttonGap.width + CGFloat(ic) * buttonGrid.width,
                    y: buttonGap.height + CGFloat(ir) * buttonGrid.height,
                    width: buttonSize.width * CGFloat(cspan) + buttonGap.width * CGFloat(cspan - 1),
                    height: buttonSize.height * CGFloat(rspan) + buttonGap.height * CGFloat(rspan - 1)
                )
            }
            for rr in 0..<rspan {
                for cc in 0..<cspan {
                    let idx = (ir + rr) * self.cols + ic + cc
                    if (idx < taken.count) {
                        taken[idx] = true
                    }
                }
            }
        }
    }
    
    func disableAll() {
        for button in self.buttons {
            button.disabled = true
        }
    }
    func enableAll() {
        for button in self.buttons {
            button.disabled = false
        }
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        let buttonSizeHint = BuilderKeyboardItemView.sizeHint
//        let viewFrame = self.view!.frame
//        let buttonSizeFull: CGSize = CGSize(
//            width: (viewFrame.width - self.buttonGap.width * CGFloat(self.cols + 1)) / CGFloat(self.cols),
//            height: (viewFrame.height - self.buttonGap.height * CGFloat(self.rows + 1)) / CGFloat(self.rows)
//        )
//        let buttonSizeRatio = min(buttonSizeFull.width / buttonSizeHint.width, buttonSizeFull.height / buttonSizeHint.height)
//        let buttonSizeActual = CGSize(
//            width: buttonSizeHint.width * buttonSizeRatio,
//            height: buttonSizeHint.height * buttonSizeRatio
//        )
//        let buttonGrid = CGSize(
//            width: buttonGap.width + buttonSizeActual.width,
//            height: buttonGap.height + buttonSizeActual.height
//        )
//        let buttonGroupMargin = CGSize(
//            width: (viewFrame.width - buttonGap.width * CGFloat(self.cols + 1) - buttonSizeActual.width * CGFloat(self.cols))/2,
//            height: (viewFrame.height - buttonGap.height * CGFloat(self.rows + 1) - buttonSizeActual.height * CGFloat(self.rows))/2
//        )
//        let buttonLTCorner = CGPoint(
//            x: buttonGroupMargin.width + (buttonGap.width + buttonSizeActual.width / 2),
//            y: buttonGroupMargin.height + (buttonGap.height + buttonSizeActual.height / 2))
//        for (i, item) in self.buttons.enumerated() {
//            let ir = i / self.cols
//            let ic = i - ir * self.cols
//            item.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: buttonSizeActual)
//            item.center = CGPoint(
//                x: buttonLTCorner.x + CGFloat(ic) * buttonGrid.width,
//                y: buttonLTCorner.y + CGFloat(ir) * buttonGrid.height
//            )
//        }
//    }
//
//    func sizeHint(fixedWidth: CGFloat) -> CGSize {
//        let buttonSizeHint = BuilderKeyboardItemView.sizeHint
//        let buttonFullWidth = (fixedWidth - self.buttonGap.width * CGFloat(self.cols + 1)) / CGFloat(self.cols)
//        let buttonSizeRatio = buttonFullWidth / buttonSizeHint.width
//        let buttonSizeActual = CGSize(
//            width: buttonSizeHint.width * buttonSizeRatio,
//            height: buttonSizeHint.height * buttonSizeRatio
//        )
//        let theSizeHint = CGSize(
//            width: fixedWidth,
//            height: buttonSizeActual.height * CGFloat(self.rows) + buttonGap.height * CGFloat(self.rows + 1)
//        )
//        return theSizeHint
//    }
//    func sizeHint(fixedWidth: Int) -> CGSize {
//        return sizeHint(fixedWidth: CGFloat(fixedWidth))
//    }
//    func sizeHint(fixedWidth: Double) -> CGSize {
//        return sizeHint(fixedWidth: CGFloat(fixedWidth))
//    }
//    func sizeHint(fixedHeight: CGFloat) -> CGSize {
//        let buttonSizeHint = BuilderKeyboardItemView.sizeHint
//        let buttonFullHeight = (fixedHeight - self.buttonGap.height * CGFloat(self.rows + 1)) / CGFloat(self.rows)
//        let buttonSizeRatio = buttonFullHeight / buttonSizeHint.height
//        let buttonSizeActual = CGSize(
//            width: buttonSizeHint.width * buttonSizeRatio,
//            height: buttonSizeHint.height * buttonSizeRatio
//        )
//        let theSizeHint = CGSize(
//            width: buttonSizeActual.width * CGFloat(self.cols) + buttonGap.width * CGFloat(self.cols + 1),
//            height: fixedHeight
//        )
//        return theSizeHint
//    }
//    func sizeHint(fixedHeight: Int) -> CGSize {
//        return sizeHint(fixedHeight: CGFloat(fixedHeight))
//    }
//    func sizeHint(fixedHeight: Double) -> CGSize {
//        return sizeHint(fixedHeight: CGFloat(fixedHeight))
//    }
    
    func pressed(sender: KeyboardItemView) {
        self.delegate?.pressed(sender: self, button: sender)
    }
    
    

}
