//
//  ContentView.swift
//  CJViewGRDemo
//
//  Created by qian on 2024/11/27.
//

import SwiftUI
import CJViewGR_Swift

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

struct CJViewGRExtension: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .background(Color.red)
        //            .redBackground(color: .red, cornerRadius: 10, padding: 20) // 应用自定义修饰符，添加红色背景，圆角和内边距
            
            .addGRButtons(
                onDelete: {
                    print("Delete button pressed")
                },
                onUpdate: {
                    print("Update button pressed")
                },
                onMinimize: {
                    print("Minimize button pressed")
                }
            )
            .addGR()
            .frame(width: 300, height: 300)
    }
}

// MARK: 预览 CJViewGRExtension
#Preview {
    CJViewGRExtension()
        .padding()
        .background(Color.gray)
}




#Preview {
    ContentView()
}
