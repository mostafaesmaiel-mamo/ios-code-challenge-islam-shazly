//
//  String+Extensions.swift
//  
//

//

import Foundation

// MARK: - Subscript

public extension String {

    subscript(integerIndex: Int) -> Character {
        return self[index(startIndex, offsetBy: integerIndex)]
    }

    subscript(integerRange: Range<Int>) -> String {
        let start = index(startIndex, offsetBy: integerRange.lowerBound)
        let end = index(startIndex, offsetBy: integerRange.upperBound)
        return String(self[start..<end])
    }

}

// MARK: - Misc

public extension String {

    func contains(_ text: String, compareOption: NSString.CompareOptions) -> Bool {
        return range(of: text, options: compareOption) != nil
    }
    
    var isValidSaudiMobileNumber: Bool {
        do {
            let regex = try NSRegularExpression(pattern: "^(9665)([0-9]{8})$", options: .caseInsensitive)
            let regular = NSRegularExpression.MatchingOptions(rawValue: 0)
            return regex.firstMatch(in: self, options: regular, range: NSMakeRange(0, self.count)) != nil
        } catch {
            return false
        }
    }
    
    var englishNumbers: String {
        let cfstr = NSMutableString(string: self) as CFMutableString
        var range = CFRange(location: 0, length: CFStringGetLength(cfstr))
        CFStringTransform(cfstr, &range, kCFStringTransformToLatin, false)
        return (cfstr as String)
    }
    
    var trimWhiteSpaces: String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    var nationalNumber: String {
        return self.trimWhiteSpaces
            .replacingOccurrences(of: "(", with: "")
            .replacingOccurrences(of: ")", with: "")
            .replacingOccurrences(of: "-", with: "")
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "+", with: "")
    }
    
    func formatMobileNumber() -> String {
        var mobile = self.trimmed()
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "(", with: "")
            .replacingOccurrences(of: ")", with: "")
            .replacingOccurrences(of: "-", with: "")
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "+", with: "")
        
        if mobile.prefix(3) == "971" {
            mobile = String(mobile.suffix(mobile.count - 3))
        }
        if mobile.prefix(1) == "0" {
            mobile = String(mobile.suffix(mobile.count - 1))
        }
        
        if mobile.prefix(3) == "(0)" {
            mobile = String(mobile.suffix(mobile.count - 3))
        }
        
        let mobileNumber = "+971" + mobile.englishNumbers
        
        return mobileNumber
    }
}

// MARK: - Validator

public extension String {

    var isNumeric: Bool {
        let hasNumbers = rangeOfCharacter(from: .decimalDigits, options: .literal, range: nil) != nil
        let hasLetters = rangeOfCharacter(from: .letters, options: .numeric, range: nil) != nil
        return hasNumbers && !hasLetters
    }

    var isEmail: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: self)
    }

}

// MARK: - Computed Properties

public extension String {

    var capitalizedFirst: String {
        let first = prefix(1).capitalized
        let other = dropFirst()
        return first + other
    }
    
    var base64: String {
        let plainData = (self as NSString).data(using: String.Encoding.utf8.rawValue)
        let base64String = plainData!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        return base64String
    }

    var URLEscapedString: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    mutating func trim() {
        self = trimmed()
    }

    mutating func truncate(limit: Int) {
        self = truncated(limit: limit)
    }

}

// MARK: - Transform

public extension String {

    func trimmed() -> String {
        return components(separatedBy: NSCharacterSet.whitespacesAndNewlines).joined()
    }

    func truncated(limit: Int) -> String {
        if count > limit {
            var truncatedString = self[0..<limit]
            truncatedString = truncatedString.appending("...")
            return truncatedString
        }
        return self
    }
    
    func toInt() -> Int? {
           if let num = NumberFormatter().number(from: self) {
               return num.intValue
           } else {
               return nil
           }
       }
       
       func toDouble() -> Double? {
           if let num = NumberFormatter().number(from: self) {
               return num.doubleValue
           } else {
               return nil
           }
       }
       
        func toFloat() -> Float? {
           if let num = NumberFormatter().number(from: self) {
               return num.floatValue
           } else {
               return nil
           }
       }
       
    func toBool() -> Bool? {
           let trimmedString = trimmed().lowercased()
           if trimmedString == "true" || trimmedString == "false" {
               return (trimmedString as NSString).boolValue
           }
           return nil
       }

}
