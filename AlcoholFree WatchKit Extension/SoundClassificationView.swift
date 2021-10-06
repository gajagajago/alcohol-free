import SwiftUI
import SoundAnalysis
import CoreML
import AVFAudio

struct SoundClassificationView: View {
    @State var store = SoundClassificationStore()
    
    var body: some View {
        VStack {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            Button(action: {
                WKInterfaceDevice.current().play(.notification)
                if store.isRunning() {
                    store.stop()
                } else {
                    store.start()
                }
            }) {
                Text(store.isRunning() ? "Stop" : "Start")
            }
        }
    }
}

class SoundClassificationStore {
    let audioEngine: AVAudioEngine
    let inputBus: AVAudioNodeBus
    let inputFormat: AVAudioFormat
    let streamAnalyzer: SNAudioStreamAnalyzer
    let analysisQueue: DispatchQueue
    let model: MLModel
    
    init () {
        // Create a new audio engine.
        self.audioEngine = AVAudioEngine()

        // Get the native audio format of the engine's input bus.
        self.inputBus = AVAudioNodeBus(0)
        self.inputFormat = audioEngine.inputNode.inputFormat(forBus: inputBus)
        self.streamAnalyzer = SNAudioStreamAnalyzer(format: inputFormat)
        
        self.analysisQueue = DispatchQueue(label:"com.alcholFree.AnalysisQueue")
        
        self.model = try! ReadTheRoom(configuration: MLModelConfiguration()).model
    }
    
    func isRunning() -> Bool {
        return audioEngine.isRunning
    }
    
    func start() {
        do {
            // Start the stream of audio data.
            try audioEngine.start()
        } catch {
            print("Unable to start AVAudioEngine: \(error.localizedDescription)")
        }
        
        // Create a new observer to receive notifications for analysis results.
        let resultsObserver = ResultsObserver()

        // Prepare a new request for the trained model.
        do {
            let request = try SNClassifySoundRequest(mlModel: model)
            try streamAnalyzer.add(request, withObserver: resultsObserver)
        } catch {
            print(error)
        }
        
        installAudioTap()
    }
    
    private func installAudioTap() {
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
    }
}

struct SoundClassificationView_Previews: PreviewProvider {
    static var previews: some View {
        SoundClassificationView()
    }
}
