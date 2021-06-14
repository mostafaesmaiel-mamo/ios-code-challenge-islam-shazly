//
//  StoryBoardConstants.swift
//  Mamo
//
//

import Foundation

extension Constant {
    enum StoryBoard: String, StoryboardNameProtocol {
        case Contacts
        
        var name: String {
            return self.rawValue.capitalized
        }
    }
    
        enum UnitTesting {
            static let frequent = "frequents"
            static let mamoAccounts = "mamoAccounts"
        }
}
