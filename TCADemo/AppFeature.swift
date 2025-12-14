//
//  AppFeature.swift
//  TCABestPracticesDemo
//
//  Created by Mina Emad on 08/12/2025.
//

import SwiftUI
import ComposableArchitecture

// MARK: - App Feature
// Demonstrates: Feature composition, Tab-based navigation, and Root state management

@Reducer
public struct AppFeature {
    @ObservableState
    public struct State: Equatable {
        var counterState: CounterFeature.State = CounterFeature.State()
        var todoListState: TodoListFeature.State = TodoListFeature.State()
        var timerState: TimerFeature.State = TimerFeature.State()
        var selectedTab: Tab = .counter
        
        public enum Tab: String, CaseIterable {
            case counter = "Counter"
            case todos = "Todos"
            case timer = "Timer"
        }
        
        public init() {}
    }
    
    public enum Action: Equatable {
        case counterAction(CounterFeature.Action)
        case todoListAction(TodoListFeature.Action)
        case timerAction(TimerFeature.Action)
        case tabSelected(State.Tab)
    }
    
    public init() {}
    
    public var body: some ReducerOf<Self> {
        Scope(state: \.counterState, action: \.counterAction) {
            CounterFeature()
        }
        
        Scope(state: \.todoListState, action: \.todoListAction) {
            TodoListFeature()
        }
        
        Scope(state: \.timerState, action: \.timerAction) {
            TimerFeature()
        }
        
        Reduce { state, action in
            switch action {
            case .tabSelected(let tab):
                state.selectedTab = tab
                return .none
                
            case .counterAction, .todoListAction, .timerAction:
                return .none
            }
        }
    }
}

public struct AppView: View {
    let store: StoreOf<AppFeature>
    
    public init(store: StoreOf<AppFeature>) {
        self.store = store
    }
    
    public var body: some View {
        TabView(selection: Binding(
            get: { store.selectedTab },
            set: { store.send(.tabSelected($0)) }
        )) {
            CounterView(
                store: store.scope(
                    state: \.counterState,
                    action: \.counterAction
                )
            )
            .tabItem {
                Label("Counter", systemImage: "number.circle")
            }
            .tag(AppFeature.State.Tab.counter)
            
            TodoListView(
                store: store.scope(
                    state: \.todoListState,
                    action: \.todoListAction
                )
            )
            .tabItem {
                Label("Todos", systemImage: "checklist")
            }
            .tag(AppFeature.State.Tab.todos)
            
            TimerView(
                store: store.scope(
                    state: \.timerState,
                    action: \.timerAction
                )
            )
            .tabItem {
                Label("Timer", systemImage: "timer")
            }
            .tag(AppFeature.State.Tab.timer)
        }
    }
}

#if DEBUG
#Preview {
    AppView(
        store: Store(initialState: AppFeature.State()) {
            AppFeature()
        }
    )
}
#endif

