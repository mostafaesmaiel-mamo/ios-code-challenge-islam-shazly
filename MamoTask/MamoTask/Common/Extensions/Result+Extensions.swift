//
//  Result+Extensions.swift
//  
//
//  Created by Hazem Ahmed on 22.11.20.
//

import Foundation

extension Result where Success == Void {
    public static var success: Result {
        return .success(())
    }
}
