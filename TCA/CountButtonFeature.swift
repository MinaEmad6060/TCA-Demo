//
//  CountButtonFeature.swift
//  TCA
//
//  Created by Mina Emad on 08/12/2025.
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

public struct CountButtonView: View {
    let store: StoreOf<CountButtonFeature>
    
    public init(store: StoreOf<CountButtonFeature>) {
        self.store = store
    }
    
    public var body: some View {
        Button("Count") {
            store.send(.countButtonTapped)
        }
    }
}

#if DEBUG
#Preview {
    CountButtonView(
        store: Store(initialState: CountButtonFeature.State()) {
            CountButtonFeature()
        }
    )
}
#endif

