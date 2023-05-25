//
//  ThirdGameView.swift
//  MyFirstGame
//
//  Created by Deanira Fadrinaldi on 23/05/23.
//

import SwiftUI
import CoreMotion
import AVFoundation

struct ThirdGameView: View {
    //    @ObservedObject var viewModel = ThirdGameViewModel2()
    @ObservedObject var viewModel = ThirdGameViewModel()
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var rotation = 0.0
    @State private var goesToChooseGame: Bool = false
    
    var body: some View {
        VStack {
            Spacer()
            VStack{
                Text("Instruction!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.green)
                Spacer()
                    .frame(height: 8)
                Text("Tilt your phone and stop for 1 second right when you feel vibration")
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 48)
                Text("\(viewModel.time)")
                    .font(.system(size: 24, weight: .medium, design: .rounded))
                
                    .padding()
                    .background(.thinMaterial)
                    .cornerRadius(16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.gray, lineWidth: 4)
                    )
                //                    .navigationDestination(isPresented: $goesToChooseGame) {
                //                        ChooseGameView()
                //                    }
            }
            .padding(.vertical, 20)
            .background{
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(.green.opacity(0.5), lineWidth: 10)
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.green.opacity(0.1))
                }.padding(.horizontal, 20)
            }
            Spacer()
            HStack {
                Image(viewModel.codes[0] ? "StarFilled" : "StarNoFill").resizable().scaledToFit().frame(maxWidth: 60)
                Image(viewModel.codes[1] ? "StarFilled" : "StarNoFill").resizable().scaledToFit().frame(maxWidth: 60)
                Image(viewModel.codes[2] ? "StarFilled" : "StarNoFill").resizable().scaledToFit().frame(maxWidth: 60)
            }
            Spacer()
            Spacer()
            ZStack {
                Image("SafeBody")
                    .resizable()
                    .scaledToFit()
                    .padding(.horizontal, 60)
                Image("SafeWheel")
                    .resizable()
                    .rotationEffect(.radians(Double(viewModel.rotationValue) ?? 0.0))
                    .scaledToFit()
                    .frame(width: 70)
                    .offset(x:6,y:-66)
            }
            Spacer()
        }
        .alert("Time is up!", isPresented: $viewModel.showingAlert) {
            Button("Back to menu") {
            }
        }
        .alert("Yeay you did it!", isPresented: $viewModel.codes[viewModel.codes.count - 1]) {
            Button("Back to menu") {
            }
        }
        .onAppear{
            //            viewModel.startDeviceMotion()
            viewModel.startUpdates()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                viewModel.start(minutes: viewModel.minutes)
            }
        }
        .onReceive(timer) { _ in
            viewModel.updateCountdown()
        }
        .onDisappear{
            viewModel.stopUpdates()
        }
    }
}

struct ThirdGameView_Previews: PreviewProvider {
    static var previews: some View {
        ThirdGameView()
    }
}
