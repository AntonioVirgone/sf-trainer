//
//  PingService.swift
//  SFTrainer
//
//  Created by Antonio Virgone on 03/12/25.
//

import Foundation

class PingService {
    private let url = URL(string: "http://localhost:3000/api/health")!  // endpoint fittizio

    func wakeServer() async {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 5  // Render potrebbe essere lento appena sveglio

        do {
            let _ = try await URLSession.shared.data(for: request)
            print("🌐 Server Render svegliato!")
        } catch {
            print("⚠️ Ping fallito, ma continuo comunque:", error.localizedDescription)
        }
    }
}
