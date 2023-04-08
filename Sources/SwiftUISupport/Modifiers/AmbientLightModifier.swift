
import SwiftUI

/**
 A modifier that adds an ambient light effect to a view.
 the ambient light is that made from the content with blur and modifying their color.
 */
public struct AmbientShadowModifier: ViewModifier {

  private let blurRadius: CGFloat

  public init(blurRadius: CGFloat = 10) {
    self.blurRadius = blurRadius
  }

  public func body(content: Content) -> some View {

    return ZStack {
      content
        .blur(radius: blurRadius)
        .saturation(1)
        .brightness(-0.2)
        .scaleEffect(x: 0.9, y: 0.9, anchor: .center)
        .offset(x: 0, y: 2)
        .compositingGroup()
      content
    }

  }

}

// make preview
struct AmbientShadowModifier_Previews: PreviewProvider {
  static var previews: some View {
    Text("Hello, World!")
      .font(.title)
      .foregroundColor(.purple)
      .modifier(AmbientShadowModifier())
  }
}

