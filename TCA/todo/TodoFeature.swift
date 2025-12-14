//
//  TodoFeature.swift
//  TCA Demo
//
//  Created by Mina Emad on 08/12/2025.
//
//  This feature demonstrates TCA best practices:
//  - State management with Equatable
//  - Action-based architecture
//  - Feature composition
//  - Testability

import SwiftUI
import ComposableArchitecture

// MARK: - Todo Model
public struct Todo: Equatable, Identifiable {
    public let id: UUID
    public var description: String
    public var isComplete: Bool
    
    public init(
        id: UUID = UUID(),
        description: String,
        isComplete: Bool = false
    ) {
        self.id = id
        self.description = description
        self.isComplete = isComplete
    }
}

// MARK: - Todo Feature
@Reducer
public struct TodoFeature {
    @ObservableState
    public struct State: Equatable {
        var todos: IdentifiedArrayOf<Todo> = []
        var newTodoDescription: String = ""
        
        public init() {}
    }
    
    public enum Action: Equatable {
        case addTodoButtonTapped
        case deleteTodo(id: UUID)
        case toggleTodo(id: UUID)
        case newTodoDescriptionChanged(String)
    }
    
    public init() {}
    
    public var body: some ReducerOf<Self> {
        Reduce<State, Action> { state, action in
            switch action {
            case .addTodoButtonTapped:
                guard !state.newTodoDescription.trimmingCharacters(in: .whitespaces).isEmpty else {
                    return .none
                }
                let todo = Todo(description: state.newTodoDescription)
                state.todos.append(todo)
                state.newTodoDescription = ""
                return .none
                
            case let .deleteTodo(id):
                state.todos.remove(id: id)
                return .none
                
            case let .toggleTodo(id):
                if let index = state.todos.index(id: id) {
                    state.todos[index].isComplete.toggle()
                }
                return .none
                
            case let .newTodoDescriptionChanged(description):
                state.newTodoDescription = description
                return .none
            }
        }
    }
}
