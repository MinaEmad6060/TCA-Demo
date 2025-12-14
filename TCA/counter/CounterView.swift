//
//  CounterView.swift
//  TCA Demo
//
//  Created by Mina Emad on 14/12/2025.
//

import SwiftUI
import ComposableArchitecture

public struct CounterView: View {
    let store: StoreOf<CounterFeature>
    
    public init(store: StoreOf<CounterFeature>) {
        self.store = store
    }
    
    public var body: some View {
        NavigationStack {
            VStack(spacing: 32) {
                Spacer()
                
                // Counter Display
                VStack(spacing: 8) {
                    Text("\(store.count)")
                        .font(.system(size: 72, weight: .bold, design: .rounded))
                        .monospacedDigit()
                        .foregroundColor(.primary)
                    
                    Text("Current Count")
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Count Button
                CountButtonView(
                    store: store.scope(
                        state: \.countButtonState,
                        action: \.countButtonAction
                    )
                )
                .padding(.horizontal)
                
                Spacer()
            }
            .navigationTitle("Counter")
            .navigationBarTitleDisplayMode(.large)
        }
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

