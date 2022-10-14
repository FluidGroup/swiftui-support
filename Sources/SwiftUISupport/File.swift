
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
      .offset(offset)
      .blur(radius: blurRadius)
  }
  
}

extension View {
  
  public func modifier<Modifier: ViewModifier>(
    condition: Bool,
    initial: Modifier,
    active: Modifier
  ) -> some View {
    modifier(condition ? initial : active)
  }
  
}
