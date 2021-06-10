//
//  StoryBoardConstants.swift
//  Mamo
//
//

import Foundation

extension C {
    enum StoryBoard: String, StoryboardNameProtocol {
        case Contacts
        
        var name: String {
            return self.rawValue.capitalized
        }
    }
}
