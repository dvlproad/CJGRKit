# CJGRKit（贴纸编辑器的手势）

CJGRKit 是一个 SwiftUI 视图手势编辑组件，当前核心模块为 `CJViewGR-Swift`。它可以把任意 SwiftUI View 包装成类似贴纸编辑器中的可编辑贴纸，支持拖动、双指缩放、双指旋转、选中态角按钮，以及右下角操作柄拖拽缩放/旋转。

## 功能

- 单指拖动视图。
- 双指捏合缩放，并限制最小/最大缩放范围。
- 双指旋转，处理最小缩放附近的旋转抖动。
- 支持外部选中态控制，只有选中的视图显示边框和角按钮。
- 左上角删除按钮、右上角更新按钮。
- 右下角为贴纸编辑器操作柄，拖动时同时缩放和旋转。
- 角按钮视觉尺寸和命中区域会抵消贴纸缩放，缩小后仍然容易按住。
- 右下角按钮完整区域都在可命中范围内，不需要往按钮内侧点。

## 快速使用

基础手势能力：

```swift
MyStickerView()
    .frame(width: 240, height: 180)
    .addGR(minScale: 0.4, maxScale: 4.0)
```

带选中态和角按钮的贴纸编辑能力：

```swift
@State private var selectedID: Int?
@State private var scale: CGFloat = 1
@State private var rotationDegrees: CGFloat = 0

MyStickerView()
    .frame(width: 240, height: 180)
    .addGR(
        showCornerButton: selectedID == 1,
        onDelete: {
            // 删除当前贴纸
        },
        onUpdate: {
            // 替换或更新当前贴纸
        },
        onMinimize: nil,
        onSelect: {
            selectedID = 1
        },
        onTransformEnded: { transform in
            // 写回本次手势的相对变化
            scale *= transform.scale
            rotationDegrees += transform.rotation.degrees
        },
        baseScale: scale,
        baseRotation: .degrees(rotationDegrees),
        minScale: 0.4,
        maxScale: 4.0
    )
```

外层空白区域可以清空选中态：

```swift
ZStack {
    Color(.systemGroupedBackground)
        .ignoresSafeArea()
        .contentShape(Rectangle())
        .onTapGesture {
            selectedID = nil
        }

    // sticker views...
}
```

## 关键行为说明

`showCornerButton` 建议由业务层的选中态控制。点击、拖动、缩放、旋转或拖右下角操作柄时，组件会触发 `onSelect`，业务层据此切换当前选中的贴纸。

`baseScale` 和 `baseRotation` 用来传入业务模型里已经持久化的缩放和旋转。只要一个元素已经有持久 scale/rotation，就不要在 `.addGR(...)` 外层再写 `.scaleEffect(...)` 或 `.rotationEffect(...)`。外层 scale/rotation 会让视觉内容、编辑边框、角按钮命中区域和手势写回坐标分散在不同层，容易出现边框不贴内容、旋转后拖动跳动、缩放后文字抖动等问题。

缩放持久化有两条路线，二选一，不要混用：

1. 烘焙进内容盒子  
   手势结束后把缩放写入内容自己的 layout，例如同步修改 `width/height`，或者文本渲染时使用 `fontSize * scale`。这时下一次渲染出来的内容盒子本身已经是缩放后的尺寸，`addGR` 不需要也不应该再传同一个 `baseScale`，否则会双重缩放。

2. 独立持久 scale  
   内容仍按原始 `width/height` 渲染，缩放作为独立字段保存。这时应该把这个字段传给 `addGR(baseScale:)`，让内容、边框、角按钮和本次手势缩放都在 `addGR` 内同一套坐标系里处理。

正确顺序应该是：

```swift
content
    .frame(width: layout.width, height: layout.height)
    .addGR(
        onTransformEnded: { transform in
            layout.left += transform.translation.width
            layout.top += transform.translation.height
            layout.scale *= transform.scale
            layout.rotationDegrees += transform.rotation.degrees
        },
        baseScale: layout.scale,
        baseRotation: .degrees(layout.rotationDegrees)
    )
    .offset(x: layout.left, y: layout.top)
```

上面示例对应第 2 条路线：`layout.width/height` 是原始内容盒子尺寸，`layout.scale` 是独立持久缩放字段。如果采用第 1 条路线，示例就应该把缩放写入内容盒子，并省略 `baseScale`：

```swift
content
    .frame(width: layout.width, height: layout.height)
    .addGR(
        onTransformEnded: { transform in
            layout.left += transform.translation.width
            layout.top += transform.translation.height
            layout.width *= transform.scale
            layout.height *= transform.scale
            layout.rotationDegrees += transform.rotation.degrees
        },
        baseRotation: .degrees(layout.rotationDegrees)
    )
    .offset(x: layout.left, y: layout.top)
```

这里 `onTransformEnded` 返回的是本次手势的相对变化：`translation` 是本次拖动增量，`scale` 是本次缩放倍率，`rotation` 是本次旋转增量。外部写回模型后，`addGR` 会清掉内部临时状态，避免双重位移、双重缩放或双重旋转。

右下角按钮在完整贴纸模式下不是普通点击按钮，而是缩放/旋转操作柄。拖动它时，组件会以贴纸中心为基准，根据“中心到右下角”的向量长度变化计算缩放，根据向量角度变化计算旋转。

角按钮的最小命中区域为 44pt。组件会根据当前缩放值做反向补偿，并在贴纸内容外预留半个命中区域，保证贴纸缩小后按钮仍然好按，且按钮外侧也可以稳定响应。

`onMinimize` 是早期接口遗留命名。当前推荐的贴纸模式中右下角已作为缩放/旋转操作柄使用，因此示例中传 `nil`。旧的 `addGRButtons` 纯按钮叠加接口仍保留右下角点击回调，以兼容已有调用。

## Demo

Demo 工程位于 `CJViewGRDemo`。其中：

- `Basic Gesture Demo` 展示基础拖动、缩放、旋转。
- `Sticker Editor Demo` 展示两个贴纸视图的选中态切换、角按钮显示隐藏，以及右下角缩放/旋转操作柄。
- `Layout Input + Gesture Demo` 展示独立持久 scale 路线：内容仍按原始 `width/height` 渲染，`scale` 传给 `addGR(baseScale:)`，手势结束后只写回 `left/top/scale/rotationDegrees`。
- `Layout Model + Gesture Demo` 展示 CJViewElement 的烘焙路线：使用 `CJTextLayoutModel` 作为唯一布局状态，并通过 `Text.property(layout).layout(layout) { content in content.addGR(...) }` 渲染。该页面专门验证 `layout(decorateContent:)` 插入点：内容盒子先成型，`addGR` 再包住内容盒子，最后由 `layout` 处理 left/top。手势缩放结束后需要同步写回 `width/height/scale`，并按中心补偿 `left/top`；文本字体已通过 `fontSize * scale` 烘焙进内容，因此这里只传 `baseRotation`，不传 `baseScale`。

## 当前可优化点

- 将 `onMinimize` 重命名为更贴近语义的 `onResizeHandleTap` 或移除完整贴纸模式下的该参数。目前为了兼容旧接口暂时保留。
- 提供可配置的角按钮资源、边框颜色、线宽和最小命中尺寸。
- 抽出可外部持有的贴纸状态模型，便于保存和恢复贴纸的 `scale`、`rotation`、`position`。
- 为选中态和右下角操作柄增加单元测试或 UI 测试，覆盖多个贴纸切换、缩小后拖拽、旋转后继续缩放等场景。
