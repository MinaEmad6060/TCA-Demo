//
//  CounterFeature.swift
//  TCABestPracticesDemo
//
//  Created by Mina Emad on 08/12/2025.
//

import SwiftUI
import ComposableArchitecture

// MARK: - Counter Feature
// Demonstrates: Basic state management, Actions, and Reducers

@Reducer
public struct CounterFeature {
    @ObservableState
    public struct State: Equatable {
        var count: Int = 0
        
        public init() {}
    }
    
    public enum Action: Equatable {
        case incrementButtonTapped
        case decrementButtonTapped
        case resetButtonTapped
    }
    
    public init() {}
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .incrementButtonTapped:
                state.count += 1
                return .none
                
            case .decrementButtonTapped:
                state.count -= 1
                return .none
                
            case .resetButtonTapped:
                state.count = 0
                return .none
            }
        }
    }
}

public struct CounterView: View {
    let store: StoreOf<CounterFeature>
    
    public init(store: StoreOf<CounterFeature>) {
        self.store = store
    }
    
    public var body: some View {
        VStack(spacing: 20) {
            Text("Counter")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("\(store.count)")
                .font(.system(size: 64, weight: .bold))
                .foregroundColor(.blue)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
            
            HStack(spacing: 16) {
                Button {
                    store.send(.decrementButtonTapped)
                } label: {
                    Image(systemName: "minus.circle.fill")
                        .font(.title)
                        .foregroundColor(.red)
                }
                
                Button {
                    store.send(.resetButtonTapped)
                } label: {
                    Text("Reset")
                        .padding(.horizontal, 24)
                        .padding(.vertical, 8)
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
                Button {
                    store.send(.incrementButtonTapped)
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.title)
                        .foregroundColor(.green)
                }
            }
        }
        .padding()
    }
}

#if DEBUG
#Preview {
    CounterView(
        store: Store(initialState: CounterFeature.State()) {
            CounterFeature()
        }
    )
}
#endif
