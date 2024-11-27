//
//  ContentView.swift
//  CJViewGRDemo
//
//  Created by qian on 2024/11/27.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
//        VStack {
//            Image(systemName: "globe")
//                .imageScale(.large)
//                .foregroundStyle(.tint)
//            Text("Hello, world!")
//        }
//        .padding()
        
        VStack {
            CJViewGRExtension()
        }
        .frame(width: 200, height: 200)
        .background(Color.green)
        
    }
}

#Preview {
    ContentView()
}
