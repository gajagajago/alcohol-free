//
//  PredictionData.swift
//  AlcoholFree WatchKit Extension
//
//  Created by 박신홍 on 2021/10/27.
//

import Foundation
import CoreML
import CoreMotion

class PredictionData {
    static let predictionWindowSize = 70
    static let stateInLength = 400
    private var currentIndexInPredictionWindow = 0
    private var _predictionWindowSize = predictionWindowSize
    
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
    
    init() {
        // stateIn을 0으로 초기화 (더 좋은 방법 찾습니다)
        for index in 0..<400 {
            stateOutput[index] = 0
        }
    }
    
    func feed(_ motionData: CMDeviceMotion) {
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
    }
    
    func isPredictionDataReady() -> Bool {
        return currentIndexInPredictionWindow == _predictionWindowSize
    }
    
    func resetIndexInPredictionWindow() {
        currentIndexInPredictionWindow = 0
    }
    
    func getPredictionInput() -> MotionClassifierModelNewInput {
        return MotionClassifierModelNewInput(motionQuaternionX_R_: motionQuaternionX, motionQuaternionY_R_: motionQuaternionY, motionQuaternionZ_R_: motionQuaternionZ, motionRotationRateX_rad_s_: motionRotationRateX, motionRotationRateY_rad_s_: motionRotationRateY, motionRotationRateZ_rad_s_: motionRotationRateZ, motionUserAccelerationX_G_: accelDataX, motionUserAccelerationY_G_: accelDataY, motionUserAccelerationZ_G_: accelDataZ, stateIn: stateOutput)
    }
    
    func feedback(stateOut: MLMultiArray) {
        stateOutput = stateOut
    }
}
