//
//  ClientsListView.swift
//  SFTrainer
//
//  Created by Antonio Virgone on 23/11/25.
//

import Foundation
import SwiftUI

struct ClientsListView: View {
    @EnvironmentObject var auth: UserApiService
    
    var body: some View {
        VStack {
            Text("Hello, \(UserDefaults.standard.string(forKey: "customerId")!)!")
            Button(action: {
                UserDefaults.standard.removeObject(forKey: "customerId")
                UserDefaults.standard.removeObject(forKey: "accessToken")
            }, label: {
                Text("Logout")
            })
        }
    }
}
