//
//  CodeEditor+Theme.swift
//  LindDE
//
//  Created by fridakitten on 05.05.25.
//

import UIKit
import Runestone

enum HighlightName: String {
    case comment
    case constantBuiltin = "constant.builtin"
    case constantCharacter = "constant.character"
    case constructor
    case function
    case keyword
    case number
    case `operator`
    case property
    case punctuation
    case string
    case type
    case variable
    case variableBuiltin = "variable.builtin"
    case tag

    init?(_ rawHighlightName: String) {
        var comps = rawHighlightName.split(separator: ".")
        while !comps.isEmpty {
            let candidateRawHighlightName = comps.joined(separator: ".")
            if let highlightName = Self(rawValue: candidateRawHighlightName) {
                self = highlightName
                return
            }
            comps.removeLast()
        }
        return nil
    }
}


///
/// Functions to encode and decode Color as RGB String
///

func gibDynamicColor(light: UIColor, dark: UIColor) -> UIColor {
    return UIColor(dynamicProvider: { traits in
        switch traits.userInterfaceStyle {
        case .light, .unspecified:
            return light
            
        case .dark:
            return dark
            
        @unknown default:
            assertionFailure("Unknown userInterfaceStyle: \(traits.userInterfaceStyle)")
            return light
        }
    })
}

extension UIColor {
    convenience init(light: (CGFloat, CGFloat, CGFloat), dark: (CGFloat, CGFloat, CGFloat), alpha: Double = 1.0) {
        let light: UIColor = neoRGB(light.0, light.1, light.2).withAlphaComponent(alpha)
        let dark: UIColor = neoRGB(dark.0, dark.1, dark.2).withAlphaComponent(alpha)
        
        self.init(dynamicProvider: { traits in
            switch traits.userInterfaceStyle {
            case .light, .unspecified:
                return light
                
            case .dark:
                return dark
                
            @unknown default:
                assertionFailure("Unknown userInterfaceStyle: \(traits.userInterfaceStyle)")
                return light
            }
        })
    }
}

///
/// List of Themes
///
var themes: [LindDEThemer] = [
    LindDEThemer(),
    SolarizedThemer()
]

func getCurrentSelectedTheme() -> LindDEThemer
{
    let selected: Int = {
        if UserDefaults.standard.object(forKey: "LDETheme") == nil {
            UserDefaults.standard.set(0, forKey: "LDETheme")
        }
        
        return UserDefaults.standard.integer(forKey: "LDETheme")
    }()
    
    return themes[(selected > (themes.count - 1)) ? 0 : selected]
}

///
/// NyxianLDE
///
class LindDEThemer: Theme {
    var fontSize: CGFloat = CGFloat(UserDefaults.standard.double(forKey: "CEFontSize"))
    
    var font: UIFont {
        return UIFont.monospacedSystemFont(ofSize: fontSize, weight: .medium)
    }
    
    var lineNumberFont: UIFont {
        return UIFont.monospacedSystemFont(ofSize: fontSize * 0.85, weight: .regular)
    }
    
    var textColor: UIColor = UIColor(light: (30, 30, 30), dark: (232, 242, 255))
    var backgroundColor: UIColor = UIColor(light: (250, 250, 250), dark: (30, 30, 30))
    
    var gutterBackgroundColor: UIColor = UIColor(light: (240, 240, 240), dark: (25, 25, 25))
    var gutterHairlineColor: UIColor = UIColor(light: (220, 220, 220), dark: (50, 50, 50))
    
    var lineNumberColor: UIColor = UIColor(light: (180, 180, 180), dark: (90, 90, 90))
    
    var selectedLineBackgroundColor: UIColor = UIColor(light: (220, 230, 250), dark: (40, 44, 52), alpha: 0.8)
    var selectedLinesLineNumberColor: UIColor = UIColor(light: (80, 120, 180), dark: (130, 180, 255))
    var selectedLinesGutterBackgroundColor: UIColor = UIColor(light: (235, 235, 240), dark: (20, 20, 25))
    
    var invisibleCharactersColor: UIColor {
        return textColor.withAlphaComponent(0.25)
    }
    
    var pageGuideHairlineColor: UIColor = UIColor(light: (220, 220, 230), dark: (45, 45, 50))
    var pageGuideBackgroundColor: UIColor = UIColor(light: (245, 245, 250), dark: (30, 30, 35))
    
