//
//  UserApiService.swift
//  SmartFit
//
//  Created by Antonio Virgone on 16/11/25.
//

import Foundation
internal import Combine

@MainActor
class UserApiService: ObservableObject {
    @Published var customerId: String? = nil
    @Published var token: String? = nil
    
    var isLoggedIn: Bool {
        UserDefaults.standard.string(forKey: "accessToken") != nil
    }
    
    func login(username: String, password: String) async -> Bool {
        struct LoginBody: Encodable {
            let username: String
            let password: String
        }
        
        print("username \(username) - password \(password)")
        
        struct LoginResponse: Decodable {
            let customerId: String?
            let accessToken: String
            let refreshToken: String
        }
        
        do {
            let result: LoginResponse = try await APIService2.shared.request(
                "auth/login",
                method: "POST",
                body: LoginBody(username: username, password: password)
            )
            
            customerId = result.customerId
            token = result.accessToken

            UserDefaults.standard.set(customerId, forKey: "customerId")
            UserDefaults.standard.set(token, forKey: "accessToken")

            return true
        } catch {
            print("Login error:", error)
            return false
        }
    }
}

class UserResponse: Codable {
    var customerId: String
    var accessToken: String
    var refreshToken: String
}
