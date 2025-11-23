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
        Text("Hello, \(UserDefaults.standard.string(forKey: "customerId")!)!")
    }
}
