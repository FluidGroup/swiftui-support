import SwiftUI

extension View {
  /// Applies the given transform if the given condition evaluates to `true`.
  /// @see Referenced from: https://www.avanderlee.com/swiftui/conditional-view-modifier/
  /// - Parameters:
  ///   - condition: The condition to evaluate.
  ///   - transform: The transform to apply to the source `View`.
  /// - Returns: Either the original `View` or the modified `View` if the condition is `true`.
  @ViewBuilder public func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
    if condition {
      transform(self)
    } else {
      self
    }
  }

  @ViewBuilder
  public func `do`<Content: View>(
    @ViewBuilder transform: (Self) -> Content
  ) -> some View {
    transform(self)
  }
}
