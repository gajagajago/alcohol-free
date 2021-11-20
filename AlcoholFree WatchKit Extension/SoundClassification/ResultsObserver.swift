import Foundation
import SoundAnalysis

/// An observer that receives results from a classify sound request.
class ResultsObserver: NSObject, SNResultsObserving {
    let delegate: SoundClassifierDelegate
    
    init(delegate: SoundClassifierDelegate) {
        self.delegate = delegate
    }
    
    /// Notifies the observer when a request generates a prediction.
    func request(_ request: SNRequest, didProduce result: SNResult) {
        // Downcast the result to a classification result.
        guard let result = result as? SNClassificationResult else  { return }

        // Get the prediction with the highest confidence.
        guard let classification = result.classifications.first else { return }
        
        if classification.identifier == "glass_clink" {
            DispatchQueue.main.async {
                self.delegate.drinkSoundDetected(confidence: classification.confidence)
            }
        }
        
    }


    /// Notifies the observer when a request generates an error.
    func request(_ request: SNRequest, didFailWithError error: Error) {
        print("The the analysis failed: \(error.localizedDescription)")
    }

    /// Notifies the observer when a request is complete.
    func requestDidComplete(_ request: SNRequest) {
        print("The request completed successfully!")
    }
}

protocol SoundClassifierDelegate {
    func drinkSoundDetected(confidence: Double)
}
