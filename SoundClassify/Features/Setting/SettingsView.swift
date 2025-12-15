//
//  SettingView.swift
//  SnoreDetect
//
//  Created by Nguyen Hoang Tam on 15/12/25.
//

import SwiftUI

struct SettingsView: View {
    private let termLink = "https://example.com/terms"
    private let policyLink = "https://example.com/policy"
    
    var body: some View {
        NavigationStack {
            VStack(spacing: .space8) {
                Spacer()
                if let term = URL(string: termLink) {
                    Link("Terms", destination: term)
                        .accessibilityLabel("Term of service")
                }
                
                if let policy = URL(string: policyLink) {
                    Link("Policy", destination: policy)
                        .accessibilityLabel("Privacy policy")
                }
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .foregroundColor(Color.textPrimary)
            .background(Color.backgroundPrimay)
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    SettingsView()
}
