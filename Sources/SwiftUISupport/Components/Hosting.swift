import SwiftUI

public struct ViewHost<ContentView: UIView>: UIViewRepresentable {
  
  private let contentView: ContentView
  private let _update: @MainActor (_ uiView: ContentView, _ context: Context) -> Void
  
  public init(
    instantiated: ContentView,
    update: @escaping @MainActor (_ uiView: ContentView, _ context: Context) -> Void = { _, _ in }
  ) {
    self.contentView = instantiated
    self._update = update
  }
  
  public func makeUIView(context: Context) -> ContentView {
    return contentView
  }
  
  public func updateUIView(_ uiView: ContentView, context: Context) {
    _update(uiView, context)
  }
  
}

public struct ViewControllerHost<ContentViewController: UIViewController>:
  UIViewControllerRepresentable
{
  
  private let contentViewController: ContentViewController
  private let _update:
  @MainActor (_ uiViewController: ContentViewController, _ context: Context) -> Void
  
  public init(
    instantiated: ContentViewController,
    update: @escaping @MainActor (_ uiViewController: ContentViewController, _ context: Context) ->
    Void = { _, _ in }
  ) {
    self.contentViewController = instantiated
    self._update = update
  }
  
  public func makeUIViewController(context: Context) -> ContentViewController {
    return contentViewController
  }
  
  public func updateUIViewController(_ uiViewController: ContentViewController, context: Context) {
    _update(uiViewController, context)
  }
  
}

