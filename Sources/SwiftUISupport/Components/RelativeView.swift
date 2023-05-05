import SwiftUI

public enum RelativeHorizontalPosition {
  case left
  case center
  case right
}

public enum RelativeVerticalPosition {
  case top
  case center
  case bottom
}

/// A container view that places the content in the specified position.
/// A useful case will be placing the content on the corner of the parent view.
@available(*, deprecated, message: "Use modifier instead")
public struct RelativeView<Content: View>: View {

  public let content: Content
  public let vertical: RelativeVerticalPosition
  public let horizontal: RelativeHorizontalPosition

  public init(
    vertical: RelativeVerticalPosition,
    horizontal: RelativeHorizontalPosition,
    @ViewBuilder content: () -> Content
  ) {
    self.vertical = vertical
    self.horizontal = horizontal
    self.content = content()
  }

  public var body: some View {

    let horizontalContent: some View = HStack {
      switch horizontal {
      case .left:
        content
        Spacer(minLength: 0)
      case .center:
        content
      case .right:
        Spacer(minLength: 0)
        content
      }
    }

    VStack {
      switch vertical {
      case .top:
        horizontalContent
        Spacer(minLength: 0)
      case .center:
        horizontalContent
      case .bottom:
        Spacer(minLength: 0)
        horizontalContent
      }
    }

  }
}

/// like align-self
public struct RelativeLayoutModifier: ViewModifier {

  public enum HorizontalPosition {
    case leading
    case center
    case trailing
  }

  public enum VerticalPosition {
    case top
    case center
    case bottom
  }

  public let vertical: VerticalPosition
  public let horizontal: HorizontalPosition

  public init(
    vertical: VerticalPosition,
    horizontal: HorizontalPosition
  ) {
    self.vertical = vertical
    self.horizontal = horizontal
  }

  public func body(content: Content) -> some View {
    let horizontalContent: some View = HStack {
      switch horizontal {
      case .leading:
        content
        Spacer(minLength: 0)
      case .center:
        content
      case .trailing:
        Spacer(minLength: 0)
        content
      }
    }

    VStack {
      switch vertical {
      case .top:
        horizontalContent
        Spacer(minLength: 0)
      case .center:
        horizontalContent
      case .bottom:
        Spacer(minLength: 0)
        horizontalContent
      }
    }
  }

}

extension View {

  /**
   * Lays out the view and positions it within the layout bounds according to vertical and horizontal positional specifiers.
   *  Can position the child at any of the 4 corners, or the middle of any of the 4 edges, as well as the center - similar to "9-part" image areas.
   */
  public func relative(
    vertical: RelativeLayoutModifier.VerticalPosition = .center,
    horizontal: RelativeLayoutModifier.HorizontalPosition = .center
  ) -> some View {
    self.modifier(RelativeLayoutModifier(vertical: vertical, horizontal: horizontal))
  }

}

enum Preview_AnchorView: PreviewProvider {

  static var previews: some View {
    Rectangle()
      .frame(width: 50, height: 50)
      .overlay(
        RelativeView(vertical: .top, horizontal: .right) {
          Circle()
            .foregroundColor(.red)
            .frame(width: 20, height: 20)
        }
        .offset(x: 10, y: -10)
      )

    Rectangle()
      .frame(width: 50, height: 50)
      .overlay(
        Circle()
          .foregroundColor(.red)
          .frame(width: 20, height: 20)
          .relative(vertical: .top, horizontal: .trailing)
          .offset(x: 10, y: -10)
      )

    HStack {
      Text("A")
      Text("B")
      Text("C")
    }
    .environment(\.layoutDirection, .rightToLeft)

  }

}
