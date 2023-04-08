
import SwiftUI

public struct StyleModifier: ViewModifier {
  
  public let opacity: Double
  public let scale: CGSize
  public let offset: CGSize
  public let blurRadius: Double
  
  public init(
    opacity: Double = 1,
    scale: CGSize = .init(width: 1, height: 1),
    offset: CGSize = .zero,
    blurRadius: Double = 0
  ) {
    self.opacity = opacity
    self.scale = scale
    self.offset = offset
    self.blurRadius = blurRadius
  }
  
  public func body(content: Content) -> some View {
    
    content
      .opacity(opacity)
      .scaleEffect(scale)
      .animatableOffset(x: offset.width, y: offset.height)
      .offset(offset)
      .blur(radius: blurRadius)
  }

  public static var identity: Self {
    .init()
  }


}

extension View {
  
  /**
   [Custom-Extenstion]
   Applies given modifier conditionally.
   if condition is yes, modifier for the active will be active.
   */
  public func modifier<Modifier: ViewModifier>(
    _ type: Modifier.Type? = nil,
    condition: Bool,
    identity: Modifier,
    active: Modifier
  ) -> some View {
    modifier(condition ? active : identity)
  }
  
}
