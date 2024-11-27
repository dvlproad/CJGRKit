//
//  CJViewGRExtension.swift
//  CJViewGRDemo
//
//  Created by qian on 2024/11/27.
//

import SwiftUI

struct CJViewGRExtension: View {
    var body: some View {
        let grModel = YDImageModel()
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
            .addGR(grModel: grModel)
            .frame(width: 300, height: 300)
    }
}





// 扩展View，添加一个修饰符，用于应用RedBackgroundModifier
extension View {
    func redBackground(color: Color = .red, cornerRadius: CGFloat = 0, padding: CGFloat = 0) -> some View {
        self.modifier(
            RedBackgroundModifier(color: color,
                                  cornerRadius: cornerRadius,
                                  padding: padding)
        )
    }
    
    
    func addGR(enableGR: Bool = true, grModel: YDImageModel, showCornerButton: Bool = true) -> some View {
        self.modifier(
            GestureViewModifier(imageModel: grModel)
        )
    }
    
    
    // 为视图添加边框和三个角按钮
    func addGRButtons(onDelete: @escaping () -> Void,
                      onUpdate: @escaping () -> Void,
                      onMinimize: @escaping () -> Void
    ) -> some View {
        self.modifier(CornerControlsModifier(
            onDelete: onDelete,
            onUpdate: onUpdate,
            onMinimize: onMinimize
        ))
    }
}





// 自定义ViewModifier，接受参数以自定义红色背景视图的样式
struct RedBackgroundModifier: ViewModifier {
    var color: Color
    var cornerRadius: CGFloat
    var padding: CGFloat

    func body(content: Content) -> some View {
        content
//            .padding(padding) // 添加内边距
            .background(color) // 应用红色背景
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius)) // 应用圆角
//            .border(Color.green, width: padding)
        
    }
}



class YDImageModel: ObservableObject, Identifiable {
    let id: UUID = UUID()
    
    var image: UIImage?
    /// 图片本地存储文件名称
    var imageFilename: String?
    /// 是否可编辑
    var isEditable: Bool = true
    /// 是否可以删除图片
    var isDeletable: Bool = true
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


// 自定义ViewModifier，接受参数以自定义红色背景视图的样式
struct GestureViewModifier: ViewModifier {
    @ObservedObject var imageModel: YDImageModel

    func body(content: Content) -> some View {
        let maxScale = 6.0

        // 缩放手势
        let magnificationGesture = MagnificationGesture()
            .onChanged { value in
                imageModel.scale = min(value * imageModel.lastScale, maxScale)
            }
            .onEnded { _ in
                imageModel.lastScale = imageModel.scale
            }

        // 旋转手势
        let rotationGesture = RotationGesture()
            .onChanged { value in
                imageModel.currentRotationDegrees = value.degrees + imageModel.lastRotationDegrees
            }
            .onEnded { _ in
                imageModel.lastRotationDegrees = imageModel.currentRotationDegrees
            }

        // 拖动手势
        let dragGesture = DragGesture()
            .onChanged { value in
                imageModel.dragOffset = value.translation
            }
            .onEnded { _ in
                imageModel.position.width += imageModel.dragOffset.width
                imageModel.position.height += imageModel.dragOffset.height
                imageModel.dragOffset = .zero
            }

        // 合并手势
        let combinedGestures = magnificationGesture
            .simultaneously(with: rotationGesture)
            .simultaneously(with: dragGesture)

        // 修改内容视图
        return content
            .scaleEffect(imageModel.scale)
            .rotationEffect(.degrees(imageModel.currentRotationDegrees))
            .offset(x: imageModel.position.width + imageModel.dragOffset.width,
                    y: imageModel.position.height + imageModel.dragOffset.height)
            .gesture(combinedGestures)
    }
}


// MARK: - 使用ViewModifier为View实现一个扩展，将其添加到一个视图中，该视图中有添加进来的view，view的边缘有边框以及有三个位于该view左上的删除、右上的更新、右下的缩小按钮。
struct CornerControlsModifier: ViewModifier {
    let onDelete: (() -> Void)
    let onUpdate: (() -> Void)
    let onMinimize: (() -> Void)

    func body(content: Content) -> some View {
//        GeometryReader { geometry in
//            ZStack {
                content
                    .overlay(content: {
                        CJGRContainerView(zoom: 0.8, onDelete: onDelete, onUpdate: onUpdate, onMinimize: onMinimize)
                    })
//                    .frame(width: geometry.size.width, height: geometry.size.height)
//
//                
//            }
//            .frame(width: geometry.size.width, height: geometry.size.height) // 限制 ZStack 的大小
//        }
    }
}

// MARK: 预览 CJViewGRExtension
#Preview {
    CJViewGRExtension()
        .padding()
        .background(Color.gray)
}


