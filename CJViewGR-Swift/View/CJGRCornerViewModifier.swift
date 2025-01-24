//
//  CJGRCornerView.swift
//  CJViewGRDemo
//
//  Created by qian on 2024/11/28.
//

import SwiftUI

// MARK: - 使用ViewModifier为View实现一个扩展，将其添加到一个视图中，该视图中有添加进来的view，view的边缘有边框以及有三个位于该view左上的删除、右上的更新、右下的缩小按钮。
public struct CJGRCornerViewModifier: ViewModifier {
    let onDelete: (() -> Void)
    let onUpdate: (() -> Void)
    let onMinimize: (() -> Void)

    public func body(content: Content) -> some View {
//        GeometryReader { geometry in
//            ZStack {
                content
                    .overlay(content: {
                        CJGRCornerView(zoom: 0.50, onDelete: onDelete, onUpdate: onUpdate, onMinimize: onMinimize)
                    })
//                    .frame(width: geometry.size.width, height: geometry.size.height)
//
//
//            }
//            .frame(width: geometry.size.width, height: geometry.size.height) // 限制 ZStack 的大小
//        }
    }
}

public struct CJGRCornerView: View {
    public var zoom: CGFloat
    public var onDelete: (() -> Void)?
    public var onUpdate: (() -> Void)?
    public var onMinimize: (() -> Void)?
    
    public init(zoom: CGFloat, onDelete: ( () -> Void)? = nil, onUpdate: ( () -> Void)? = nil, onMinimize: ( () -> Void)? = nil) {
        self.zoom = zoom
        self.onDelete = onDelete
        self.onUpdate = onUpdate
        self.onMinimize = onMinimize
    }
    
    public var body: some View {
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



// MARK: 预览 CJGRCornerView
struct CJGRCornerView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Text("Hello, World!")
                .background(Color.red)
        }
        .frame(width: 200, height: 200)
        .background(Color.green)
        .overlay(content: {
            CJGRCornerView(zoom: 1)
        })
    }
}
