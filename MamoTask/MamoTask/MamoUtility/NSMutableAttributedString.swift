//
//  NSMutableAttributedString.swift
//  
//

//

import UIKit
import Foundation

// MARK: - Color

public extension NSMutableAttributedString {
    
    static func colored(inText text: String,
                        color: UIColor,
                        afterOcurrence occurence: String) -> NSMutableAttributedString {
        let attrStr = NSMutableAttributedString(string: text)
        attrStr.color(color, afterOcurrence: occurence)
        return attrStr
    }
    
    static func colored(inText text: String,
                        color: UIColor,
                        occurences searchString: String) -> NSMutableAttributedString {
        let attrStr = NSMutableAttributedString(string: text)
        attrStr.color(color, occurences: searchString)
        return attrStr
    }
    
    func color(_ color: UIColor,
               afterOcurrence occurence: String) {
        let range = NSRange(text: string, afterOccurence: occurence)
        if range.location != NSNotFound {
            addColorAttribute(value: color, range: range)
        }
    }
    
    func color(_ color: UIColor, occurences searchString: String) {
        addAttribute(forOccurence: searchString, value: color, addAttributeMethod: addColorAttribute)
    }
    
}

// MARK: - Strike

public extension NSMutableAttributedString {
    
    static func struck(inText text: String, afterOcurrence occurence: String) -> NSMutableAttributedString {
        let attrStr = NSMutableAttributedString(string: text)
        attrStr.strike(afterOcurrence: occurence)
        return attrStr
    }
    
    static func struck(inText text: String, occurences searchString: String) -> NSMutableAttributedString {
        let attrStr = NSMutableAttributedString(string: text)
        attrStr.strike(occurences: searchString)
        return attrStr
    }
    
    func strike(afterOcurrence occurence: String) {
        let range = NSRange(text: string, afterOccurence: occurence)
        if range.location != NSNotFound {
            addStrikeAttribute(range: range)
        }
    }
    
    func strike(occurences searchString: String) {
        addAttribute(forOccurence: searchString, addAttributeMethod: addStrikeAttribute)
    }
    
}

// MARK: - Underline

public extension NSMutableAttributedString {
    
    static func underlined(inText text: String, afterOcurrence occurence: String) -> NSMutableAttributedString {
        let attrStr = NSMutableAttributedString(string: text)
        attrStr.underline(afterOcurrence: occurence)
        return attrStr
    }
    
    static func underlined(inText text: String, occurences searchString: String) -> NSMutableAttributedString {
        let attrStr = NSMutableAttributedString(string: text)
        attrStr.underline(occurences: searchString)
        return attrStr
    }
    
    func underline(afterOcurrence occurence: String) {
        let range = NSRange(text: string, afterOccurence: occurence)
        if range.location != NSNotFound {
            addUnderlineAttribute(range: range)
        }
    }
    
    func underline(occurences searchString: String) {
        addAttribute(forOccurence: searchString, addAttributeMethod: addStrikeAttribute)
    }
    
}

// MARK: - Font

public extension NSMutableAttributedString {
    
    static func font(inText text: String,
                     font: UIFont,
                     afterOcurrence occurence: String) -> NSMutableAttributedString {
        let attrStr = NSMutableAttributedString(string: text)
        attrStr.font(font, afterOcurrence: occurence)
        return attrStr
    }
    
    static func font(inText text: String,
                     font: UIFont,
                     occurences searchString: String) -> NSMutableAttributedString {
        let attrStr = NSMutableAttributedString(string: text)
        attrStr.font(font, occurences: searchString)
        return attrStr
    }
    
    func font(_ font: UIFont, afterOcurrence occurence: String) {
        let range = NSRange(text: string, afterOccurence: occurence)
        if range.location != NSNotFound {
            addFontAttribute(value: font, range: range)
        }
    }
    
    func font(_ font: UIFont, occurences searchString: String) {
        addAttribute(forOccurence: searchString, value: font, addAttributeMethod: addFontAttribute)
    }
    
}

// MARK: - Private

private extension NSMutableAttributedString {
    
    func addColorAttribute(value: Any, range: NSRange) {
        addAttribute(.foregroundColor, value: value, range: range)
    }
    
    func addStrikeAttribute(value: Any = 1, range: NSRange) {
        addAttribute(.strikethroughStyle, value: value, range: range)
    }
    
    func addUnderlineAttribute(value: Any = 1, range: NSRange) {
        addAttribute(.underlineStyle, value: value, range: range)
    }
    
    func addFontAttribute(value: Any = 1, range: NSRange) {
        addAttribute(.font, value: value, range: range)
    }
    
    func addAttribute(forOccurence searchString: String,
                      value: Any = 1,
                      addAttributeMethod: ((_ value: Any, _ range: NSRange) -> Void)) {
        let inputLength = string.count
        let searchLength = searchString.count
        var range = NSRange(location: 0, length: length)
        while range.location != NSNotFound {
            range = (string as NSString).range(of: searchString, options: [], range: range)
            if range.location != NSNotFound {
                addAttributeMethod(value, NSRange(location: range.location, length: searchLength))
                range = NSRange(location: range.location + range.length,
                                length: inputLength - (range.location + range.length))
            }
        }
    }
    
}
