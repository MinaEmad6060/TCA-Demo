//
//  TCAApp.swift
//  TCA Demo
//
//  Created by Mina Emad on 08/12/2025.
//

import SwiftUI
import ComposableArchitecture

@main
struct TCAApp: App {
    var body: some Scene {
        WindowGroup {
            MainTabsView(
                store: Store(initialState: MainTabs.State()) {
                    MainTabs()
                }
            )
        }
    }
}
