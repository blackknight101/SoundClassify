//
//  SoundClassifyView.swift
//  SoundClassify
//
//  Created by Nguyen Hoang Tam on 15/12/25.
//

import SwiftUI

struct SoundClassifyView: View, Equatable {
    let sound: SoundClassify
    
    var body: some View {
        HStack {
            Image(systemName: "waveform")
            VStack(alignment: .leading, spacing: .space4) {
                Text(sound.name)
                    .font(.headline)
                    .foregroundStyle(.textPrimary)
                Text(sound.id)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Text(String(format: "%0.1f", sound.confidence))
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.sound.id == rhs.sound.id
    }
}
