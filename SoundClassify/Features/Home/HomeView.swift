//
//  HomeView.swift
//  SnoreDetect
//
//  Created by Nguyen Hoang Tam on 15/12/25.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel: HomeViewModel
    
    init() {
        _viewModel = .init(wrappedValue: .init(audioAnalyzer: AudioAnalyzer()))
    }
    
    var body: some View {
        NavigationStack {
            Group {
                switch viewModel.state {
                case .ready, .detecting:
                    contentView
                case .noPermission:
                    NoPermissionView()
                case .none:
                    loadingView
                case .error(let message):
                    errorView(message)
                }
            }
            .safeAreaInset(edge: .bottom) { bottomControl }
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    @ViewBuilder
    private var contentView: some View {
        if viewModel.sounds.isEmpty {
            EmptyStateView()
        } else {
            listView
        }
    }
    
    private var listView: some View {
        List(viewModel.sounds, id: \.id) { sound in
            SoundClassifyView(sound: sound)
                .transition(.move(edge: .top).combined(with: .opacity))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    @ViewBuilder
    private var bottomControl: some View {
        if viewModel.state == .detecting ||
            viewModel.state == .ready {
            Button {
                if viewModel.state == .detecting {
                    viewModel.stopDetecting()
                } else {
                    viewModel.startDetecting()
                }
            } label: {
                Text(viewModel.state == .detecting ? "Stop" : "Start")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, .space12)
            }
            .contentShape(.rect)
            .background(
                viewModel.state == .detecting ? Color.red : Color.accentColor,
                in: .capsule
            )
            .foregroundStyle(.white)
            .padding(.horizontal)
            .padding(.vertical, .space8)
        }
    }
}

private extension HomeView {
    var loadingView: some View {
        VStack {
            Spacer()
            ProgressView()
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    func errorView(_ message: String) -> some View {
        Text(message)
            .font(.footnote)
            .foregroundStyle(.red)
            .multilineTextAlignment(.center)
            .padding(.horizontal)
    }
}

#Preview {
    HomeView()
}
