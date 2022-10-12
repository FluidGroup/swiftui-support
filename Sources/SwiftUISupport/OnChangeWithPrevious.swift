
import SwiftUI
import Combine

extension View {
  
  /// Adds a modifier for this view that fires an action when a specific
  /// value changes.
  ///
  /// `onChange` is called on the main thread. Avoid performing long-running
  /// tasks on the main thread. If you need to perform a long-running task in
  /// response to `value` changing, you should dispatch to a background queue.
  ///
  /// The new value is passed into the closure.
  ///
  /// - Parameters:
  ///   - value: The value to observe for changes
  ///   - action: A closure to run when the value changes with oldValue
  ///   - newValue: The new value that changed
  ///
  /// - Returns: A view that fires an action when the specified value changes.
  @ViewBuilder
  public func onChangeWithPrevious<Value: Equatable>(
    of value: Value,
    emitsInitial: Bool,
    perform action: @escaping (_ newValue: Value, _ oldValue: Value?) -> Void
  ) -> some View {
    modifier(
      ChangeModifier(
        value: value,
        emitsInitial: emitsInitial,
        action: action
      )
    )
  }
  
}

private struct ChangeModifier<Value: Equatable>: ViewModifier {
  
  let value: Value
  let emitsInitial: Bool
  let action: (Value, Value?) -> Void
  
  @State var oldValue: Value?
  @State var emitCount = 0
  
  init(
    value: Value,
    emitsInitial: Bool,
    action: @escaping (Value, Value?) -> Void
  ) {
    self.value = value
    self.action = action
    self.emitsInitial = emitsInitial
    
    _oldValue = .init(initialValue: value)
  }
  
  func body(content: Content) -> some View {
    content
      .onReceive(Just(value)) { newValue in
        
        if emitsInitial, emitCount == 0 {
          action(newValue, nil)
        } else {
          guard newValue != oldValue else { return }
          action(newValue, oldValue)
          oldValue = newValue
        }
        emitCount += 1
      }
  }
}


