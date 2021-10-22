import Foundation
import SoundAnalysis
import CoreML
import AVFAudio
import AVFoundation

class SoundClassifier {
    static let shared = SoundClassifier()
    
    let audioEngine: AVAudioEngine
    let inputBus: AVAudioNodeBus
    let inputFormat: AVAudioFormat
    let streamAnalyzer: SNAudioStreamAnalyzer
    let analysisQueue: DispatchQueue
    
    var observer: ResultsObserver?
    
    private init () {
        // Create a new audio engine.
        self.audioEngine = AVAudioEngine()

        // Get the native audio format of the engine's input bus.
        self.inputBus = AVAudioNodeBus(0)
        self.inputFormat = audioEngine.inputNode.inputFormat(forBus: inputBus)
        self.streamAnalyzer = SNAudioStreamAnalyzer(format: inputFormat)
        
        self.analysisQueue = DispatchQueue(label:"com.apple.AnalysisQueue")
    }
    
    func isRunning() -> Bool {
        return audioEngine.isRunning
    }
    
    func start(resultsObserver: ResultsObserver) {
        observer = resultsObserver
        
        do {
            // Start the stream of audio data.
            try audioEngine.start()
        } catch {
            print("Unable to start AVAudioEngine: \(error.localizedDescription)")
        }
        
        // Prepare a new request for the trained model.
        do {
            let request = try SNClassifySoundRequest(classifierIdentifier: .version1)
            /// Indicates the amount of audio, in seconds, that informs a prediction.
            request.windowDuration = CMTimeMakeWithSeconds(1.5, preferredTimescale: 48_000)
            /// The amount of overlap between consecutive analysis windows.
            ///
            /// The system performs sound classification on a window-by-window basis. The system divides an
            /// audio stream into windows, and assigns labels and confidence values. This value determines how
            /// much two consecutive windows overlap. For example, 0.9 means that each window shares 90% of
            /// the audio that the previous window uses.
            request.overlapFactor = Double(0.0)
            try streamAnalyzer.add(request, withObserver: resultsObserver)
        } catch {
            print(error)
        }
        
        installAudioTap()
    }
    
    private func installAudioTap() {
//        audioEngine.inputNode.installTap(onBus: inputBus,
//                                         bufferSize: 8192,
//                                         format: inputFormat) { buffer, time in
//            let channelDataValue = buffer.floatChannelData!.pointee
//            let channelDataValueArray = stride(from: 0,
//                                               to: Int(buffer.frameLength),
//                                               by: buffer.stride).map{ channelDataValue[$0] }
//
//            let rms = sqrt(channelDataValueArray.map{ $0 * $0 }.reduce(0, +) / Float(buffer.frameLength))
//            let avgPower = 20 * log10(rms)
//            print(avgPower)
//            self.analysisQueue.async {
//                self.streamAnalyzer.analyze(buffer, atAudioFramePosition: time.sampleTime)
//            }
//        }
        audioEngine.inputNode.installTap(onBus: inputBus,
                                         bufferSize: 8192,
                                         format: inputFormat,
                                         block: analyzeAudio(buffer:at:))
    }
    
    private func analyzeAudio(buffer: AVAudioBuffer, at time: AVAudioTime) {
        analysisQueue.async {
            self.streamAnalyzer.analyze(buffer,
                                        atAudioFramePosition: time.sampleTime)
        }
    }
    
    func stop() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: inputBus)
    }
}
