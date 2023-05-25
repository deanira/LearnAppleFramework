//
//  ContentView.swift
//  MyFirstGame
//
//  Created by Deanira Fadrinaldi on 22/05/23.
//

import SwiftUI
import AudioToolbox

extension UINavigationController {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = nil
    }
}

struct ContentView: View {
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                Text("Dea's")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Text("Parallel Challenge")
                    .font(.title)
                    .fontWeight(.bold)
                Spacer()
                NavigationLink(destination: ChooseGameView().navigationBarBackButtonHidden(true)) {
                    Image("PlayButton")
                        .resizable()
                        .scaledToFit()
                        .frame(width: .infinity)
                        .padding(.horizontal, 60)
                }
                Spacer()
            }
            .gesture(DragGesture().onEnded { gesture in
                print(gesture.translation.width)})
            .ignoresSafeArea()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
