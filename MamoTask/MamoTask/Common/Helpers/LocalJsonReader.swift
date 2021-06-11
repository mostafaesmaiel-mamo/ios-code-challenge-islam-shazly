//
//  LocalJsonReader.swift
//  BackbaseCodeChallenge
//
//  Created by islam Elshazly on 24/07/2020.
//  Copyright © 2020 Islam Elshazly. All rights reserved.
//

import Foundation

final class LocalJsonReader {
    
    class func  loadJson(name: String, bundle: Bundle = .main) -> Data {
        guard let pathString = bundle.path(forResource: name, ofType: "json") else {
            fatalError("json not found")
        }
        
        guard let jsonString = try? NSString(contentsOfFile: pathString, encoding: String.Encoding.utf8.rawValue) else {
            fatalError("Unable to convert json to String")
        }
        
        guard let jsonData = jsonString.data(using: String.Encoding.utf8.rawValue) else {
            fatalError("Unable to convert json to NSData")
        }
        
        return jsonData
    }
    
}
