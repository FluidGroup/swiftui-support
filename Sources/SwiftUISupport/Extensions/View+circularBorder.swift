import SwiftUI

extension View {

  public func smoothCircularBorder(color: Color, lineWidth: Double) -> some View {
    clipShape(Circle())
      .padding(lineWidth / 2)
      .overlay(
        Circle()
          .inset(by: lineWidth / 2)
          .stroke(color, lineWidth: lineWidth)
      )
  }

}
