//
//  BuilderKeyboardView.swift
//  CalculatorGameHelper
//
//  Created by 张家治 on 15/01/2018.
//  Copyright © 2018 张家治. All rights reserved.
//

import UIKit

class BuilderKeyboardView: KeyboardView {
    
    private weak var _buttonDelete: KeyboardItemView? = nil
    var buttonDelete: KeyboardItemView { return self._buttonDelete! }
    private weak var _buttonDone: KeyboardItemView? = nil
    var buttonDone: KeyboardItemView { return self._buttonDone! }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.afterInit()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.afterInit()
    }
    
    private func afterInit() {
        self.rows = 5
        self.cols = 5
        //self.keys = "Sum, 1, 2, 3, +, Reverse, 4, 5, 6, -, Mirror, 7, 8, 9, *, Shift, >>, 0, <<, /"
        // row 0
        self.addButton("+")
        self.addButton("1")
        self.addButton("2")
        self.addButton("3")
        self._buttonDelete = self.addButton(KeyboardItem(text: "⌫", color: RGBColor(red: 0.8, green: 0.2, blue: 0.2).uiColor))
        // row 1
        self.addButton("-")
        self.addButton("4")
        self.addButton("5")
        self.addButton("6")
        self.addButton("Sum")
        // row 2
        self.addButton("*")
        self.addButton("7")
        self.addButton("8")
        self.addButton("9")
        self.addButton("Reverse")
        // row 3
        self.addButton("/")
        self.addButton(">>")
        self.addButton("0")
        self.addButton("<<")
        self.addButton("Mirror")
        // row 4
        self.addButton("Shift")
        self._buttonDone = self.addButton(KeyboardItem(text: "Done", colSpan: 4, color: RGBColor(red: 0.2, green: 0.2, blue: 0.8).uiColor))
    }
}
