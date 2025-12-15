//
//  SoundClassify.swift
//  SoundClassify
//
//  Created by Nguyen Hoang Tam on 15/12/25.
//

import Foundation
@preconcurrency import SoundAnalysis
import Accelerate

enum AudioAnalyzerError: Error {
    case modelError
}

enum AudioAnalysisEvent {
    case classification(identifier: String, confidence: Double)
}

final class AudioAnalyzer: NSObject {
    private let minConfidence: Double = 0.6
    private let analysisQueue = DispatchQueue(label: "com.devswift.analysis_queue")

    private var eventContinuation: AsyncStream<AudioAnalysisEvent>.Continuation
    public private(set) var events: AsyncStream<AudioAnalysisEvent>

    private var audioEngine: AVAudioEngine?
    private var streamAnalyzer: SNAudioStreamAnalyzer?
    
    override init() {
        let (stream, continuation) = AsyncStream.makeStream(of: AudioAnalysisEvent.self)
        self.eventContinuation = continuation
        self.events = stream
        super.init()
    }

    func startAnalysis() throws {
        try startAudioSession()
        let newAudioEngine = AVAudioEngine()
        audioEngine = newAudioEngine
        let inputFormat = newAudioEngine.inputNode.inputFormat(forBus: 0)
        self.streamAnalyzer = SNAudioStreamAnalyzer(format: inputFormat)
        
        newAudioEngine.inputNode.installTap(onBus: 0,
                                            bufferSize: 4096,
                                            format: inputFormat,
                                            block: analyzeAudio(buffer:at:))
        
        let request = try SNClassifySoundRequest(classifierIdentifier: .version1)
        try streamAnalyzer?.add(request, withObserver: self)
        
        try newAudioEngine.start()
    }
    
    private func startAudioSession() throws {
        let session = AVAudioSession.sharedInstance()
        try session.setCategory(
            .playAndRecord,
            options: [
                .defaultToSpeaker,
                .mixWithOthers,
                .allowBluetoothHFP,
                .allowBluetoothA2DP]
        )
    }

    private func analyzeAudio(buffer: AVAudioPCMBuffer, at: AVAudioTime) {
        let stream = streamAnalyzer
        analysisQueue.async {
            stream?.analyze(buffer,
                           atAudioFramePosition: at.sampleTime)
        }
    }
}

extension AudioAnalyzer: SNResultsObserving {
    func request(_ request: SNRequest, didProduce result: SNResult) {
        guard let classificationResult = result as? SNClassificationResult else { return }
        let topClassification = classificationResult.classifications
            .sorted { $0.confidence > $1.confidence }.first

        let prediction = topClassification?.identifier
        let confidence = topClassification?.confidence
        
        guard let prediction, let confidence, confidence > minConfidence else { return }
        eventContinuation.yield(.classification(identifier: prediction,
                                                confidence: confidence))
    }

    func request(_ request: SNRequest, didFailWithError error: Error) {
    }

    func requestDidComplete(_ request: SNRequest) {
    }
}
