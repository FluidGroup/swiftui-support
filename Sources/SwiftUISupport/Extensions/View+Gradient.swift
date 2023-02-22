import SwiftUI

extension Text {

  /**
   [Extension]
   */
  public func foregroundLinearGradient(_ gradient: LinearGradient) -> some View {

    self
      .overlay(
        gradient
          .aspectRatio(nil, contentMode: .fill)
      )
      .mask(self)
  }

}
