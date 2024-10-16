import SwiftUI

#Preview("Using Aligment guide") {

  Rectangle()
    .frame(width: 50, height: 50)
    .anchoring {
      Circle()
        .fill(.blue)
    }
    .background(Color.purple)
}

extension View {

  public func anchoring(@ViewBuilder content: () -> some View) -> some View {
    overlay(alignment: .topTrailing) {
      content()
        .alignmentGuide(.top) { d in
          d[.top] + d.height / 2
        }
        .alignmentGuide(.trailing) { d in
          d[.trailing] - d.width / 2
        }
    }
  }

}
