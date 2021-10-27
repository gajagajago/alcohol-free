//
//  File.swift
//  AlcoholFree WatchKit Extension
//
//  Created by 박신홍 on 2021/10/27.
//

import Foundation
import HealthKit

class HealthKitSessionManager {
    static let shared = HealthKitSessionManager()  // use only singleton
    
    private let healthStore = HKHealthStore()
    private let workoutConfiguration = HKWorkoutConfiguration()
    private var session: HKWorkoutSession?
    
    init() {
        workoutConfiguration.activityType = .walking
        workoutConfiguration.locationType = .outdoor
    }
    
    func startBackgroundSession() {
        do {
            session = try HKWorkoutSession(healthStore: healthStore, configuration: workoutConfiguration)
        } catch {
            fatalError("Unable to create the workout session!")
        }
        session!.startActivity(with: Date())
    }
    
    func endBackgroundSession() {
        guard let session = session else { return }
        session.end()
    }
    
}
