//
//  MockingStarExampleApp.swift
//  MockingStarExample
//
//  Created by Yusuf Özgül on 27.11.2023.
//

import SwiftUI
import MockingStar

@main
struct MockingStarExampleApp: App {
    init() {
        if ProcessInfo.processInfo.environment["EnableMockingStar"] == "1" {
            MockingStar.shared.inject()
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
