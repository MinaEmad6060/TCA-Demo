//
//  CounterFeature.swift
//  TCA Demo
//
//  Created by Mina Emad on 08/12/2025.
//
//  This feature demonstrates TCA best practices:
//  - Feature composition with Scope
//  - Delegate pattern for feature communication
//  - Nested feature state management
//

import SwiftUI
import ComposableArchitecture

@Reducer
public struct CounterFeature {
    @ObservableState
    public struct State: Equatable {
        var count: Int = 1
        var countButtonState: CountButtonFeature.State = CountButtonFeature.State()
        
        public init() {}
    }
    
    public enum Action: Equatable {
        case countButtonAction(CountButtonFeature.Action)
    }
    
    public init() {}
    
    public var body: some ReducerOf<Self> {
        Scope(
            state: \.countButtonState,
            action: \.countButtonAction
        ) {
            CountButtonFeature()
        }
        
        Reduce<State, Action> { state, action in
            switch action {
            case .countButtonAction(.delegate(let delegateAction)):
                switch delegateAction {
                case .countChanged:
                    state.count += 1
                    return .none
                }
            case .countButtonAction:
                return .none
            }
        }
    }
}
