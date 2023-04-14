
import SwiftUI

/**
 A stateful view in a closure or function-based component instead of a struct-based view.
 The stateful view allows for building content with state, and holds the state of the component.
 */
public struct LocalState<State, Content: View>: View {

  @SwiftUI.State var state: State

  private let content: (Binding<State>) -> Content

  public init(
    initial: State,
    @ViewBuilder content: @escaping (Binding<State>) -> Content
  ) {
    self._state = .init(initialValue: initial)
    self.content = content
  }

  public var body: some View {
    content($state)
  }

}

#if DEBUG

struct BookState: View, PreviewProvider {
  var body: some View {
    Content()
  }

  static var previews: some View {
    Self()
  }

  private struct Content: View {

    @State var count = 0

    var body: some View {

      VStack {
        Button("Outer \(count)") {
          count += 1
        }

        LocalState(initial: 1) { $value in
          Button("Tap \(value)") {
            value += 1
          }
        }
      }
    }
  }

}

#endif
