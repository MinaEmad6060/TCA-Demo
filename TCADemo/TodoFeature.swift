//
//  TodoFeature.swift
//  TCABestPracticesDemo
//
//  Created by Mina Emad on 08/12/2025.
//

import SwiftUI
import ComposableArchitecture

// MARK: - Todo Feature
// Demonstrates: State management, Actions, Reducers, and View composition

@Reducer
public struct TodoFeature {
    @ObservableState
    public struct State: Equatable, Identifiable {
        public var id: UUID
        var description: String
        var isComplete: Bool
        
        public init(id: UUID = UUID(), description: String, isComplete: Bool = false) {
            self.id = id
            self.description = description
            self.isComplete = isComplete
        }
    }
    
    public enum Action: Equatable {
        case checkboxTapped
        case textFieldChanged(String)
    }
    
    public init() {}
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .checkboxTapped:
                state.isComplete.toggle()
                return .none
                
            case .textFieldChanged(let text):
                state.description = text
                return .none
            }
        }
    }
}

public struct TodoView: View {
    let store: StoreOf<TodoFeature>
    
    public init(store: StoreOf<TodoFeature>) {
        self.store = store
    }
    
    public var body: some View {
        HStack {
            Button {
                store.send(.checkboxTapped)
            } label: {
                Image(systemName: store.isComplete ? "checkmark.square" : "square")
                    .foregroundColor(store.isComplete ? .green : .gray)
            }
            .buttonStyle(.plain)
            
            TextField("Todo", text: Binding(
                get: { store.description },
                set: { store.send(.textFieldChanged($0)) }
            ))
            .strikethrough(store.isComplete)
            .foregroundColor(store.isComplete ? .secondary : .primary)
        }
        .padding(.vertical, 4)
    }
}

#if DEBUG
#Preview {
    TodoView(
        store: Store(initialState: TodoFeature.State(description: "Learn TCA")) {
            TodoFeature()
        }
    )
}
#endif

