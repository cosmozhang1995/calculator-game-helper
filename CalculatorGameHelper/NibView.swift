//
//  NibView.swift
//  CalculatorGameHelper
//
//  Created by 张家治 on 13/01/2018.
//  Copyright © 2018 张家治. All rights reserved.
//

import UIKit

class NibView: UIControl {
    
    var view: UIView? = nil
    
    internal var nibname: String? { return nil }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.loadNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.loadNib()
    }
    
    func loadNib() {
        let bundle = Bundle.init(for: type(of: self))
        let nibname = self.nibname ?? type(of: self).description().components(separatedBy: ".").last!
        let nib = UINib(nibName: nibname, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[childView]|",
                                                      options: [],
                                                      metrics: nil,
                                                      views: ["childView": view]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[childView]|",
                                                      options: [],
                                                      metrics: nil,
                                                      views: ["childView": view]))
        self.view = view
    }
}

class NibControl: UIControl {
    
    var view: UIView? = nil
    
    internal var nibname: String? { return nil }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.loadNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.loadNib()
    }
    
    func loadNib() {
        let bundle = Bundle.init(for: type(of: self))
        let nibname = self.nibname ?? type(of: self).description().components(separatedBy: ".").last!
        let nib = UINib(nibName: nibname, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[childView]|",
                                                      options: [],
                                                      metrics: nil,
                                                      views: ["childView": view]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[childView]|",
                                                      options: [],
                                                      metrics: nil,
                                                      views: ["childView": view]))
        self.view = view
    }
}
