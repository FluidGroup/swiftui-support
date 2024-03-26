import SwiftUI

extension View {

  /**
   [Extension]
   */
  public func foregroundLinearGradient(_ gradient: LinearGradient) -> some View {

    self
      .hidden()
      .overlay(
        gradient
          .aspectRatio(nil, contentMode: .fill)
      )
      .mask(self)
  }

}
