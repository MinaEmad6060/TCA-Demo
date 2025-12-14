//
//  MainTabs.swift
//  TCA Demo
//
//  Created by Mina Emad on 08/12/2025.
//
//  This feature demonstrates TCA best practices:
//  - Feature composition
//  - Navigation state management
//  - Root-level state coordination

import SwiftUI
import ComposableArchitecture

// MARK: - App Feature
@Reducer
public struct MainTabs {
    // MARK: - State
    @ObservableState
    public struct State: Equatable {
        var selectedTab: Tab = .todos
        var todoState: TodoFeature.State = TodoFeature.State()
        var timerState: TimerFeature.State = TimerFeature.State()
        var counterState: CounterFeature.State = CounterFeature.State()
        
        public init() {}
        
        public enum Tab: String, Equatable, CaseIterable {
            case todos = "Todos"
            case timer = "Timer"
            case counter = "Counter"
        }
    }
    
    // MARK: - Action
    public enum Action: Equatable {
        case tabSelected(State.Tab)
        case todoAction(TodoFeature.Action)
        case timerAction(TimerFeature.Action)
        case counterAction(CounterFeature.Action)
    }
    
    public init() {}
    
    public var body: some ReducerOf<Self> {
        Scope(
            state: \.todoState,
            action: \.todoAction
        ) {
            TodoFeature()
        }
        
        Scope(
            state: \.timerState,
            action: \.timerAction
        ) {
            TimerFeature()
        }
        
        Scope(
            state: \.counterState,
            action: \.counterAction
        ) {
            CounterFeature()
        }
        
        // MARK: - Reducer
        Reduce<State, Action> { state, action in
            switch action {
            case let .tabSelected(tab):
                state.selectedTab = tab
                return .none
                
            case .todoAction, .timerAction, .counterAction:
                return .none
            }
        }
    }
}
