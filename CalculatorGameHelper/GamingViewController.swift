//
//  GamingViewController.swift
//  CalculatorGameHelper
//
//  Created by 张家治 on 16/01/2018.
//  Copyright © 2018 张家治. All rights reserved.
//

import UIKit

@IBDesignable class GamingViewController: UIViewController, KeyboardViewDelegate {
    
    static let domain = "com.cosmozhang.CalculatorGameHelper.GamingViewController"
    enum Errors: Int {
        case ErrorNoSolution = -1
        case ErrorNoMatchingButton = -2
    }
    
    @IBOutlet weak var keyboard: GameKeyboardView? {
        didSet {
            self.updateKeyboard()
        }
    }
    
    @IBOutlet weak var screen: CalculatorScreenView? {
        didSet {
            if (self.screen != nil) {
                self.screen!.steps = self.steps
                self.screen!.target = self.target
                self.screen!.number = self.number
            }
        }
    }
    
    @IBInspectable var buttonHighlightColor: UIColor = UIColor.cyan
    @IBInspectable var buttonHighlightInterval: TimeInterval = 1.0
    
    var gameSet: GameSetWithPosition? = nil {
        didSet {
            self.updateKeyboard()
            self.clear()
        }
    }
    
    var steps: Int = 0 {
        didSet {
            self.screen?.steps = self.steps
            if (self.steps <= 0) {
                self.keyboard?.disableAll()
                self.keyboard?.okClearButton.disabled = false
                self.keyboard?.hackButton.disabled = false
                self.screen?.stepsError = self.number != self.gameSet?.tgt
            } else {
                self.screen?.stepsError = false
                self.keyboard?.enableAll()
            }
        }
    }
    var target: Int = 0 {
        didSet {
            self.screen?.target = self.target
        }
    }
    var number: Int = 0 {
        didSet {
            self.screen?.number = self.number
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    private func updateKeyboard() {
        if (self.keyboard != nil) {
            self.keyboard!.removeAllFnButtons()
            if (self.gameSet != nil) {
                let keyfns = self.gameSet!.fns
                let keyposs = self.gameSet!.positions
                for i in 0..<keyfns.count {
                    let fn = keyfns[i]
                    let pos = keyposs[i]
                    let button = self.keyboard!.addButton(text: fn.name, at: (pos.row, pos.col))
                    button.meta = fn
                }
            }
        }
    }
    
    private func clear() {
        self.steps = self.gameSet?.limit ?? 0
        self.target = self.gameSet?.tgt ?? 0
        self.number = self.gameSet?.src ?? 0
    }
    
    private var _hackHighlightingButton: KeyboardItemView? = nil
    private var _hackHighlightingButtonColor: UIColor? = nil
    @objc private func _hackStep(button: KeyboardItemView) {
        if (self._hackHighlightingButton != nil) {
            self._hackHighlightingButton!.color = self._hackHighlightingButtonColor
        }
        self._hackHighlightingButtonColor = button.color
        self._hackHighlightingButton = button
        button.color = self.buttonHighlightColor
        self.process(fn: button.meta as! GameFn)
    }
    @objc private func _hackBegin() {
        self.clear()
        if (self._hackHighlightingButton != nil) {
            self._hackHighlightingButton!.color = self._hackHighlightingButtonColor
        }
        self._hackHighlightingButtonColor = nil
        self._hackHighlightingButton = nil
        self.keyboard?.disableAll()
    }
    @objc private func _hackEnd() {
        if (self._hackHighlightingButton != nil) {
            self._hackHighlightingButton!.color = self._hackHighlightingButtonColor
        }
        self._hackHighlightingButtonColor = nil
        self._hackHighlightingButton = nil
        self.keyboard?.enableAll()
        let alert = UIAlertController(title: "Game", message: self.number == self.gameSet?.tgt ? "Hack success!" : "Hack failed!", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    private func hack() {
        let solution = solveGame(game: self.gameSet!)
        if (solution == nil) {
            let alert = UIAlertController(title: "Game", message: "Cannot find a solution", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            let buttons = try? solution!.map({ (fn: GameFn) throws -> KeyboardItemView in
                for button in self.keyboard!.fnButtons {
                    if ((button.meta as! GameFn).name == fn.name) {
                        return button
                    }
                }
                throw NSError(domain: GamingViewController.domain, code: Errors.ErrorNoMatchingButton.rawValue, userInfo: nil)
            })
            if (buttons != nil) {
                self._hackBegin()
                Thread(block: { () -> Void in
                    for button in buttons! {
                        self.performSelector(onMainThread: #selector(self._hackStep(button:)), with: button, waitUntilDone: true)
                        Thread.sleep(forTimeInterval: self.buttonHighlightInterval)
                    }
                    self.performSelector(onMainThread: #selector(self._hackEnd), with: nil, waitUntilDone: true)
                }).start()
            }
        }
    }
    
    private func process(fn: GameFn) {
        let number = fn.process(self.number)
        if (number == self.number) { return }
        self.number = number
        self.steps -= 1
    }
    
    func pressed(sender: KeyboardView, button: KeyboardItemView) {
        if (button == self.keyboard?.okClearButton) {
            self.clear()
        }
        else if (button == self.keyboard?.hackButton) {
            self.hack()
        }
        else if (button.meta != nil) {
            let fn = button.meta as? GameFn
            if (fn != nil) {
                self.process(fn: fn!)
                if (self.number == self.gameSet?.tgt) {
                    let alert = UIAlertController(title: "Game", message: "Success!", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }

}
