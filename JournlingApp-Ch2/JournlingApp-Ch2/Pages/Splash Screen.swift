//
//  ContentView.swift
//  JournlingApp-Ch2
//
//  Created by Elham Alhemidi on 24/04/1447 AH.
//

import SwiftUI

struct ContentView: View {
    @State private var isShowingEmptyState = false

    var body: some View {
        NavigationStack {
            ZStack {
                (Color(hex: "141420") ?? .black)
                    .ignoresSafeArea()

                VStack(spacing: 12) {
                    Image("book icon 1")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 77.7, height: 101)
                        .foregroundStyle(.tint)

                    Text("Journali")
                        .font(.system(size: 42, weight: .black))
                        .foregroundColor(.white)

                    Text("Your thoughts, your story")
                        .font(.system(size: 18, weight: .light))
                        .foregroundColor(.white)
                }
                .padding()
            }
            .navigationDestination(isPresented: $isShowingEmptyState) {
                EmptyState()
                    .navigationBarBackButtonHidden(true)
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    isShowingEmptyState = true
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
