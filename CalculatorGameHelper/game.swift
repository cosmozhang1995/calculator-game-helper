//
//  game.swift
//  CalculatorGameHelper
//
//  Created by 张家治 on 12/01/2018.
//  Copyright © 2018 张家治. All rights reserved.
//

import Foundation

typealias SignedDigits = (digits: [Int], sign: Int)

protocol GameFn {
    var name: String { get }
    func process(_ num: Int) -> Int
}

func _sign (_ num: Int) -> Int {
    if (num > 0) {
        return 1
    }
    else if (num < 0) {
        return -1
    }
    else {
        return 0
    }
}

func _num2digits (_ num: Int) -> SignedDigits {
    var numa = abs(num)
    var digits = [Int]()
    var d: Int
    while (numa >= 10) {
        d = numa % 10
        digits.append(d)
        numa = numa / 10
    }
    digits.append(numa)
    digits = digits.reversed()
    let sign = _sign(num)
    return (digits, sign)
}
func _digits2num (_ digits_with_sign: SignedDigits) -> Int {
    var numa = 0
    let digits = digits_with_sign.digits
    for (_,d) in digits.enumerated() {
        numa = numa * 10 + d
    }
    return digits_with_sign.sign * numa
}

func _reverse_array (_ src: [Int]) -> [Int] {
    var new_arr = [Int](repeating: 0, count: src.count)
    for i in 1...src.count {
        new_arr[i-1] = src[src.count-i]
    }
    return new_arr
}

class GameFnAdd: GameFn {
    let other: Int
    init(_ other: Int) {
        self.other = other
    }
    func process(_ num: Int) -> Int {
        return num + other
    }
    var name: String {
        return "+\(self.other)"
    }
}
class GameFnSub: GameFn {
    let other: Int
    init(_ other: Int) {
        self.other = other
    }
    func process(_ num: Int) -> Int {
        return num - other
    }
    var name: String {
        return "-\(self.other)"
    }
}
class GameFnMul: GameFn {
    let other: Int
    init(_ other: Int) {
        self.other = other
    }
    func process(_ num: Int) -> Int {
        return num * other
    }
    var name: String {
        return "*\(self.other)"
    }
}
class GameFnDiv: GameFn {
    let other: Int
    init(_ other: Int) {
        self.other = other
    }
    func process(_ num: Int) -> Int {
        return num / other
    }
    var name: String {
        return "/\(self.other)"
    }
}
class GameFnSum: GameFn {
    init() {
    }
    func process(_ num: Int) -> Int {
        let digits_with_sign = _num2digits(num)
        let digits = digits_with_sign.digits
        var res = 0
        for d in digits {
            res += d
        }
        res = digits_with_sign.sign * res
        return res
    }
    var name: String {
        return "Sum"
    }
}
class GameFnDel: GameFn {
    init() {
    }
    func process(_ num: Int) -> Int {
        var digits_with_sign = _num2digits(num)
        _ = digits_with_sign.digits.popLast()
        return _digits2num(digits_with_sign)
    }
    var name: String {
        return "<<"
    }
}
class GameFnReverse: GameFn {
    init() {
    }
    func process(_ num: Int) -> Int {
        let digits_with_sign = _num2digits(num)
        let digits = _reverse_array(digits_with_sign.digits)
        let d = (digits, digits_with_sign.sign)
        return _digits2num(d)
    }
    var name: String {
        return "Reverse"
    }
}
class GameFnMirror: GameFn {
    init() {
    }
    func process(_ num: Int) -> Int {
        let digits_with_sign = _num2digits(num)
        let digits = _reverse_array(digits_with_sign.digits)
        let d = (digits_with_sign.digits + digits, digits_with_sign.sign)
        return _digits2num(d)
    }
    var name: String {
        return "Mirror"
    }
}
class GameFnReplace: GameFn {
    let search: Int
    let rep: Int
    private let str_search: String
    private let str_rep: String
    init(search: Int, rep: Int) {
        self.search = search
        self.rep = rep
        self.str_search = String(search)
        self.str_rep = String(rep)
    }
    func process(_ num: Int) -> Int {
        return Int(String(num).replacingOccurrences(of: str_search, with: str_rep))!
    }
    var name: String {
        return "\(self.search)>>\(self.rep)"
    }
}
class GameFnShiftLeft: GameFn {
    init() {
    }
    func process(_ num: Int) -> Int {
        let digits_with_sign = _num2digits(num)
        let digits = digits_with_sign.digits
        let newdigits: SignedDigits = (digits[1..<digits.count] + [digits[0]], digits_with_sign.sign)
        return _digits2num(newdigits)
    }
    var name: String {
        return "Shift<<"
    }
}
class GameFnShiftRight: GameFn {
    init() {
    }
    func process(_ num: Int) -> Int {
        let digits_with_sign = _num2digits(num)
        let digits = digits_with_sign.digits
        let newdigits: SignedDigits = ([digits[digits.count-1]] + digits[0..<(digits.count-1)], digits_with_sign.sign)
        return _digits2num(newdigits)
    }
    var name: String {
        return "Shift>>"
    }
}

