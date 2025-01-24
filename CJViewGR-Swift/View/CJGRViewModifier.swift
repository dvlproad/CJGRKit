//
//  CJGRCornerView.swift
//  CJViewGRDemo
//
//  Created by qian on 2024/11/28.
//

import SwiftUI


// 自定义ViewModifier，接受参数以自定义红色背景视图的样式
public struct CJGRViewModifier: ViewModifier {
//    @ObservedObject public var imageModel: GRImageModel

    public func body(content: Content) -> some View {
        let maxScale = 6.0

        // 缩放手势
        let magnificationGesture = MagnificationGesture()
            .onChanged { value in
//                imageModel.scale = min(value * imageModel.lastScale, maxScale)
            }
            .onEnded { _ in
//                imageModel.lastScale = imageModel.scale
            }

        // 旋转手势
        let rotationGesture = RotationGesture()
            .onChanged { value in
//                imageModel.currentRotationDegrees = value.degrees + imageModel.lastRotationDegrees
            }
            .onEnded { _ in
//                imageModel.lastRotationDegrees = imageModel.currentRotationDegrees
            }

        // 拖动手势
        let dragGesture = DragGesture()
            .onChanged { value in
//                imageModel.dragOffset = value.translation
            }
            .onEnded { _ in
//                imageModel.position.width += imageModel.dragOffset.width
//                imageModel.position.height += imageModel.dragOffset.height
//                imageModel.dragOffset = .zero
            }

        // 合并手势
        let combinedGestures = magnificationGesture
            .simultaneously(with: rotationGesture)
            .simultaneously(with: dragGesture)

        // 修改内容视图
        return content
//            .scaleEffect(imageModel.scale)
//            .rotationEffect(.degrees(imageModel.currentRotationDegrees))
//            .offset(x: imageModel.position.width + imageModel.dragOffset.width,
//                    y: imageModel.position.height + imageModel.dragOffset.height)
            .gesture(combinedGestures)
    }
}


/*
public class GRImageModel: ObservableObject, Identifiable {
    public let id: UUID = UUID()
    public init() {
        
    }
    
    /// 是否可以替换图片
    var isReplaceable: Bool = true
    /// 是否是可拖拽的
    var isDraggable: Bool = true
    /// 图片默认显示大小
    var imageSize: CGSize = .zero
    /// 图片实际显示大小
    var size: CGSize {
        CGSize(width: imageSize.width * scale, height: imageSize.height * scale)
    }
    var lastSize: CGSize {
        CGSize(width: imageSize.width * lastScale, height: imageSize.height * lastScale)
    }
    // 当前缩放比例
    var scale: CGFloat = 1 {
        didSet {
            objectWillChange.send()
        }
    }
    // 起始拖动位置
    var dragOffset: CGSize = .zero {
        didSet {
            objectWillChange.send()
        }
    }
    
    var position: CGSize = .zero {
        didSet {
            objectWillChange.send()
        }
    }
    
    var currentRotationDegrees: Double = 0 {
        didSet {
            objectWillChange.send()
        }
    }
    
    var lastScale: CGFloat = 1 {
        didSet {
            objectWillChange.send()
        }
    }
    
    var lastRotationDegrees: Double = 0
    {
        didSet {
            objectWillChange.send()
        }
    }
    
    ///
    var origin: CGPoint?
    
    var rotation: Angle {
        Angle(degrees: currentRotationDegrees)
    }
    var offset: CGSize {
        CGSize(width: dragOffset.width + position.width, height: dragOffset.height + position.height)
    }
}
*/

