//
//  HomeViewModel.swift
//  SoundClassify
//
//  Created by Nguyen Hoang Tam on 15/12/25.
//

import Combine
import AVFAudio

@MainActor
final class HomeViewModel: ObservableObject {
    enum State: Equatable {
        case none, ready, noPermission, error(String), detecting
    }
    
    @Published var sounds: [SoundClassify] = []
    @Published var state: State = .none
    
    private let audioAnalyzer: AudioAnalyzer
    private var analysisTask: Task<Void, Never>?
    
    init(audioAnalyzer: AudioAnalyzer) {
        self.audioAnalyzer = audioAnalyzer
        Task { [weak self] in
            let isGranted = await self?.initPermission()
            guard let isGranted else { return }
            await MainActor.run { [weak self] in
                self?.state = isGranted ? .ready : .noPermission
            }
        }
    }
    
    private func initPermission() async -> Bool {
        let session = AVAudioSession.sharedInstance()
        let permissionGranted: Bool
        
        switch session.recordPermission {
        case .undetermined:
            permissionGranted = await withCheckedContinuation { continuation in
                session.requestRecordPermission { granted in
                    continuation.resume(returning: granted)
                }
            }
        case .denied:
            permissionGranted = false
        case .granted:
            permissionGranted = true
        @unknown default:
            permissionGranted = false
        }
        
        return permissionGranted
    }
    
    func startDetecting() {
        guard state == .ready else { return }
        
        state = .detecting
        analysisTask?.cancel()
        analysisTask = Task.detached { [weak self] in
            guard let self else { return }
            do {
                try await audioAnalyzer.startAnalysis()
            } catch {
                await MainActor.run {
                    self.state = .error(error.localizedDescription)
                }
                return
            }
            
            for await event in await audioAnalyzer.events {
                switch event {
                case let .classification(identifier, confidence):
                    await MainActor.run {
                        let item = SoundClassify(
                            id: UUID().uuidString,
                            name: identifier,
                            confidence: confidence
                        )
                        self.sounds.insert(item, at: 0)
                    }
                }
            }
        }
    }
    
    func stopDetecting() {
        guard state == .detecting else { return }
        state = .ready
        analysisTask?.cancel()
        analysisTask = nil
    }
}
