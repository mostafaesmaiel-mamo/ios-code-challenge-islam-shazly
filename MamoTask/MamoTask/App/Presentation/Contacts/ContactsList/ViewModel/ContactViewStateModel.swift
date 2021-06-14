//
//  ContactViewModel.swift
//  Mamo
//
//

import UIKit

struct ContactViewStateModel {
    
    var id: String
    var key: String
    var value: String
    var name: String?
    var isMamoAccount: Bool
    var isFrequent: Bool
    var image: UIImage?
    var isSelected: Bool = false
    var prefixName: String? {
        guard let prefix = name else {
            return nil
        }
        return prefix.components(separatedBy: " ").map { String($0.prefix(1))}.joined()
    }
}
