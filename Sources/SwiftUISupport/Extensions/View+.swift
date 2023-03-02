
import SwiftUI

public enum CornerRoundingMode {

  /// high-performance
  case clip(color: Color)
  /// much expensive
  case mask
}

extension View {

  /// [App-Extension]
  @ViewBuilder
  public func cornerRadius(_ radius: CGFloat, style: RoundedCornerStyle, mode: CornerRoundingMode = .mask) -> some View {

    switch mode {
    case .mask:
      clipShape(
        RoundedRectangle(cornerRadius: radius, style: style)
      )
    case .clip(let color):
      overlay(
        ClippingMask(cornerRadius: radius)
          .foregroundColor(color)
      )
    }

  }
  
  /// [extension]
  public func frame(square: CGFloat, alignment: Alignment = .center) -> some View {
    
    return frame(width: square, height: square, alignment: alignment)
    
  }
  
}

import Combine

extension View {
  
  /// A backwards compatible wrapper for iOS 14 `onChange`
  /// Based on https://betterprogramming.pub/implementing-swiftui-onchange-support-for-ios13-577f9c086c9
  @ViewBuilder
  @inlinable
  public func _onChange<T: Equatable>(of value: T, perform: @escaping (T) -> Void) -> some View {
    if #available(iOS 14.0, *) {
      self.onChange(of: value, perform: perform)
    } else {
      self.onReceive(Just(value)) { (value) in
        perform(value)
      }
    }
  }
  
  public func _transaction<Value: Equatable>(transform: @escaping (inout Transaction) -> Void, value: Value) -> some View {
    modifier(TransactionModifiedContent(value: value, transform: transform))
  }
}

private struct TransactionModifiedContent<Value: Equatable>: ViewModifier {
  
  @State var previousValue: Value
  
  let value: Value
  let transform: (inout Transaction) -> Void
  
  init(value: Value, transform: @escaping (inout Transaction) -> Void) {
    self._previousValue = .init(initialValue: value)
    self.value = value
    self.transform = transform
  }
  
  func body(content: Content) -> some View {
    content._onChange(of: value) { newValue in
      previousValue = newValue
    }
    .transaction { transaction in
      guard previousValue != value else {
        return
      }
      transform(&transaction)
    }
  }
  
}

