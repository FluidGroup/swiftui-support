import Combine
import SwiftUI

@available (iOS, deprecated: 14.0)
@propertyWrapper
public struct _StateObject<Wrapped>: DynamicProperty where Wrapped: ObservableObject {
  
  private final class Wrapper: ObservableObject {
    
    var value: Wrapped? {
      didSet {
        guard let value else { return }
        cancellable = value.objectWillChange
          .sink { [weak self] _ in
            self?.objectWillChange.send()
          }
      }
    }
    
    private var cancellable: AnyCancellable?
  }
  
  public var wrappedValue: Wrapped {
    if let object = state.value {
      return object
    } else {
      let object = thunk()
      state.value = object
      return object
    }
  }
  
  public var projectedValue: ObservedObject<Wrapped>.Wrapper {
    return ObservedObject(wrappedValue: wrappedValue).projectedValue
  }
  
  @State private var state = Wrapper()
  @ObservedObject private var observedObject = Wrapper()
  
  private let thunk: () -> Wrapped
  
  public init(wrappedValue thunk: @autoclosure @escaping () -> Wrapped) {
    self.thunk = thunk
  }
  
  public mutating func update() {
    if state.value == nil {
      state.value = thunk()
    }
    if observedObject.value !== state.value {
      observedObject.value = state.value
    }
  }
}
