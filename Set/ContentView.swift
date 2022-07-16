//
//  ContentView.swift
//  Set
//
//  Created by Anderson Chen on 2022/7/13.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewModel: SetGame
    
    var body: some View {
        NavigationView {
            VStack(alignment: .center) {
                Text("Score: -3456")
                    .bold()
                
                if !viewModel.isGameOver {
                    AspectVGrid(items: viewModel.cards, aspectRatio: 2/3) { card in
                        CardView()
                    }
                }
                
                HStack {
                    Button {
                        // Start a new game
                    } label: {
                        Text("New Game")
                    }
                    Text("Remaining: 12 cards")
                    Button {
                        // Deal cards
                    } label: {
                        Text("Deal 3 cards")
                    }
                }
                .padding(.bottom)
            }
            .navigationTitle("Set game")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem {
                    Button {
                        // TODO: Navigation to rules
                        print("111")
                    } label: {
                        Image(systemName: "info.circle")
                    }
                }

            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = SetGame()
        ContentView(viewModel: viewModel)
            .preferredColorScheme(.dark)
        ContentView(viewModel: viewModel)
            .preferredColorScheme(.light)
    }
}
