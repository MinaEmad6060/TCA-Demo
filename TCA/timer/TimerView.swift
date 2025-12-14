//
//  TimerView.swift
//  TCA Demo
//
//  Created by Mina Emad on 14/12/2025.
//

import SwiftUI
import ComposableArchitecture

public struct TimerView: View {
    let store: StoreOf<TimerFeature>
    
    public init(store: StoreOf<TimerFeature>) {
        self.store = store
    }
    
    public var body: some View {
        NavigationStack {
            VStack(spacing: 32) {
                Spacer()
                
                // Timer Display
                VStack(spacing: 8) {
                    Text(formatTime(store.elapsedTime))
                        .font(.system(size: 72, weight: .bold, design: .rounded))
                        .monospacedDigit()
                        .foregroundColor(.primary)
                    
                    Text(store.isRunning ? "Running" : "Stopped")
                        .font(.headline)
                        .foregroundColor(store.isRunning ? .green : .secondary)
                }
                
                Spacer()
                
                // Control Buttons
                HStack(spacing: 20) {
                    if store.isRunning {
                        Button {
                            store.send(.stopButtonTapped)
                        } label: {
                            Label("Stop", systemImage: "stop.fill")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.red)
                    } else {
                        Button {
                            store.send(.startButtonTapped)
                        } label: {
                            Label("Start", systemImage: "play.fill")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.green)
                    }
                    
                    Button {
                        store.send(.resetButtonTapped)
                    } label: {
                        Label("Reset", systemImage: "arrow.counterclockwise")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .disabled(store.elapsedTime == 0)
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .navigationTitle("Timer")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    private func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        let milliseconds = Int((time.truncatingRemainder(dividingBy: 1)) * 10)
        return String(format: "%02d:%02d.%d", minutes, seconds, milliseconds)
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


