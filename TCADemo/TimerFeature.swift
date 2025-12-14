//
//  TimerFeature.swift
//  TCABestPracticesDemo
//
//  Created by Mina Emad on 08/12/2025.
//

import SwiftUI
import ComposableArchitecture
import Foundation

// MARK: - Timer Feature
// Demonstrates: Effects, Async operations, Cancellation, and Time-based state updates

@Reducer
public struct TimerFeature {
    @ObservableState
    public struct State: Equatable {
        var elapsedTime: TimeInterval = 0
        var isRunning: Bool = false
        
        public init() {}
    }
    
    public enum Action: Equatable {
        case startButtonTapped
        case stopButtonTapped
        case resetButtonTapped
        case timerTick
    }
    
    public init() {}
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .startButtonTapped:
                state.isRunning = true
                return .run { send in
                    while true {
                        try await Task.sleep(for: .seconds(0.1))
                        await send(.timerTick)
                    }
                }
                .cancellable(id: TimerID.self)
                
            case .stopButtonTapped:
                state.isRunning = false
                return .cancel(id: TimerID.self)
                
            case .resetButtonTapped:
                state.elapsedTime = 0
                state.isRunning = false
                return .cancel(id: TimerID.self)
                
            case .timerTick:
                state.elapsedTime += 0.1
                return .none
            }
        }
    }
    
    private struct TimerID: Hashable {}
}

public struct TimerView: View {
    let store: StoreOf<TimerFeature>
    
    public init(store: StoreOf<TimerFeature>) {
        self.store = store
    }
    
    private var formattedTime: String {
        let minutes = Int(store.elapsedTime) / 60
        let seconds = Int(store.elapsedTime) % 60
        let milliseconds = Int((store.elapsedTime.truncatingRemainder(dividingBy: 1)) * 10)
        return String(format: "%02d:%02d.%d", minutes, seconds, milliseconds)
    }
    
    public var body: some View {
        VStack(spacing: 20) {
            Text("Timer")
                .font(.title2)
                .fontWeight(.bold)
            
            Text(formattedTime)
                .font(.system(size: 48, weight: .bold, design: .monospaced))
                .foregroundColor(.blue)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
            
            HStack(spacing: 16) {
                if store.isRunning {
                    Button {
                        store.send(.stopButtonTapped)
                    } label: {
                        Label("Stop", systemImage: "stop.fill")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                } else {
                    Button {
                        store.send(.startButtonTapped)
                    } label: {
                        Label("Start", systemImage: "play.fill")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                
                Button {
                    store.send(.resetButtonTapped)
                } label: {
                    Label("Reset", systemImage: "arrow.counterclockwise")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
        }
        .padding()
    }
}

#if DEBUG
#Preview {
    TimerView(
        store: Store(initialState: TimerFeature.State()) {
            TimerFeature()
        }
    )
}
#endif

