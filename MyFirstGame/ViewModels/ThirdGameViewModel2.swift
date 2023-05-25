//
//  ThirdGameViewModel2.swift
//  MyFirstGame
//
//  Created by Deanira Fadrinaldi on 24/05/23.
//

import Foundation
import CoreMotion

class ThirdGameViewModel2: ObservableObject {
    private let motionManager = CMMotionManager()
    private var timer: Timer = Timer()
    
    init() {
        // Set the update interval to any time that you want
        motionManager.deviceMotionUpdateInterval = 1.0 / 60.0 // 60 Hz
        motionManager.accelerometerUpdateInterval = 1.0 / 60.0
        motionManager.gyroUpdateInterval = 1.0 / 20.0
    }
    
    func rad2deg(_ number: Double) -> Double {
        return number * 180 / .pi
    }
    
    func deg2rad(_ number: Double) -> Double {
        return number * .pi / 180
    }
    
    func startDeviceMotion() {
        if motionManager.isDeviceMotionAvailable {
            self.motionManager.deviceMotionUpdateInterval = 1.0 / 60.0
            self.motionManager.showsDeviceMovementDisplay = true
            self.motionManager.startDeviceMotionUpdates(using: .xMagneticNorthZVertical)
            
            // Configure a timer to fetch the motion data.
            self.timer = Timer(fire: Date(), interval: (1.0 / 60.0), repeats: true,
                               block: { (timer) in
                if let data = self.motionManager.deviceMotion {
                    // Get the attitude relative to the magnetic north reference frame.
                    let x = data.attitude.pitch
                    let y = data.attitude.roll
                    let z = data.attitude.yaw
                    
                    // Use the motion data in your app.
                    print("pitch: \(self.rad2deg(x)), roll: \(self.rad2deg(y)), yaw: \(self.rad2deg(z))")
                }
            })
            
            // Add the timer to the current run loop.
            RunLoop.current.add(self.timer, forMode: RunLoop.Mode.default)
        }
    }
    
    @Published var isActive = false
    @Published var showingAlert = false
    @Published var time: String = "5:00"
    @Published var minutes: Float = 1.0 {
        didSet {
            self.time = Int(minutes) < 10 ? "0\(Int(minutes)):00" : "\(Int(minutes)):00"
        }
    }
    private var initialTime = 0
    private var endDate = Date()
    
    // Start the timer with the given amount of minutes
    func start(minutes: Float) {
        self.initialTime = Int(minutes)
        self.endDate = Date()
        self.isActive = true
        self.endDate = Calendar.current.date(byAdding: .minute, value: Int(minutes), to: endDate)!
    }
    
    // Reset the timer
    func reset() {
        self.minutes = Float(initialTime)
        self.isActive = false
        self.time = Int(minutes) < 10 ? "0\(Int(minutes)):00" : "\(Int(minutes)):00"
    }
    
    // Show updates of the timer
    func updateCountdown(){
        guard isActive else { return }
        
        // Gets the current date and makes the time difference calculation
        let now = Date()
        let diff = endDate.timeIntervalSince1970 - now.timeIntervalSince1970
        
        // Checks that the countdown is not <= 0
        if diff <= 0 {
            self.isActive = false
            self.time = "0:00"
            self.showingAlert = true
            return
        }
        
        // Turns the time difference calculation into sensible data and formats it
        let date = Date(timeIntervalSince1970: diff)
        let calendar = Calendar.current
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)

        // Updates the time string with the formatted time
        self.minutes = Float(minutes)
        self.time = String(format:"%d:%02d", minutes, seconds)
    }
}

//extension ThirdGameView {
//    final class ViewModel: ObservableObject {
//        @Published var isActive = false
//        @Published var showingAlert = false
//        @Published var time: String = "5:00"
//        @Published var minutes: Float = 5.0 {
//            didSet {
//                self.time = "\(Int(minutes)):00"
//            }
//        }
//        private var initialTime = 0
//        private var endDate = Date()
//
//        // Start the timer with the given amount of minutes
//        func start(minutes: Float) {
//            self.initialTime = Int(minutes)
//            self.endDate = Date()
//            self.isActive = true
//            self.endDate = Calendar.current.date(byAdding: .minute, value: Int(minutes), to: endDate)!
//        }
//
//        // Reset the timer
//        func reset() {
//            self.minutes = Float(initialTime)
//            self.isActive = false
//            self.time = "\(Int(minutes)):00"
//        }
//
//        // Show updates of the timer
//        func updateCountdown(){
//            guard isActive else { return }
//
//            // Gets the current date and makes the time difference calculation
//            let now = Date()
//            let diff = endDate.timeIntervalSince1970 - now.timeIntervalSince1970
//
//            // Checks that the countdown is not <= 0
//            if diff <= 0 {
//                self.isActive = false
//                self.time = "0:00"
//                self.showingAlert = true
//                return
//            }
//
//            // Turns the time difference calculation into sensible data and formats it
//            let date = Date(timeIntervalSince1970: diff)
//            let calendar = Calendar.current
//            let minutes = calendar.component(.minute, from: date)
//            let seconds = calendar.component(.second, from: date)
//
//            // Updates the time string with the formatted time
//            self.minutes = Float(minutes)
//            self.time = String(format:"%d:%02d", minutes, seconds)
//        }
//    }
//}
