//
//  UIDevice+Extensions.swift
//  
//

//

import UIKit

// MARK: - Device information

public extension UIDevice {

    class var idForVendor: String? {
        return UIDevice.current.identifierForVendor?.uuidString
    }

    class func systemName() -> String {
        return UIDevice.current.systemName
    }

    class func systemVersion() -> String {
        return UIDevice.current.systemVersion
    }

    class var deviceName: String {
        return UIDevice.current.name
    }

    class var deviceLanguage: String {
        return Bundle.main.preferredLocalizations[0]
    }

    class var isPhone: Bool {
        return UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone
    }

    class var isPad: Bool {
        return UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad
    }

}

// MARK: - Version

public extension UIDevice {

    class func isVersion(_ version: Float) -> Bool {
        return systemFloatVersion >= version && systemFloatVersion < (version + 1.0)
    }

    class func isVersionOrLater(_ version: Float) -> Bool {
        return systemFloatVersion >= version
    }

    class func isVersionOrEarlier(_ version: Float) -> Bool {
        return systemFloatVersion < (version + 1.0)
    }

    private class var systemFloatVersion: Float {
        return (systemVersion() as NSString).floatValue
    }

}
