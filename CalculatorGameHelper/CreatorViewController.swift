//
//  CreatorViewController.swift
//  CalculatorGameHelper
//
//  Created by 张家治 on 13/01/2018.
//  Copyright © 2018 张家治. All rights reserved.
//

import UIKit

class CreatorViewController: UIViewController,
    KeyboardViewDelegate,
    EditableLabelDelegate {
    
    
    @IBOutlet weak var keyboard: BuilderKeyboardView!
    @IBOutlet weak var gameKeyboard: BuildingKeyboardView!
    
    @IBOutlet weak var keyInput: EditableLabel!
    @IBOutlet weak var sourceInput: EditableLabel!
    @IBOutlet weak var targetInput: EditableLabel!
    @IBOutlet weak var stepsInput: EditableLabel!
    
    var inputText: [String] = []
    
    let inputLabelBorderColor = UIColor.gray
    let inputLabelBorderColorActive = UIColor(displayP3Red: 51/255.0, green: 51/255.0, blue: 1, alpha: 1)
    
    weak var currentInput: EditableLabel? = nil
    
    private weak var activeButton: KeyboardItemView? = nil
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pressed(sender: KeyboardView, button: KeyboardItemView) {
        if (sender == self.gameKeyboard) {
            if (button != self.activeButton) {
                if (self.currentInput == self.keyInput) {
                    let fn = parseGameFn(self.keyInput.text ?? "")
                    if (fn != nil) {
                        self.activeButton?.text = self.keyInput.text
                    }
                    self.gameKeyboard.deactivateButton()
                }
                self.gameKeyboard.activateButton(button: button)
                self.activeButton = button
                self.inputText.removeAll()
                self.keyInput.text = nil
                button.text = nil
                self.currentInput?.active = false
                self.currentInput = keyInput
                self.currentInput?.active = true
                self.keyboard.enableAll()
            } else {
                self.gameKeyboard.deactivateButton()
                self.activeButton = nil
                self.inputText.removeAll()
                self.keyInput.text = nil
                self.currentInput?.active = false
                self.keyboard.disableAll()
            }
        }
        else if (sender == self.keyboard) {
            if (button == self.keyboard.buttonDone) {
                if (self.currentInput == self.keyInput) {
                    let fn = parseGameFn(self.keyInput.text ?? "")
                    if (fn != nil) {
                        self.activeButton?.text = self.keyInput.text
                    }
                    self.gameKeyboard.deactivateButton()
                    self.activeButton = nil
                    self.inputText.removeAll()
                    self.keyInput.text = nil
                }
                self.currentInput?.active = false
                self.currentInput = nil
                self.keyboard.disableAll()
            } else if (button == self.keyboard.buttonDelete) {
                if (self.currentInput == self.keyInput) {
                    if (self.activeButton != nil) {
                        _ = self.inputText.popLast()
                        self.currentInput?.text = self.inputText.joined()
                    }
                } else {
                    let text = self.currentInput?.text ?? ""
                    self.currentInput?.text = String(text[text.startIndex..<text.index(before: text.endIndex)])
                }
            } else {
                if (self.currentInput == self.keyInput) {
                    if (self.activeButton != nil) {
                        self.inputText.append(button.text!)
                        self.currentInput?.text = self.inputText.joined()
                    }
                } else {
                    let text = self.currentInput?.text ?? ""
                    self.currentInput?.text = text + (button.text ?? "")
                }
            }
        }
    }
    
    func editableLabelPressed(sender: EditableLabel) {
        if (sender != self.keyInput && sender != self.currentInput) {
            if (self.currentInput == self.keyInput) {
                let fn = parseGameFn(self.keyInput.text ?? "")
                if (fn != nil) {
                    self.activeButton?.text = self.keyInput.text
                }
                self.gameKeyboard.deactivateButton()
                self.currentInput?.text = nil
                self.inputText.removeAll()
            }
            self.currentInput?.active = false
            self.currentInput = sender
            self.currentInput?.active = true
            self.keyboard.disableAll()
            for button in self.keyboard.buttons {
                if (Int(button.text ?? "") != nil) {
                    button.disabled = false
                }
                else if (button.text == "-") {
                    button.disabled = false
                }
                else if (button == self.keyboard.buttonDone) {
                    button.disabled = false
                }
                else if (button == self.keyboard.buttonDelete) {
                    button.disabled = false
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "CreateDoneSegue") {
            let controller = segue.destination as! GamingViewController
            let fns_with_position = self.gameKeyboard!.fnButtons
                .filter({ (button: KeyboardItemView) -> Bool in return (button.text ?? "") != "" })
                .map({ (button: KeyboardItemView) -> GameFnWithPosition in return (parseGameFn(button.text!)!, (button.row!, button.col!)) })
            controller.gameSet = GameSetWithPosition(fns_with_position: fns_with_position,
                                                     limit: Int(self.stepsInput.text ?? "") ?? 0,
                                                     src: Int(self.sourceInput.text ?? "") ?? 0,
                                                     tgt: Int(self.targetInput.text ?? "") ?? 0)
        }
    }
}
