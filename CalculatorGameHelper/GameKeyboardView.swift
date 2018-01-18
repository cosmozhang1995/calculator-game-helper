//
//  GameKeyboardView.swift
//  CalculatorGameHelper
//
//  Created by 张家治 on 15/01/2018.
//  Copyright © 2018 张家治. All rights reserved.
//

import UIKit

typealias GameKeyboardButtonPosition = (row: Int, col: Int)

typealias GameFnWithPosition = (fn: GameFn, pos: GameKeyboardButtonPosition)

class GameSetWithPosition: GameSet {
    var positions: [GameKeyboardButtonPosition]
    init(fns_with_position: [GameFnWithPosition], limit: Int, src: Int, tgt: Int) {
        let fns = try! fns_with_position.map({ (item: GameFnWithPosition) throws -> GameFn in return item.fn })
        self.positions = try! fns_with_position.map({ (item: GameFnWithPosition) throws -> GameKeyboardButtonPosition in return item.pos })
        super.init(fns: fns, limit: limit, src: src, tgt: tgt)
    }
}

@IBDesignable class GameKeyboardView: KeyboardView {
    
    internal var fnButtons: [KeyboardItemView] = []
    
    private weak var _okClrButton: KeyboardItemView? = nil
    var okClearButton: KeyboardItemView { return self._okClrButton! }
    private weak var _hackButton: KeyboardItemView? = nil
    var hackButton: KeyboardItemView { return self._hackButton! }
    
    @IBInspectable var buttonColor: UIColor = UIColor.gray {
        didSet {
            for button in self.fnButtons {
                button.color = self.buttonColor
            }
        }
    }
    @IBInspectable var okColor: UIColor = UIColor.green {
        didSet {
            self._updateOkClr()
        }
    }
    @IBInspectable var clrColor: UIColor = UIColor.red {
        didSet {
            self._updateOkClr()
        }
    }
    @IBInspectable var hackColor: UIColor = UIColor.darkGray {
        didSet {
            self._hackButton?.color = self.hackColor
        }
    }
    
    var ok: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.afterInit()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.afterInit()
    }
    
    func button(at position: GameKeyboardButtonPosition) -> KeyboardItemView? {
        for (_, button) in self.fnButtons.enumerated() {
            if (button.row == position.row && button.col == position.col) {
                return button
            }
        }
        return nil
    }
    
    @discardableResult func addButton(text: String, at position: GameKeyboardButtonPosition) -> KeyboardItemView {
        if (self.button(at: position) != nil) {
            self.removeButton(at: position)
        }
        let info = KeyboardItem(text: text, row: position.row, col: position.col, rowSpan: 1, colSpan: 1, color: self.buttonColor, blank: false, plain: false)
        let button = super.addButton(info)
        self.fnButtons.append(button)
        return button
    }
    
    func removeButton(at position: GameKeyboardButtonPosition) {
        for (i, button) in self.fnButtons.enumerated() {
            if (button.row == position.row && button.col == position.col) {
                super.removeButton(button: button)
                self.fnButtons.remove(at: i)
                break
            }
        }
    }
    
    func removeAllFnButtons() {
        for button in self.fnButtons {
            super.removeButton(button: button)
        }
        self.fnButtons.removeAll()
    }
    
    internal func afterInit() {
        self.rows = 3
        self.cols = 3
        //self.keys = "Sum, 1, 2, 3, +, Reverse, 4, 5, 6, -, Mirror, 7, 8, 9, *, Shift, >>, 0, <<, /"
        // row 0
        self._okClrButton = self.addButton(KeyboardItem(text: "CLR", row: 0, col: 2, color: self.clrColor))
        self._hackButton = self.addButton(KeyboardItem(text: "HACK", row: 0, col: 0, rowSpan: 3, colSpan: nil, color: self.hackColor))
    }
    
    private func _updateOkClr() {
        if (self.ok) {
            self._okClrButton?.color = self.okColor
            self._okClrButton?.text = "OK"
        } else {
            self._okClrButton?.color = self.clrColor
            self._okClrButton?.text = "CLR"
        }
    }
}
