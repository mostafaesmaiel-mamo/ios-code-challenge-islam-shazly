//
//  Bundle+Extensions.swift
//  
//
//  Created by Hazem Ahmed on 15.11.20.
//

import Foundation

public extension Bundle {
    
    class func loadJsonFile(fileName: String) -> Data? {
        
        guard let path = Bundle.main.path(forResource: fileName, ofType: "json") else { return nil }
        guard let data = NSData(contentsOfFile: path) else { return nil }
        return Data(referencing: data)
    }
    
}
