//
//  TodoView.swift
//  TCA Demo
//
//  Created by Mina Emad on 14/12/2025.
//

import SwiftUI
import ComposableArchitecture

// MARK: - Todo View
public struct TodoView: View {
    let store: StoreOf<TodoFeature>
    
    public init(store: StoreOf<TodoFeature>) {
        self.store = store
    }
    
    public var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                // Add Todo Section
                HStack {
                    TextField(
                        "New todo...",
                        text: Binding(
                            get: { store.newTodoDescription },
                            set: { store.send(.newTodoDescriptionChanged($0)) }
                        )
                    )
                    .textFieldStyle(.roundedBorder)
                    
                    Button("Add") {
                        store.send(.addTodoButtonTapped)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(store.newTodoDescription.trimmingCharacters(in: .whitespaces).isEmpty)
                }
                .padding(.horizontal)
                
                // Todo List
                if store.todos.isEmpty {
                    Spacer()
                    VStack(spacing: 8) {
                        Image(systemName: "checklist")
                            .font(.system(size: 48))
                            .foregroundColor(.secondary)
                        Text("No todos yet")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        Text("Add a todo to get started")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                } else {
                    List {
                        ForEach(store.todos) { todo in
                            HStack {
                                Button {
                                    store.send(.toggleTodo(id: todo.id))
                                } label: {
                                    Image(systemName: todo.isComplete ? "checkmark.circle.fill" : "circle")
                                        .foregroundColor(todo.isComplete ? .green : .gray)
                                }
                                .buttonStyle(.plain)
                                
                                Text(todo.description)
                                    .strikethrough(todo.isComplete)
                                    .foregroundColor(todo.isComplete ? .secondary : .primary)
                                
                                Spacer()
                            }
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    store.send(.deleteTodo(id: todo.id))
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Todos")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

#if DEBUG
#Preview {
    TodoView(
        store: Store(initialState: TodoFeature.State()) {
            TodoFeature()
        }
    )
}
#endif


