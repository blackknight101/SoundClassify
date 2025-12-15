//
//  EmptyStateView.swift
//  SoundClassify
//
//  Created by Nguyen Hoang Tam on 15/12/25.
//

import SwiftUI

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: .space12) {
            Spacer()
            Image(systemName: "waveform.slash")
                .font(.largeTitle)
                .foregroundStyle(.secondary)
            Text("No sounds yet")
                .font(.headline)
            Text("Start detecting to see classified sounds here.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
