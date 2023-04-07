
import SwiftUI

/// Animatable Translation Effect
@_spi(Internal)
public struct XTranslationEffect: GeometryEffect {

  public var offset: CGFloat = .zero

  public init(offset: CGFloat) {
    self.offset = offset
  }

  public var animatableData: CGFloat {
    get {
      offset
    }
    set {
      offset = newValue
    }
  }

  public func effectValue(size: CGSize) -> ProjectionTransform {
    return .init(.init(translationX: offset, y: 0))
  }

}

/// Animatable Translation Effect
@_spi(Internal)
public struct YTranslationEffect: GeometryEffect {

  public var offset: CGFloat = .zero

  public init(offset: CGFloat) {
    self.offset = offset
  }

  public var animatableData: CGFloat {
    get {
      offset
    }
    set {
      offset = newValue
    }
  }

  public func effectValue(size: CGSize) -> ProjectionTransform {
    return .init(.init(translationX: 0, y: offset))
  }

}

extension View {

  /// Applies offset effect that is animatable against ``SwiftUI/View/offset``
  public func animatableOffset(x: CGFloat) -> some View {
    self.modifier(XTranslationEffect(offset: x))
  }

  /// Applies offset effect that is animatable against ``SwiftUI/View/offset``
  public func animatableOffset(y: CGFloat) -> some View {
    self.modifier(YTranslationEffect(offset: y))
  }

  /// Applies offset effect that is animatable against ``SwiftUI/View/offset``
  public func animatableOffset(x: CGFloat, y: CGFloat) -> some View {
    self.animatableOffset(x: x).animatableOffset(y: y)
  }

}
