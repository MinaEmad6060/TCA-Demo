//
//  MainTabsView.swift
//  TCA Demo
//
//  Created by Mina Emad on 14/12/2025.
//

import SwiftUI
import ComposableArchitecture

public struct MainTabsView: View {
    let store: StoreOf<MainTabs>
    
    public init(store: StoreOf<MainTabs>) {
        self.store = store
    }
    
    public var body: some View {
        TabView(selection: Binding(
            get: { store.selectedTab },
            set: { store.send(.tabSelected($0)) }
        )) {
            TodoView(
                store: store.scope(
                    state: \.todoState,
                    action: \.todoAction
                )
            )
            .tabItem {
                Label("Todos", systemImage: "checklist")
            }
            .tag(MainTabs.State.Tab.todos)
            
            TimerView(
                store: store.scope(
                    state: \.timerState,
                    action: \.timerAction
                )
            )
            .tabItem {
                Label("Timer", systemImage: "timer")
            }
            .tag(MainTabs.State.Tab.timer)
            
            CounterView(
                store: store.scope(
                    state: \.counterState,
                    action: \.counterAction
                )
            )
            .tabItem {
                Label("Counter", systemImage: "number")
            }
            .tag(MainTabs.State.Tab.counter)
        }
    }
}

#if DEBUG
#Preview {
    MainTabsView(
        store: Store(initialState: MainTabs.State()) {
            MainTabs()
        }
    )
}
#endif


