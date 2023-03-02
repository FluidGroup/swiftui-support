import SwiftUI

/**
 an inverted masked rounded rectangle
 */
public struct ClippingMask: View {

  private struct _Shape: Shape {

    private let cornerRadius: CGFloat

    init(cornerRadius: CGFloat) {
      self.cornerRadius = cornerRadius
    }

    func path(in rect: CGRect) -> Path {
      var path = Rectangle()
        .path(in: rect)
      path.addPath(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous).path(in: rect))
      return path
    }
  }

  private let cornerRadius: CGFloat

  public init(cornerRadius: CGFloat) {
    self.cornerRadius = cornerRadius
  }

  public var body: some View {
    _Shape(cornerRadius: cornerRadius)
      .fill(style: FillStyle(eoFill: true, antialiased: false))
  }
}

