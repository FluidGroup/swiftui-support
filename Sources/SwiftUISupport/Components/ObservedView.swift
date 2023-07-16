import SwiftUI
import Combine

public struct ObservedView<Object: ObservableObject, Content: View>: View {

  @ObservedObject var object: Object
  private let content: (Object) -> Content

  public init(object: Object, @ViewBuilder content: @escaping (Object) -> Content) {
    self.content = content
    self.object = object
  }

  public var body: some View {
    content(object)
  }

}

public struct AsyncObservedView<Object: ObservableObject, Content: View>: View {

  public struct _ObservedView: View {

    @ObservedObject var object: Object
    private let content: (Object) -> Content

    public init(object: Object, @ViewBuilder content: @escaping (Object) -> Content) {
      self.content = content
      self._object = .init(wrappedValue: object)
    }

    public var body: some View {
      content(object)
    }

  }

  @State var loaded: Object?

  private let content: (Object) -> Content
  private let objectLoader: () async -> Object

  public init(
    objectLoader: @escaping @Sendable () async -> Object,
    @ViewBuilder content: @escaping (Object) -> Content
  ) {
    self.content = content
    self.objectLoader = objectLoader
  }

  public var body: some View {

    Group {
      if let loaded {
        _ObservedView(object: loaded, content: content)
      }
    }
    .onAppear {
      Task.detached {
        let loaded = await objectLoader()

        await MainActor.run {
          self.loaded = loaded
        }

      }
    }

  }
}
