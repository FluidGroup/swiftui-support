import SwiftUI
/*
 A stateful view in a closure or function-based component instead of a struct-based view.
 The stateful view allows for building content with state, and holds the state of the component.

 ```swift
  struct ComponentState: Equatable {
    var a = "1"
    var b = "2"
    var c = "3"
  }

  var body: some View {
    VStack {
      LocalState(
        initial: ComponentState(),
      ) { state in
        TextField("A", text: state.a)
        TextField("B", text: state.b)
        TextField("C", text: state.c)
      }
    }
  }
 ```
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
    Content3()
      .previewDisplayName("Binding")
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

        Content2()

      }
    }
  }

  private struct Content2: View {

    @State var count = 0

    var body: some View {

      VStack {
        Button("Outer \(count)") {
          count += 1
        }

        LocalState(initial: 1) { $value in
          Button("👨🏻 Tap \(value)") {
            value += 1
          }
          LocalState(initial: 1) { $value2 in
            Button("👨🏻 Tap \(value)") {
              value += 1
            }

            Button("🌲 Tap \(value2)") {
              value2 += 1
            }
          }

        }

      }
    }
  }

  private struct Content3: View {

    struct ComponentState: Equatable {
      var a = "1"
      var b = "2"
      var c = "3"
    }

    var body: some View {
      VStack {
        LocalState(
          initial: ComponentState()
        ) { state in
          TextField("A", text: state.a)
          TextField("B", text: state.b)
          TextField("C", text: state.c)
        }
      }
    }

  }

}

#endif
