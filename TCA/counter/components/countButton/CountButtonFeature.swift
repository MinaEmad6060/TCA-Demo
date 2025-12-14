//
//  CountButtonFeature.swift
//  TCA Demo
//
//  Created by Mina Emad on 08/12/2025.
//
//  This feature demonstrates TCA best practices:
//  - Child feature with delegate pattern
//  - Feature communication through actions
//

import SwiftUI
import ComposableArchitecture

@Reducer
public struct CountButtonFeature {
    @ObservableState
    public struct State: Equatable {
        public init() {}
    }
    
    public enum Action: Equatable {
        case countButtonTapped
        case delegate(Delegate)
        
        public enum Delegate: Equatable {
            case countChanged
        }
    }
    
    public init() {}
    
    public var body: some ReducerOf<Self> {
        Reduce<State, Action> { state, action in
            switch action {
            case .countButtonTapped:
                return .send(.delegate(.countChanged))
            case .delegate:
                return .none
            }
        }
    }
}
