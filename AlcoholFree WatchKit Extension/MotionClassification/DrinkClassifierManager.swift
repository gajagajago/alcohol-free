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



class DrinkClassifierManager {
    
    static let predictionWindowSize = 70
    static let sensorUpdateInterval = 1.0 / 50.0  // 50hz
    static let stateInLength = 400
    
    let motionClassifierModel = try! MotionClassifier(configuration: .init())
    
    var currentIndexInPredictionWindow = 0
    
    let accelDataX = try! MLMultiArray(shape: [predictionWindowSize] as [NSNumber], dataType: MLMultiArrayDataType.double)
    let accelDataY = try! MLMultiArray(shape: [predictionWindowSize] as [NSNumber], dataType: MLMultiArrayDataType.double)
    let accelDataZ = try! MLMultiArray(shape: [predictionWindowSize] as [NSNumber], dataType: MLMultiArrayDataType.double)
    
    let motionRotationRateX = try! MLMultiArray(shape: [predictionWindowSize] as [NSNumber], dataType: MLMultiArrayDataType.double)
    let motionRotationRateY = try! MLMultiArray(shape: [predictionWindowSize] as [NSNumber], dataType: MLMultiArrayDataType.double)
    let motionRotationRateZ = try! MLMultiArray(shape: [predictionWindowSize] as [NSNumber], dataType: MLMultiArrayDataType.double)
    
    let motionQuaternionX = try! MLMultiArray(shape: [predictionWindowSize] as [NSNumber], dataType: MLMultiArrayDataType.double)
    let motionQuaternionY = try! MLMultiArray(shape: [predictionWindowSize] as [NSNumber], dataType: MLMultiArrayDataType.double)
    let motionQuaternionZ = try! MLMultiArray(shape: [predictionWindowSize] as [NSNumber], dataType: MLMultiArrayDataType.double)
    
    var stateOutput = try! MLMultiArray(shape:[stateInLength as NSNumber], dataType: MLMultiArrayDataType.double)
    
    var motionManager = CMMotionManager()
    var queue = OperationQueue()
    
    init() {
        let interval = TimeInterval(DrinkClassifierManager.sensorUpdateInterval)
        motionManager.accelerometerUpdateInterval = interval
        motionManager.gyroUpdateInterval = interval
        motionManager.deviceMotionUpdateInterval = interval
        
        // stateIn을 0으로 초기화 (더 좋은 방법 찾습니다)
        for index in 0..<400 {
            stateOutput[index] = 0
        }
    }
    
    func startMotionUpdates() {
        HealthKitSessionManager.shared.startBackgroundSession()
        motionManager.startDeviceMotionUpdates(to: self.queue) {
            (data: CMDeviceMotion?, error: Error?) in
            guard let data = data else {return}
            self.addAccelSampleToDataArray(motionData: data)
        }
    }
    
    func stopMotionUpdates() {
        motionManager.stopDeviceMotionUpdates()
        HealthKitSessionManager.shared.endBackgroundSession()
    }
    
    func addAccelSampleToDataArray (motionData: CMDeviceMotion) {
//        print("\(currentIndexInPredictionWindow): \(motionData.userAcceleration), \(motionData.rotationRate), \(motionData.attitude.quaternion)")
        // Add the current accelerometer reading to the data array
        accelDataX[[currentIndexInPredictionWindow] as [NSNumber]] = motionData.userAcceleration.x as NSNumber
        accelDataY[[currentIndexInPredictionWindow] as [NSNumber]] = motionData.userAcceleration.y as NSNumber
        accelDataZ[[currentIndexInPredictionWindow] as [NSNumber]] = motionData.userAcceleration.z as NSNumber
        
        motionRotationRateX[[currentIndexInPredictionWindow] as [NSNumber]] = motionData.rotationRate.x as NSNumber
        motionRotationRateY[[currentIndexInPredictionWindow] as [NSNumber]] = motionData.rotationRate.y as NSNumber
        motionRotationRateZ[[currentIndexInPredictionWindow] as [NSNumber]] = motionData.rotationRate.z as NSNumber
        
        motionQuaternionX[[currentIndexInPredictionWindow] as [NSNumber]] = motionData.attitude.quaternion.x as NSNumber
        motionQuaternionY[[currentIndexInPredictionWindow] as [NSNumber]] = motionData.attitude.quaternion.y as NSNumber
        motionQuaternionZ[[currentIndexInPredictionWindow] as [NSNumber]] = motionData.attitude.quaternion.z as NSNumber
        
        // Update the index in the prediction window data array
        currentIndexInPredictionWindow += 1
        
        // If the data array is full, call the prediction method to get a new model prediction.
        if (currentIndexInPredictionWindow == DrinkClassifierManager.predictionWindowSize) {
            if let predictedActivity = performModelPrediction() {
                
                // Use the predicted activity here
//                print(predictedActivity)
                
                // Start a new prediction window
                currentIndexInPredictionWindow = 0
            }
        }
    }
    
    func performModelPrediction () -> String? {
        // Perform model prediction
        let modelPrediction = try? motionClassifierModel.prediction(motionQuaternionX_R_: motionQuaternionX, motionQuaternionY_R_: motionQuaternionY, motionQuaternionZ_R_: motionQuaternionZ, motionRotationRateX_rad_s_: motionRotationRateX, motionRotationRateY_rad_s_: motionRotationRateY, motionRotationRateZ_rad_s_: motionRotationRateZ, motionUserAccelerationX_G_: accelDataX, motionUserAccelerationY_G_: accelDataY, motionUserAccelerationZ_G_: accelDataZ, stateIn: stateOutput)

        guard let modelPrediction = modelPrediction else { return nil }
        print(modelPrediction.labelProbability)
        stateOutput = modelPrediction.stateOut

        // Return the predicted activity - the activity with the highest probability
        return modelPrediction.label
    }
}
