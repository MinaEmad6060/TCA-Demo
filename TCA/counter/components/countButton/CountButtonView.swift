//
//  CountButtonView.swift
//  TCA Demo
//
//  Created by Mina Emad on 14/12/2025.
//

import SwiftUI
import ComposableArchitecture

public struct CountButtonView: View {
    let store: StoreOf<CountButtonFeature>
    
    public init(store: StoreOf<CountButtonFeature>) {
        self.store = store
    }
    
    public var body: some View {
        Button {
            store.send(.countButtonTapped)
        } label: {
            Label("Increment", systemImage: "plus.circle.fill")
                .frame(maxWidth: .infinity)
                .font(.headline)
        }
        .buttonStyle(.borderedProminent)
        .controlSize(.large)
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

