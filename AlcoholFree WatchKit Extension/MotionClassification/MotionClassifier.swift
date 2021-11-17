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
    let motionClassifierModel = try! MotionClassifierModelR(configuration: .init())
    var motionManager = CMMotionManager()
    var queue = OperationQueue()
    var delegator: MotionClassifierDelegate?
    
    var lastDetected = NSDate().timeIntervalSince1970 - 10

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
                
                if (predictedActivity == "drink") {
                    // increase drinkMotionDetectedCnt by 1
                    let now = NSDate().timeIntervalSince1970
                    if now - lastDetected > 10 {
                        // 마지막 짠으로부터 10초 이상 지나야 감지된 것으로 한다.
                        print("Drink Motion 이벤트 발생")
                        delegator?.drinkMotionDetected()
                        lastDetected = NSDate().timeIntervalSince1970
                    }
                }
                
                // Start a new prediction window
                predictionData.resetIndexInPredictionWindow()
            }
        }
    }
    
    func performModelPrediction () -> String? {
        // Perform model prediction
        let modelPrediction = try? motionClassifierModel.prediction(input: predictionData.getPredictionInput())
        guard let modelPrediction = modelPrediction else { return nil }
        
        let left = modelPrediction.labelProbability["left_drink"]
        let right = modelPrediction.labelProbability["right_drink"]
        let others = modelPrediction.labelProbability["others"]
        
        print("left: \(String(format:"%.2f", left! * 100))% | right: \(String(format:"%.2f", right! * 100))% | others: \(String(format:"%.2f", others! * 100))%")
        
        // this stateOut becomes input for the next prediction
        predictionData.feedback(stateOut: modelPrediction.stateOut)
        
        guard let leftProb = left, let rightProb = right else { return nil }
        if leftProb > 0.8 || rightProb > 0.9 {
            return "drink"
        } else {
            return "others"
        }
    }
}

protocol MotionClassifierDelegate {
    func drinkMotionDetected()
}
