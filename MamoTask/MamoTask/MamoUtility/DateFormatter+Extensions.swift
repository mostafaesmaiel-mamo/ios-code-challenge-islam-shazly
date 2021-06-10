//
//  DateFormatter+Extensions.swift
//  
//

//

import Foundation

public extension DateFormatter {
    
    static var fanniParserFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let local = Locale(identifier: "en_US")
        formatter.locale = local
        return formatter
    }
    
    static var fanniSenderFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let local = Locale(identifier: "en_US")
        formatter.locale = local
        return formatter
    }
    
    static var fanniFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let local = Locale(identifier: "en_US")
        formatter.locale = local
        return formatter
    }
    
    func buildFormatter(locale: Locale,
                        hasRelativeDate: Bool = false,
                        dateFormat: String? = "yyyy-MM-dd'T'HH:mm:ss.SSSZ") -> DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateStyle = .medium
        if let dateFormat = dateFormat { formatter.dateFormat = dateFormat }
        formatter.doesRelativeDateFormatting = hasRelativeDate
        formatter.locale = locale
        return formatter
    }
    
    func buildDateFormatter(locale: Locale,
                            hasRelativeDate: Bool = false,
                            dateFormat: String? = "yyyy-MM-dd'T'HH:mm:ss.SSSZ") -> DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .medium
        if let dateFormat = dateFormat { formatter.dateFormat = dateFormat }
        formatter.doesRelativeDateFormatting = hasRelativeDate
        formatter.locale = locale
        return formatter
    }
    
    func buildTimeFormatter(locale: Locale,
                            hasRelativeDate: Bool = false,
                            dateFormat: String? = "yyyy-MM-dd'T'HH:mm:ss.SSSZ") -> DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .none
        if let dateFormat = dateFormat { formatter.dateFormat = dateFormat }
        formatter.doesRelativeDateFormatting = hasRelativeDate
        formatter.locale = locale
        return formatter
    }
    
    func dateFormatterToString(_ formatter: DateFormatter = fanniParserFormatter, _ date: Date) -> String {
        return formatter.string(from: date)
    }
    
}