    var markedTextBackgroundColor: UIColor = UIColor(light: (230, 240, 250), dark: (60, 60, 70))
    var colorKeyword: UIColor = UIColor(light: (0, 0, 192), dark: (86, 156, 214))
    var colorComment: UIColor = UIColor(light: (0, 128, 0), dark: (106, 153, 85))
    var colorString: UIColor = UIColor(light: (163, 21, 21), dark: (206, 145, 120))
    var colorNumber: UIColor = UIColor(light: (128, 0, 128), dark: (181, 206, 168))
    var colorRegex: UIColor = UIColor(light: (255, 140, 0), dark: (255, 198, 109))
    var colorFunction: UIColor = UIColor(light: (43, 145, 175), dark: (220, 220, 170))
    var colorOperator: UIColor = UIColor(light: (0, 0, 0), dark: (212, 212, 212))
    var colorProperty: UIColor = UIColor(light: (0, 0, 128), dark: (156, 220, 254))
    var colorPunctuation: UIColor = UIColor(light: (50, 50, 50), dark: (200, 200, 200))
    var colorDirective: UIColor = UIColor(light: (60, 60, 60), dark: (255, 165, 0))
    var colorType: UIColor = UIColor(light: (43, 43, 150), dark: (78, 201, 176))
    var colorConstantBuiltin: UIColor = UIColor(light: (75, 0, 130), dark: (0, 255, 255))
    
    func textColor(for highlightName: String) -> UIColor? {
        guard let highlightName = HighlightName(highlightName) else {
            return nil
        }
        switch highlightName {
        case .keyword:
            return colorKeyword
        case .constantBuiltin:
            return colorConstantBuiltin
        case .number:
            return colorNumber
        case .comment:
            return colorComment
        case .operator:
            return colorOperator
        case .string:
            return colorString
        case .function, .variable:
            return colorFunction
        case .property:
            return colorProperty
        case .punctuation:
            return colorPunctuation
        case .type:
            return colorType
        case .tag:
            return colorString
        default:
            return textColor
        }
    }
}

///
/// Solarized
///
class SolarizedThemer: LindDEThemer {
    override init() {
        super.init()
        textColor = UIColor(light: (40, 50, 55), dark: (220, 230, 235))
        backgroundColor = UIColor(light: (253, 246, 227), dark: (7, 54, 66))
        
        gutterBackgroundColor = UIColor(light: (238, 232, 213), dark: (0, 43, 54))
        gutterHairlineColor = UIColor(light: (220, 210, 180), dark: (88, 110, 117))
        lineNumberColor = UIColor(light: (147, 161, 161), dark: (88, 110, 117))
        
        selectedLineBackgroundColor = UIColor(light: (238, 232, 213), dark: (17, 59, 67), alpha: 0.8)
        selectedLinesLineNumberColor = UIColor(light: (38, 139, 210), dark: (42, 161, 152))
        selectedLinesGutterBackgroundColor = UIColor(light: (248, 243, 227), dark: (0, 43, 54))
        
        pageGuideHairlineColor = UIColor(light: (220, 220, 210), dark: (88, 110, 117))
        pageGuideBackgroundColor = UIColor(light: (250, 250, 235), dark: (0, 50, 60))
        
        markedTextBackgroundColor = UIColor(light: (253, 246, 227), dark: (0, 50, 60))
        
        colorKeyword = UIColor(light: (133, 153, 0), dark: (181, 137, 0))
        colorComment = UIColor(light: (147, 161, 161), dark: (88, 110, 117))
        colorString = UIColor(light: (42, 161, 152), dark: (42, 161, 152))
        colorNumber = UIColor(light: (211, 54, 130), dark: (211, 54, 130))
        colorRegex = UIColor(light: (203, 75, 22), dark: (203, 75, 22))
        colorFunction = UIColor(light: (38, 139, 210), dark: (38, 139, 210))
        colorOperator = UIColor(light: (101, 123, 131), dark: (131, 148, 150))
        colorProperty = UIColor(light: (108, 113, 196), dark: (108, 113, 196))
        colorPunctuation = UIColor(light: (88, 110, 117), dark: (147, 161, 161))
        colorDirective = UIColor(light: (203, 75, 22), dark: (203, 75, 22))
        colorType = UIColor(light: (38, 139, 210), dark: (42, 161, 152))
        colorConstantBuiltin = UIColor(light: (211, 54, 130), dark: (133, 153, 0))
    }
}

func neoRGB(_ red: CGFloat,_ green: CGFloat,_ blue: CGFloat ) -> UIColor {
    return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: 1.0)
}
