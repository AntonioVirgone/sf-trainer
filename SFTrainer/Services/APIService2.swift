//
//  APIService.swift
//  SmartFit
//
//  Created by Antonio Virgone on 10/11/25.
//

import Foundation
internal import Combine

class APIService2 {
    static let shared = APIService2()
    private init() {}
    
    private let baseURL = URL(string: "https://smart-fit-api.onrender.com/api")!
    
    func request<T: Decodable>(_ path: String,
                               method: String = "GET",
                               body: Encodable? = nil,
                               token: String? = nil) async throws -> T {
        
        var request = URLRequest(
            url: baseURL.appendingPathComponent(path)
        )
        request.httpMethod = method
        
        if let token = token {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        if let body = body {
            request.httpBody = try JSONEncoder().encode(body)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        // 🔍 stampa la risposta in formato leggibile
        if let jsonString = String(data: data, encoding: .utf8) {
            print("RESPONSE JSON:\n\(jsonString)")
        }
        
        return try JSONDecoder().decode(T.self, from: data)
    }
}
