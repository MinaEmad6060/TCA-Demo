//
//  TodoListFeature.swift
//  TCABestPracticesDemo
//
//  Created by Mina Emad on 08/12/2025.
//

import SwiftUI
import ComposableArchitecture
import IdentifiedCollections

// MARK: - Todo List Feature
// Demonstrates: Feature composition, Array state management, and parent-child communication

@Reducer
public struct TodoListFeature {
    @ObservableState
    public struct State: Equatable {
        var todos: IdentifiedArrayOf<TodoFeature.State> = []
        var newTodoText: String = ""
        
        public init() {}
    }
    
    public enum Action: Equatable {
        case addTodoButtonTapped
        case deleteTodo(IndexSet)
        case newTodoTextChanged(String)
        case todo(id: UUID, action: TodoFeature.Action)
    }
    
    public init() {}
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .addTodoButtonTapped:
                guard !state.newTodoText.trimmingCharacters(in: .whitespaces).isEmpty else {
                    return .none
                }
                state.todos.append(
                    TodoFeature.State(description: state.newTodoText)
                )
                state.newTodoText = ""
                return .none
                
            case .deleteTodo(let indexSet):
                for index in indexSet {
                    state.todos.remove(at: index)
                }
                return .none
                
            case .newTodoTextChanged(let text):
                state.newTodoText = text
                return .none
                
            case .todo(id: let id, action: _):
                // Handle todo-specific actions if needed
                return .none
            }
        }
        .forEach(\.todos, action: \.todo) {
            TodoFeature()
        }
    }
}

public struct TodoListView: View {
    let store: StoreOf<TodoListFeature>
    
    public init(store: StoreOf<TodoListFeature>) {
        self.store = store
    }
    
    public var body: some View {
        VStack(spacing: 16) {
            Text("Todo List")
                .font(.title2)
                .fontWeight(.bold)
            
            HStack {
                TextField("New todo...", text: Binding(
                    get: { store.newTodoText },
                    set: { store.send(.newTodoTextChanged($0)) }
                ))
                .textFieldStyle(.roundedBorder)
                .onSubmit {
                    store.send(.addTodoButtonTapped)
                }
                
                Button {
                    store.send(.addTodoButtonTapped)
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(.blue)
                }
                .disabled(store.newTodoText.trimmingCharacters(in: .whitespaces).isEmpty)
            }
            .padding(.horizontal)
            
            if store.todos.isEmpty {
                Spacer()
                VStack(spacing: 8) {
                    Image(systemName: "checklist")
                        .font(.system(size: 50))
                        .foregroundColor(.gray)
                    Text("No todos yet")
                        .foregroundColor(.secondary)
                    Text("Add your first todo above")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Spacer()
            } else {
                List {
                    ForEach(store.scope(state: \.todos, action: \.todo)) { todoStore in
                        TodoView(store: todoStore)
                    }
                    .onDelete { indexSet in
                        store.send(.deleteTodo(indexSet))
                    }
                }
                .listStyle(.plain)
            }
            
            Text("\(store.todos.filter { $0.isComplete }.count) of \(store.todos.count) completed")
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.bottom)
        }
    }
}

#if DEBUG
#Preview {
    TodoListView(
        store: Store(initialState: TodoListFeature.State()) {
            TodoListFeature()
        }
    )
}
#endif

