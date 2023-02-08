import SwiftUI

extension Text {
  
  /**
   [Extension]
   */
  public func foregroundLinearGradient(_ gradient: LinearGradient) -> some View {
    self.overlay(gradient).mask(self)
  }
  
}

