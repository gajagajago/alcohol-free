//
//  DrinkClassifierManager.swift
//  AlcoholFree WatchKit Extension
//
//  Created by 박신홍 on 2021/10/21.
//
//  참고자료 https://apple.github.io/turicreate/docs/userguide/activity_classifier/export_coreml.html
//

import Foundation
import CoreML
import CoreMotion



class MotionClassifier {
    static let shared = MotionClassifier()
    static let sensorUpdateInterval = 1.0 / 50.0  // 50hz
    
    var predictionData = PredictionData()
    let motionClassifierModel = try! MotionClassifierModel(configuration: .init())
    var motionManager = CMMotionManager()
    var queue = OperationQueue()
    var delegator: IncreaseDrinkingMotionCnt?

    init() {
        let interval = TimeInterval(MotionClassifier.sensorUpdateInterval)
        motionManager.accelerometerUpdateInterval = interval
        motionManager.gyroUpdateInterval = interval
        motionManager.deviceMotionUpdateInterval = interval
    }
    
    func startMotionUpdates() {
        motionManager.startDeviceMotionUpdates(to: self.queue) {
            (data: CMDeviceMotion?, error: Error?) in
            guard let data = data else {return}
            self.addAccelSampleToDataArray(motionData: data)
        }
    }
    
    func stopMotionUpdates() {
        motionManager.stopDeviceMotionUpdates()
    }
    
    func addAccelSampleToDataArray (motionData: CMDeviceMotion) {
        predictionData.feed(motionData)
        
        // If the data array is full, call the prediction method to get a new model prediction.
        if (predictionData.isPredictionDataReady()) {
            if let predictedActivity = performModelPrediction() {
                
                if (predictedActivity == "just_drink") {
                    // increase drinkMotionDetectedCnt by 1
                    delegator?.increaseDrinkingMotionDetectedCnt()
                }
                
                // Use the predicted activity here
                
                // Start a new prediction window
                predictionData.resetIndexInPredictionWindow()
            }
        }
    }
    
    func performModelPrediction () -> String? {
        // Perform model prediction
        let modelPrediction = try? motionClassifierModel.prediction(input: predictionData.getPredictionInput())
        guard let modelPrediction = modelPrediction else { return nil }
        
        print(modelPrediction.labelProbability)
        
        // this stateOut becomes input for the next prediction
        predictionData.feedback(stateOut: modelPrediction.stateOut)

        // Return the predicted activity - the activity with the highest probability
        return modelPrediction.label
    }
}

protocol IncreaseDrinkingMotionCnt {
    func increaseDrinkingMotionDetectedCnt()
}
