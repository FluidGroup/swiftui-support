import SwiftUI

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

#Preview {
  Rectangle()
    .frame(width: 50, height: 50)
    .overlay(
      Circle()
        .foregroundColor(.red)
        .frame(width: 20, height: 20)
        .relative(vertical: .top, horizontal: .trailing)
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

#Preview("Using Aligment guide") {
  
  Rectangle()
    .frame(width: 50, height: 50)
    .overlay(alignment: .topTrailing) {
      Circle()
        .fill(.blue)
        .frame(width: 20, height: 20)
        .alignmentGuide(.top) { d in
          return d[.top] + d.height / 2
        }
        .alignmentGuide(.trailing) { d in
          return d[.trailing] - d.width / 2
        }
    }
    .background(Color.purple)
}
