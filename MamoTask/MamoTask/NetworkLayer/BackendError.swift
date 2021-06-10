//
//  BackendError.swift
//
//

import Foundation

public struct BackendError: Error, Codable {
    
    // MARK: - Properties
    
    public var message: String?
    public var businessCode: String?
    public var messageEn: String?
    public var status: Int?
    public var code: Int?
    
    // MARK: - CodingKeys
    
    enum CodingKeys: String, CodingKey {
        case message
        case businessCode = "code"
        case messageEn
        case status
        case error
    }
    
    // MARK: - Init
    
    public init(error: NSError) {
        message = error.localizedDescription
        code = error.code
    }
    
    public init(error: Error) {
        self.init(error: error as NSError)
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let errorKeys = try? values.nestedContainer(keyedBy: CodingKeys.self, forKey: .error)
        
        message = try? values.decode(String.self, forKey: .message)
        messageEn = try? values.decode(String.self, forKey: .messageEn)
        businessCode = try? values.decode(String.self, forKey: .businessCode)
        status = try? errorKeys?.decode(Int.self, forKey: .status)
    }
    
    // MARK: - Encode
    
    public func encode(to encoder: Encoder) throws {}
    
    // MARK: - Helper
    
    public func isValidError() -> Bool {
        return message?.isEmpty == false || messageEn?.isEmpty == false
    }
}
