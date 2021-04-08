//
//  MemorizeApp.swift
//  Memorize
//
//  Created by user on 07/04/21.
//

import SwiftUI

@main
struct MemorizeApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: EmojiMemoryGame())
        }
    }
}
