//
//  ChooseGameView.swift
//  MyFirstGame
//
//  Created by Deanira Fadrinaldi on 23/05/23.
//

import SwiftUI

struct ChooseGameView: View {
    var body: some View {
        VStack {
            Spacer()
            Text("Choose your game")
                .font(.largeTitle)
                .fontWeight(.bold)
            Spacer()
            Group{
                NavigationLink(destination: FirstGameView().navigationBarHidden(true)) {
                    Image("FirstGameButton")
                        .resizable()
                }
                NavigationLink(destination: ThirdGameView().navigationBarHidden(true)) {
                    Image("SecondGameButton")
                        .resizable()
                }
//                NavigationLink(destination: ThirdGameView().navigationBarHidden(true)) {
//                    Image("ThirdGameButton")
//                        .resizable()
//                }
            }
            .scaledToFit()
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 60)
            Spacer()
        }
    }
}

struct ChooseGameView_Previews: PreviewProvider {
    static var previews: some View {
        ChooseGameView()
    }
}
