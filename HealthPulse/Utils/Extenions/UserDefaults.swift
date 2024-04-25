//
//  UserDefaults.swift
//  HealthPulse
//
//  Created by Leon Grimmeisen on 25.04.24.
//

import Foundation

extension UserDefaults {
    func setCodableObject<T: Codable>(_ value: T?, forKey key: String) {
        let jsonEncoder = JSONEncoder()
        if let encoded = try? jsonEncoder.encode(value) {
            set(encoded, forKey: key)
        }
    }
    
    func codableObject<T: Codable>(forKey key: String, as type: T.Type) -> T? {
        if let data = object(forKey: key) as? Data {
            let jsonDecoder = JSONDecoder()
            return try? jsonDecoder.decode(type, from: data)
        }
        return nil
    }
}
