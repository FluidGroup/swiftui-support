import SwiftUI

extension View {

  public func variadicMultiViewRoot<Content: View>(
    _ applier: @escaping (_VariadicView.Children) -> Content
  ) -> some View {
    _VariadicView.Tree(_Proxy<Content>(applier: applier)) { self }
  }

}

private struct _Proxy<Content: View>: _VariadicView_MultiViewRoot {

  private let applier: (_VariadicView.Children) -> Content

  init(applier: @escaping (_VariadicView.Children) -> Content) {
    self.applier = applier
  }

  @ViewBuilder
  func body(children: _VariadicView.Children) -> Content {
    applier(children)
  }

}
