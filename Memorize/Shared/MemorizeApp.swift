//
//  MemorizeApp.swift
//  Shared
//
//  Created by Bridger Hildreth on 4/15/22.
//

import SwiftUI

@main
struct MemorizeApp: App {
    @StateObject var themeStore = ThemeStore(named: "Emojis")
    
    var body: some Scene {
        WindowGroup {
            ThemeChooser()
                .environmentObject(themeStore)
        }
    }
}
