import SwiftUI

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
