//
//  FirstGameView.swift
//  MyFirstGame
//
//  Created by Deanira Fadrinaldi on 23/05/23.
//

import SwiftUI
import RealityKit

struct FirstGameView: View {
    var body: some View {
        ZStack {
            DiceARViewContainer().edgesIgnoringSafeArea(.all)
            VStack {
                Text("This is your digital dice. You can tap it and then it'll act just how real-life dice supposed to act.")
                    .multilineTextAlignment(.center)
                    .font(.system(size: 22, weight: .medium, design: .rounded))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(.gray.opacity(0.5))
                    .cornerRadius(8)
    //                .overlay(
    //                    RoundedRectangle(cornerRadius: 8)
    //                        .stroke(Color.gray, lineWidth: 4)
    //                )
                Spacer()
            }.padding(.horizontal, 20)
        }
    }
}

struct DiceARViewContainer: UIViewRepresentable {
    
    func makeUIView(context: Context) -> ARView {
        
        let arView = ARView(frame: .zero)
        
        // Load the "Box" scene from the "Experience" Reality File
        let boxAnchor = try! DiceScene.loadBox()
        
        boxAnchor.actions.throwDice.onAction = { entity in
            let dice = entity as! HasPhysics
            
            dice.physicsBody?.mode = .kinematic
            
            dice.physicsMotion?.angularVelocity = [
                Float.random(in: 0..<4 * .pi),
                Float.random(in: 0..<4 * .pi),
                Float.random(in: 0..<4 * .pi)
            ]
            
            dice.physicsMotion?.linearVelocity = [0,1,0]
            
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                dice.physicsBody?.mode = .dynamic
                
                dice.physicsMotion?.angularVelocity = [0,0,0]
                
                dice.physicsMotion?.linearVelocity = [0,0,0]
            }
        }
        
        // Add the box anchor to the scene
        arView.scene.anchors.append(boxAnchor)
        
        return arView
        
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
}

struct FirstGameView_Previews: PreviewProvider {
    static var previews: some View {
        FirstGameView()
    }
}