func parseGameFn (_ name: String) -> GameFn? {
    if (name == "") {
        return nil
    }
    let namelc = name.lowercased()
    let namelc_ns = namelc as NSString
    let ch0 = namelc[namelc.startIndex]
    var match: NSTextCheckingResult?
    if (ch0 == "+") {
        return GameFnAdd(Int(namelc[namelc.index(after: namelc.startIndex)..<namelc.endIndex])!)
    }
    if (ch0 == "-") {
        return GameFnSub(Int(namelc[namelc.index(after: namelc.startIndex)..<namelc.endIndex])!)
    }
    if (ch0 == "*") {
        return GameFnMul(Int(namelc[namelc.index(after: namelc.startIndex)..<namelc.endIndex])!)
    }
    if (ch0 == "/") {
        return GameFnDiv(Int(namelc[namelc.index(after: namelc.startIndex)..<namelc.endIndex])!)
    }
    if (namelc == "<<") {
        return GameFnDel()
    }
    if (namelc == "shift<<") {
        return GameFnShiftLeft()
    }
    if (namelc == "shift>>") {
        return GameFnShiftRight()
    }
    if (namelc == "sum") {
        return GameFnSum()
    }
    if (namelc == "reverse") {
        return GameFnReverse()
    }
    if (namelc == "mirror") {
        return GameFnMirror()
    }
    match = try! NSRegularExpression(pattern: "(\\d+)\\s*>>\\s*(\\d+)").firstMatch(in: namelc, range: NSMakeRange(0, namelc.count))
    if (match != nil) {
        let num_src = Int(namelc_ns.substring(with: match!.range(at: 1)))!
        let num_tgt = Int(namelc_ns.substring(with: match!.range(at: 2)))!
        return GameFnReplace(search: num_src, rep: num_tgt)
    }
    return nil
}

class GameSet {
    var fns: [GameFn] = []
    var limit: Int = 0
    var src: Int = 0
    var tgt: Int = 0
    init(fns: [GameFn], limit: Int, src: Int, tgt: Int) {
        self.fns = fns
        self.limit = limit
        self.src = src
        self.tgt = tgt
    }
}

func solveGame(game: GameSet) -> [GameFn]? {
    func inSolveGame(src: Int, tgt: Int, fns: [GameFn], limit: Int) -> [GameFn]? {
        if (src == tgt) {
            return []
        } else if (limit == 0) {
            return nil
        } else {
            for fn in fns {
                let astep = fn.process(src)
                if (astep == tgt) {
                    return [fn]
                } else {
                    let additionalFns = inSolveGame(src: astep, tgt: tgt, fns: fns, limit: limit - 1)
                    if (additionalFns != nil) {
                        return [fn] + additionalFns!
                    }
                }
            }
            return nil
        }
    }
    return inSolveGame(src: game.src, tgt: game.tgt, fns: game.fns, limit: game.limit)
}


