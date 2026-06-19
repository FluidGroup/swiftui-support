import SwiftUI

extension View {

  /**
   [Extension]
   */
  public func foregroundMaskStyle<Style: ShapeStyle & View>(_ gradient: Style) -> some View {

    self
      .hidden()
      .overlay(
        gradient
          .aspectRatio(nil, contentMode: .fill)
      )
      .mask(self)
  }

}
