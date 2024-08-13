import SwiftUI

/**
 https://forums.developer.apple.com/forums/thread/739163
 */
@propertyWrapper
struct ObjectEdge<O>: DynamicProperty {

  @State private var box: Box<O> = .init()

  var wrappedValue: O {
    if let value = box.value {
      return value
    } else {
      box.value = factory()
      return box.value!
    }
  }

  private let factory: () -> O

  init(wrappedValue factory: @escaping @autoclosure () -> O) {
    self.factory = factory
  }

  private final class Box<Value> {
    var value: Value?
  }

}

#if DEBUG

@available(iOS 17, *)
@Observable
private final class Model {

  var count: Int = 0
  
  init(count: Int) {
    print("Init model")
    self.count = count    
  }

  func up() {
    count += 1
  }
}

@available(iOS 17, *)
private struct Demo: View {

  @ObjectEdge var model: Model = .init(count: 0)

  var body: some View {

    VStack {
      Text("\(model.count)")
      Button("Up") {
        model.up()
      }
    }
  }
}

@available(iOS 17, *)#Preview{
  Demo()
}

struct Box<T> {

  var value: T

  init(_ value: T) {
    print("Init box")
    self.value = value
  }
}

#Preview("State init value") {

  struct StateInit<Nested: View>: View {

    @State var value: Box<Int> = .init(0)

    private let nested: () -> Nested

    init(@ViewBuilder nested: @escaping () -> Nested) {
      self.nested = nested
    }

    var body: some View {
      VStack {
        Text(value.value.description)
        Button("Up") {
          value.value += 1
        }
        nested()
      }
      .padding()
      .background(
        RoundedRectangle(cornerRadius: 8)
          .fill(Color.yellow.opacity(0.2))
      )
    }
  }

  return StateInit {
    StateInit {
      StateInit {
        EmptyView()
      }
    }
  }
}

#endif
