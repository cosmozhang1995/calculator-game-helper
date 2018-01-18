//
//  BuilderKeyboardItemView.swift
//  CalculatorGameHelper
//
//  Created by 张家治 on 13/01/2018.
//  Copyright © 2018 张家治. All rights reserved.
//

import UIKit

class KeyboardItem {
    let blank: Bool?
    let text: String?
    let row: Int?
    let col: Int?
    let rowSpan: Int?
    let colSpan: Int?
    let color: UIColor?
    let plain: Bool?
    let borderRadius: CGFloat?
    init(text: String? = nil, row: Int? = nil, col: Int? = nil, rowSpan: Int? = nil, colSpan: Int? = nil, color: UIColor? = nil, blank: Bool? = nil, plain: Bool? = nil, borderRadius: CGFloat? = nil) {
        self.text = text
        self.row = row
        self.col = col
        self.color = color
        self.rowSpan = rowSpan
        self.colSpan = colSpan
        self.blank = blank
        self.plain = plain
        self.borderRadius = borderRadius
    }
}

@objc protocol KeyboardItemViewDelegate: NSObjectProtocol {
    func pressed(sender: KeyboardItemView)
    @objc optional func canChangeColorOnTouch(sender: KeyboardItemView) -> Bool
    @objc optional func canChangeColorOnActive(sender: KeyboardItemView) -> Bool
}

@IBDesignable class KeyboardItemView: NibView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    @IBOutlet weak var delegate: KeyboardItemViewDelegate?
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var bgview: UIView!
    @IBOutlet weak var bgview_shadow: UIView!
    @IBInspectable var color: UIColor! {
        didSet {
            self.onColorSet()
        }
    }
    
    var _bgcolor: UIColor!
    var _bgcolor_darken: UIColor!
    var _bgcolor_lighten: UIColor!
    var _bgcolor_disabled: UIColor!
    
    var row: Int? = -1
    var col: Int? = -1
    var rowSpan: Int = 1
    var colSpan: Int = 1
    var blank: Bool = false {
        didSet {
            self.onStyleSet()
        }
    }
    var plain: Bool = false {
        didSet {
            self.onStyleSet()
        }
    }
    
    var borderRadius: CGFloat? = nil {
        didSet {
            self.setBorderRadius()
        }
    }
    
    private var touched: Bool = false {
        didSet {
            self.updateStatus()
        }
    }
    
    var active: Bool = false {
        didSet {
            self.updateStatus()
        }
    }
    
    var disabled: Bool = false {
        didSet {
            self.updateStatus()
        }
    }
    
    var meta: Any? = nil
    
    required init?(coder aDecoder: NSCoder) {
        self.color = UIColor.gray
        super.init(coder: aDecoder)
        self.onColorSet()
    }
    
    var info: KeyboardItem {
        return KeyboardItem(text: self.text, row: self.row, col: self.col, rowSpan: self.rowSpan, colSpan: self.colSpan, color: self._bgcolor, blank: self.blank, plain: self.plain, borderRadius: self.borderRadius)
    }
    
    init(_ info: KeyboardItem, frame: CGRect) {
        super.init(frame: frame)
        self.text = info.text
        self.row = info.row
        self.col = info.col
        self.color = info.color ?? UIColor.gray
        self.rowSpan = info.rowSpan ?? 1
        self.colSpan = info.colSpan ?? 1
        self.blank = info.blank ?? false
        self.plain = info.plain ?? false
        self.borderRadius = info.borderRadius
        self.onColorSet()
    }
    
    var text: String? {
        get {
            return self.label.text
        }
        set (val) {
            self.label.text = val
        }
    }
    
    static var sizeHint: CGSize {
        get {
            return UIImage(named: "keybutton-off")!.size
        }
    }
    
    override func layoutSubviews() {
        self.setBorderRadius()
        self.bgview_shadow.backgroundColor = self._bgcolor_darken
        self.setColorOff()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (!self.disabled) {
            self.touched = true
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (!self.disabled) {
            self.touched = false
            self.delegate?.pressed(sender: self)
        }
    }
    
    private func setColorOff() {
        if (!self.blank) {
            let bgfgcolor = self.disabled ? self._bgcolor_disabled : self._bgcolor
            self.colorred_bgview.backgroundColor = bgfgcolor
        }
    }
    private func setColorOn() {
        if (!self.blank) {
            self.colorred_bgview.backgroundColor = self._bgcolor_lighten
        }
    }
    
    private func updateStatus() {
        if (self.touched && (self.delegate?.canChangeColorOnTouch?(sender: self) ?? true)) {
            self.setColorOn()
        } else if (self.active && (self.delegate?.canChangeColorOnActive?(sender: self) ?? true)) {
            self.setColorOn()
        } else {
            self.setColorOff()
        }
    }
    
    private func onColorSet() {
        self._bgcolor = self.color
        let hsl = HSLColor(cgColor: self.color.cgColor)
        let lightness = hsl.lightness
        let saturation = hsl.saturation
        hsl.lightness = max(lightness - 0.25, 0)
        self._bgcolor_darken = hsl.uiColor!
        hsl.lightness = min(lightness + 0.10, 1)
        self._bgcolor_lighten = hsl.uiColor!
        hsl.lightness = lightness
        hsl.saturation = max(saturation - 0.3, 0)
        self._bgcolor_disabled = hsl.uiColor!
        self.onStyleSet()
    }
    
    private func onStyleSet() {
        if (blank) {
            self.bgview.backgroundColor = UIColor.clear
            self.bgview_shadow.backgroundColor = UIColor.clear
        } else {
            let bgfgcolor = self.disabled ? self._bgcolor_disabled : self._bgcolor
            if (self.plain) {
                self.bgview.backgroundColor = UIColor.clear
                self.bgview_shadow.backgroundColor = bgfgcolor
            } else {
                self.bgview.backgroundColor = bgfgcolor
                self.bgview_shadow.backgroundColor = self._bgcolor_darken
            }
        }
    }
    
    private var colorred_bgview: UIView {
        if (self.plain) {
            return self.bgview_shadow
        } else {
            return self.bgview
        }
    }
    
    private func setBorderRadius() {
        let fullSize = min(self.frame.width, self.frame.height)
        let cornerSize = self.borderRadius ?? (fullSize * CGFloat(0.1))
        self.bgview.layer.cornerRadius = cornerSize
        self.bgview_shadow.layer.cornerRadius = cornerSize
    }

}
