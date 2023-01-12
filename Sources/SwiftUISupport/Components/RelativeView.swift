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

/**
 A container view that places the content in the specified position.
 A useful case will be placing the content on the corner of the parent view.
 */
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
        Spacer()
      case .center:
        content
      case .right:
        Spacer()
        content
      }
    }

    VStack {
      switch vertical {
      case .top:
        horizontalContent
        Spacer()
      case .center:
        horizontalContent
      case .bottom:
        Spacer()
        horizontalContent
      }
    }

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
  }
}
