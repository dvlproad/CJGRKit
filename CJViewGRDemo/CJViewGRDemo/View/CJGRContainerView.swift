//
//  CJGRContainerView.swift
//  CJViewGRDemo
//
//  Created by qian on 2024/11/28.
//

import SwiftUI

struct CJGRContainerView: View {
    var zoom: CGFloat
    var onDelete: (() -> Void)?
    var onUpdate: (() -> Void)?
    var onMinimize: (() -> Void)?
    
    var body: some View {
        GeometryReader { geometry in
            let size: CGSize = CGSize(width: 23 * zoom, height: 23 * zoom)
            ZStack {
                Rectangle()
                    .stroke(Color.black, lineWidth: zoom * 2)  // 添加蓝色的边框
                    .padding(-zoom * 2)
                
                Image("photoEdit_close")
                    .resizable()
                    .frame(width: size.width, height: size.height, alignment: .center)
                    .position(CGPoint(x: 0.0, y: 0.0))
                    .onTapGesture {
                        onDelete?()
                    }
                
                if onUpdate != nil {
                    Image("photoEdit_replace")
                        .resizable()
                        .frame(width: size.width, height: size.height, alignment: .center)
                        .position(x: geometry.size.width, y: 0)
                        .onTapGesture {
                            onUpdate?()
                        }
                }
                
                Image("photoEdit_enlarge")
                    .resizable()
                    .frame(width: size.width, height: size.height, alignment: .center)
                    .position(x: geometry.size.width, y: geometry.size.height)
                
            }
        }
    }
}



// MARK: 预览 CJGRContainerView
struct CJGRContainerView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Text("Hello, World!").background(Color.red)
            
            CJGRContainerView(zoom: 0.8)
        }
        .frame(width: 200, height: 200)
        .background(Color.green)
    }
}
