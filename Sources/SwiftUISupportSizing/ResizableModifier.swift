import SwiftUI

/// A `ViewModifier` that scales its content to fill the available space.
///
/// This modifier measures the original size of the content view, and then scales
/// it proportionally to fit the available space while maintaining its aspect ratio.
/// The scaling is only applied when `isEnabled` is true.
///
/// To use this modifier, add it to your view by calling the `.modifier(_:)` function
/// and passing an instance of `ResizableModifier`:
///
/// ```
/// yourView
///   .modifier(ResizableModifier(isEnabled: true))
/// ```
public struct ResizableModifier: ViewModifier {

  /// The original content size, which is updated when the content size changes.
  @State var contentSize: CGSize = .zero

  /// Indicates whether the scaling behavior is enabled.
  private let isEnabled: Bool

  /// Initializes a new `ResizableModifier` with the specified parameters.
  ///
  /// - Parameter isEnabled: Determines if the scaling behavior should be enabled.
  public init(
    isEnabled: Bool
  ) {
    self.isEnabled = isEnabled
  }

  /// Applies the scaling behavior to the content view.
  ///
  /// This function is responsible for measuring the content view's size and applying
  /// the scaling effect based on the available space.
  ///
  /// - Parameter content: The content view to be scaled.
  /// - Returns: A view that represents the original content view with the scaling effect applied.
  public func body(content: Content) -> some View {

    ZStack {
      Color.clear
        .fixedSize(horizontal: !isEnabled, vertical: !isEnabled)
      content
        .measureSize($contentSize)
    }
    .hidden()
    .overlay(
      GeometryReader { proxy in
        let placementSize = proxy.size
        content
          .scaleEffect(
            x: placementSize.width / contentSize.width,
            y: placementSize.height / contentSize.height,
            anchor: .topLeading
          )
      }
    )

  }
}

#if DEBUG
struct BookScalingFrame: View, PreviewProvider {
  var body: some View {
    Content()
  }

  static var previews: some View {
    Self()
  }

  private struct Content: View {

    @State var flag = false

    var body: some View {

      VStack {
        HStack {
          Text("Hello")
          //            Color.blue
          Text("Hello")
        }
        .modifier(ResizableModifier(isEnabled: flag))

        .background(Color.red)
        .frame(width: flag ? 200 : nil, height: flag ? 200 : nil)

        Text("Hello")
          .background(Color.red)

        Button("Toggle \(flag.description)") {
          withAnimation(.interactiveSpring(response: 0.8, dampingFraction: 1, blendDuration: 0)) {
            flag.toggle()
          }
        }
      }

    }
  }

}

#endif
