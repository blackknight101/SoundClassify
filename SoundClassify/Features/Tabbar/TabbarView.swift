//
//  TabbarView.swift
//  SnoreDetect
//
//  Created by Nguyen Hoang Tam on 15/12/25.
//

import SwiftUI

struct TabbarView: View {
    var body: some View {
        TabView {
            HomeView().tabItem {
                Label("Home", systemImage: "house")
            }
            
            SettingsView().tabItem {
                Label("Settings", systemImage: "gear")
            }
        }
    }
}

#Preview {
    TabbarView()
}
