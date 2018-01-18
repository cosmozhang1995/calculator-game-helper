//
//  color.swift
//  CalculatorGameHelper
//
//  Created by 张家治 on 14/01/2018.
//  Copyright © 2018 张家治. All rights reserved.
//

import UIKit

class RGBColor {
    var red: CGFloat
    var green: CGFloat
    var blue: CGFloat
    var cgColor: CGColor? {
        get {
            return self.uiColor?.cgColor
        }
    }
    var uiColor: UIColor? {
        get {
            return UIColor(displayP3Red: self.red, green: self.green, blue: self.blue, alpha: 1.0)
        }
    }
    init(cgColor: CGColor) {
        let cgRGBColor = cgColor.converted(to: CGColorSpaceCreateDeviceRGB(), intent: CGColorRenderingIntent.defaultIntent, options: nil)
        self.red = cgRGBColor!.components![0]
        self.green = cgRGBColor!.components![1]
        self.blue = cgRGBColor!.components![2]
    }
    init(red: CGFloat, green: CGFloat, blue: CGFloat) {
        self.red = red
        self.green = green
        self.blue = blue
    }
}

class HSVColor {
    var hue: CGFloat
    var saturation: CGFloat
    var value: CGFloat
    var rgbColor: RGBColor {
        get {
            let hi = Int(self.hue / 60) % 6
            let f = self.hue / 60 - CGFloat(hi)
            let p = self.value * (1 - self.saturation)
            let q = self.value * (1 - f * self.saturation)
            let t = self.value * (1 - (1 - f) * self.saturation)
            let v = self.value
            var rgb: [CGFloat] = []
            switch hi {
            case 0:
                rgb = [v, t, p]
                break
            case 1:
                rgb = [q, v, p]
                break
            case 2:
                rgb = [p, v, t]
                break
            case 3:
                rgb = [p, q, v]
                break
            case 4:
                rgb = [t, p, v]
                break
            case 5:
                rgb = [v, p, q]
                break
            default:
                break
            }
            return RGBColor(red: rgb[0], green: rgb[1], blue: rgb[2])
        }
    }
    var cgColor: CGColor? {
        get {
            return self.rgbColor.cgColor
        }
    }
    var uiColor: UIColor? {
        get {
            return self.rgbColor.uiColor
        }
    }
    init(rgbColor: RGBColor) {
        let r = rgbColor.red
        let g = rgbColor.green
        let b = rgbColor.blue
        let maxv = max(r, g, b)
        let minv = min(r, g, b)
        let dis = maxv - minv
        var h: CGFloat = 0
        if (maxv == minv) {
            h = 0
        } else if (maxv == r && g >= b) {
            h = 60 * (g - b) / dis
        } else if (maxv == r && g < b) {
            h = 60 * (g - b) / dis + 360
        } else if (maxv == g) {
            h = 60 * (b - r) / dis + 120
        } else if (maxv == b) {
            h = 60 * (r - g) / dis + 240
        }
//        var l = (maxv + minv) / 2
//        var s = CGFloat(0)
//        if (l == 0 || maxv == minv) {
//            s = 0
//        } else if (l > 0 || l <= 0.5) {
//            s = dis / (2*l)
//        } else if (l > 0.5) {
//            s = dis / (2 - 2*l)
//        }
        let s = maxv == 0 ? 0 : 1 - minv/maxv
        let v = maxv
        self.hue = h
        self.saturation = s
        self.value = v
    }
    convenience init(cgColor: CGColor) {
        self.init(rgbColor: RGBColor(cgColor: cgColor))
    }
}

class HSLColor {
    var hue: CGFloat
    var saturation: CGFloat
    var lightness: CGFloat
    var rgbColor: RGBColor {
        get {
            let l = self.lightness
            let s = self.saturation
            if (s == 0) {
                return RGBColor(red: l, green: l, blue: l)
            }
            let q = l < 0.5 ? l * (1 + s) : l + s - l * s
            let p = 2 * l - q
            let h = self.hue / CGFloat(360)
            let fmod = { (x: CGFloat, mod: CGFloat) -> CGFloat in return x - floor(x/mod) }
            let chooseColor = { (tc: CGFloat) -> CGFloat in
                if (tc < 1/6.0) {
                    return p + ((q - p) * 6 * tc )
                } else if (tc < 1/2.0) {
                    return q
                } else if (tc < 2/3.0) {
                    return p + ((q - p) * 6 * (2/3.0 - tc) )
                } else {
                    return p
                }
            }
            let rgbarr = [h + 1/3.0, h, h - 1/3.0].map({ (tc:CGFloat) -> CGFloat in chooseColor(fmod(tc, 1.0)) })
            return RGBColor(red: rgbarr[0], green: rgbarr[1], blue: rgbarr[2])
        }
    }
    var cgColor: CGColor? {
        get {
            return self.rgbColor.cgColor
        }
    }
    var uiColor: UIColor? {
        get {
            return self.rgbColor.uiColor
        }
    }
    init(rgbColor: RGBColor) {
        let r = rgbColor.red
        let g = rgbColor.green
        let b = rgbColor.blue
        let maxv = max(r, g, b)
        let minv = min(r, g, b)
        let dis = maxv - minv
        var h: CGFloat = 0
        if (maxv == minv) {
            h = 0
        } else if (maxv == r && g >= b) {
            h = 60 * (g - b) / dis
        } else if (maxv == r && g < b) {
            h = 60 * (g - b) / dis + 360
        } else if (maxv == g) {
            h = 60 * (b - r) / dis + 120
        } else if (maxv == b) {
            h = 60 * (r - g) / dis + 240
        }
        let l = (maxv + minv) / 2
        let s: CGFloat
        if (l == 0 || maxv == minv) {
            s = 0
        } else if (l > 0 || l <= 0.5) {
            s = dis / (2*l)
        } else if (l > 0.5) {
            s = dis / (2 - 2*l)
        } else {
            s = 0
        }
        self.hue = h
        self.saturation = s
        self.lightness = l
    }
    convenience init(cgColor: CGColor) {
        self.init(rgbColor: RGBColor(cgColor: cgColor))
    }
}
