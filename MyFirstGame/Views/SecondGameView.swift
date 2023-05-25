//
//  SecondGameView.swift
//  MyFirstGame
//
//  Created by Deanira Fadrinaldi on 23/05/23.
//

import SwiftUI
import SpriteKit

protocol GameLogicDelegate {
    var totalScoreObama: Int { get }
    var totalScoreTrump: Int { get }
    
    mutating func addPointObama() -> Void
    mutating func addPointTrump() -> Void
}

struct SecondGameView: View, GameLogicDelegate {
    @State private var orientation = UIDevice.current.orientation
    @State private var alertIsPresented = false
    
    @State var totalScoreObama: Int = 0
    @State var totalScoreTrump: Int = 0
    
    mutating func addPointObama() {
        self.totalScoreObama += 1
    }
    
    mutating func addPointTrump() {
        self.totalScoreTrump += 1
    }
    
    var scene: GameScene {
        let scene = GameScene()
        
        scene.gameLogicDelegate = self
        
        return scene
    }
    
    var body: some View {
        ZStack {
            SpriteView(scene: scene)
                .ignoresSafeArea()
            
            VStack{
                Text("Score")
                    .font(.largeTitle)
                    .bold()
                
                Text("\(self.totalScoreObama) - \(self.totalScoreTrump)")
                    .font(.largeTitle)
                Spacer()
            }
        }
        .onAppear {
            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation") // Forcing the rotation to portrait
            AppDelegate.orientationLock = .landscape // And making sure it stays that way
        }.onDisappear {
            AppDelegate.orientationLock = .all // Unlocking the rotation when leaving the view
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
         
    static var orientationLock = UIInterfaceOrientationMask.all //By default you want all your views to rotate freely
 
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return AppDelegate.orientationLock
    }
}

struct DetectOrientation: ViewModifier {
    @Binding var orientation: UIDeviceOrientation
    @Binding var isPortrait: Bool
    
    func body(content: Content) -> some View {
        content
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                orientation = UIDevice.current.orientation
                isPortrait = !orientation.isLandscape
            }
    }
}

extension View {
    func detectOrientation(_ orientation: Binding<UIDeviceOrientation>,_ isPortrait: Binding<Bool>) -> some View {
        modifier(DetectOrientation(orientation: orientation, isPortrait: isPortrait))
    }
}

//struct SecondGameView_Previews: PreviewProvider {
//    static var previews: some View {
//        SecondGameView()
//    }
//}
