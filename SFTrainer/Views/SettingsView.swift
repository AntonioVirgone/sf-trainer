//
//  SettingsView.swift
//  SFTrainer
//
//  Created by Antonio Virgone on 03/12/25.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var vm: TrainerViewModel

    var body: some View {
        VStack {
            Text("Settings")
            Button(action: {
                UserDefaults.standard.removeObject(forKey: "isLoggedIn")
                vm.removeTrainer()
            }) {
                Text("logout")
            }
        }
    }
}
