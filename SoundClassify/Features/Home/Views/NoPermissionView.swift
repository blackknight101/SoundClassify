//
//  NoPermissionView.swift
//  SoundClassify
//
//  Created by Nguyen Hoang Tam on 15/12/25.
//

import SwiftUI

struct NoPermissionView: View {
    var body: some View {
        VStack(spacing: .space8) {
            Text("Microphone permission is denied. Please enable it in Settings to start detecting.")
                .font(.footnote)
                .foregroundStyle(.red)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
    }
}
