//
//  TimerFeature.swift
//  TCA Demo
//
//  Created by Mina Emad on 08/12/2025.
//
//  This feature demonstrates TCA best practices:
//  - Side effects (timers, async operations)
//  - Cancellation and resource management
//  - Testing time-based features

import SwiftUI
import ComposableArchitecture

// MARK: - Timer Feature
@Reducer
public struct TimerFeature : Sendable{
    @ObservableState
    public struct State: Equatable {
        var elapsedTime: TimeInterval = 0
        var isRunning: Bool = false
        
        public init() {}
    }
    
    public enum Action: Equatable {
        case startButtonTapped
        case stopButtonTapped
        case resetButtonTapped
        case timerTick
    }
    
    @Dependency(\.continuousClock) var clock
    
    public init() {}
    
    public var body: some ReducerOf<Self> {
        Reduce<State, Action> { state, action in
            switch action {
            case .startButtonTapped:
                state.isRunning = true
                return .run { send in
                    for await _ in clock.timer(interval: .seconds(0.1)) {
                        await send(.timerTick)
                    }
                }
                .cancellable(id: TimerID.timer)
                
            case .stopButtonTapped:
                state.isRunning = false
                return .cancel(id: TimerID.timer)
                
            case .resetButtonTapped:
                state.isRunning = false
                state.elapsedTime = 0
                return .cancel(id: TimerID.timer)
                
            case .timerTick:
                guard state.isRunning else { return .none }
                state.elapsedTime += 0.1
                return .none
            }
        }
    }
    
    private enum TimerID {
        case timer
    }
}
