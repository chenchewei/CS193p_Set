//
//  SetApp.swift
//  Set
//
//  Created by Anderson Chen on 2022/7/13.
//

import SwiftUI

@main
struct SetApp: App {
    let game = SetGame()
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: game)
        }
    }
}
