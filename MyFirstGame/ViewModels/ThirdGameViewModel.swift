//
//  ThirdGameViewModel.swift
//  MyFirstGame
//
//  Created by Deanira Fadrinaldi on 24/05/23.
//

import Foundation
import CoreMotion
import AudioToolbox
import AVFoundation

class ThirdGameViewModel: ObservableObject {
    
    @Published var accelerationValue: String = ""
    @Published var gravityValue: String = ""
    @Published var rotationValue: String = ""
    private var audioPlayerClock: AVAudioPlayer?
    private var audioPlayerWin: AVAudioPlayer?
    private var audioPlayerLose: AVAudioPlayer?
    
    var codes = [false, false, false]
    var degrees = [45, 39, 57]
    var currentIndex = 0
    
    // The instance of CMMotionManager responsible for handling sensor updates
    private let motionManager = CMMotionManager()
    
    // Properties to hold the sensor values
    private var userAcceleration: CMAcceleration = CMAcceleration()
    private var gravity: CMAcceleration = CMAcceleration()
    private var rotationRate: CMRotationRate = CMRotationRate()
    
    init() {
        // Set the update interval to any time that you want
        motionManager.deviceMotionUpdateInterval = 1.0 / 60.0 // 60 Hz
        motionManager.accelerometerUpdateInterval = 1.0 / 60.0
        motionManager.gyroUpdateInterval = 1.0 / 20.0
    }
    
    func startUpdates(){
        accelerationValue = ""
        gravityValue = ""
        rotationValue = ""
        startFetchingSensorData()
        playSoundClock()
    }
    
    private func startFetchingSensorData() {
        // Check if the motion manager is available and the sensors are available
        if motionManager.isDeviceMotionAvailable && motionManager.isAccelerometerAvailable && motionManager.isGyroAvailable {
            // Start updating the sensor data
            motionManager.startDeviceMotionUpdates(to: .main) { [weak self] (motion, error) in
                guard let self = self else { return } // Avoid memory leaks
                // Check if there's any error in the sensor update
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                }
                getMotionAndGravity(motion: motion)
            }
            motionManager.startGyroUpdates(to: .main) { [weak self] (gyroData, error) in
                guard let self = self else { return }
                getRotation(gyroData: gyroData)
            }
        }
    }
    
    private func getMotionAndGravity(motion: CMDeviceMotion?){
        if let motion = motion {
            // Get user acceleration and gravity data
            self.userAcceleration = motion.userAcceleration
            self.gravity = motion.gravity
            // Update publishers with the new sensor data
            self.accelerationValue = "X: \(userAcceleration.x), \n Y: \(userAcceleration.y), \n Z: \(userAcceleration.z)"
            self.gravityValue = "X: \(gravity.x), \n Y: \(gravity.y), \n Z: \(gravity.z)"
        }
    }
    
    func rad2deg(_ number: Double) -> Double {
        return number * 180 / .pi
    }
    
    func deg2rad(_ number: Double) -> Double {
        return number * .pi / 180
    }
    
    private func getRotation(gyroData: CMGyroData?){
        if let gyroData = gyroData {
            // Get rotation rate data
            self.rotationRate = gyroData.rotationRate
            // Update publisher with the new sensor data
            //            self.rotationValue = "X: \(rad2deg(rotationRate.x)), \n Y: \(rad2deg(rotationRate.y)), \n Z: \(rad2deg(rotationRate.z))"
            self.rotationValue = String(rotationRate.z)
            
            if degrees[currentIndex] == Int(rad2deg(rotationRate.z)) {
                AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(kSystemSoundID_Vibrate)) {   }
                codes[currentIndex] = true
                if currentIndex < codes.count - 1 {
                    currentIndex += 1
                } else {
                    stopUpdates()
                    playSoundWin()
                }
            }
        }
    }
    
    // Function responsible for stopping the sensor updates
    func stopUpdates() {
        motionManager.stopDeviceMotionUpdates()
        motionManager.stopAccelerometerUpdates()
        motionManager.stopGyroUpdates()
        audioPlayerClock?.stop()
    }
    
    func playSoundClock() {
        guard let soundURL = Bundle.main.url(forResource: "Clock", withExtension: ".mp3") else {
            print("Sound file not found.")
            return
        }
        print("Sound file found \(soundURL)")
        
        do {
            audioPlayerClock = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayerClock?.play()
        } catch {
            print("Error playing sound: \(error.localizedDescription)")
        }
    }
    
    func playSoundWin() {
        guard let soundURL = Bundle.main.url(forResource: "Win", withExtension: ".mp3") else {
            print("Sound file not found.")
            return
        }
        print("Sound file found \(soundURL)")
        
        do {
            audioPlayerWin = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayerWin?.play()
        } catch {
            print("Error playing sound: \(error.localizedDescription)")
        }
    }
    
    func playSoundLose() {
        guard let soundURL = Bundle.main.url(forResource: "Lose", withExtension: ".mp3") else {
            print("Sound file not found.")
            return
        }
        print("Sound file found \(soundURL)")
        
        do {
            audioPlayerLose = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayerLose?.play()
        } catch {
            print("Error playing sound: \(error.localizedDescription)")
        }
    }
    
    @Published var isActive = false
    @Published var showingAlert = false
    @Published var time: String = "01:00"
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
            self.time = "00:00"
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
        self.time = String(format:"%02d:%02d", minutes, seconds)
    }
}
