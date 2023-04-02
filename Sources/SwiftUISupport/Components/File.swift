import SwiftUI

public struct HostingEdge<Content: View>: UIViewControllerRepresentable {
  
  public typealias UIViewControllerType = UIHostingController<_WrapperView>
  
  @Environment(\.layoutDirection) private var layoutDirection
  
  private let content: Content
  private let reference: @MainActor (UIHostingController<_WrapperView>) -> Void
  
  public func makeCoordinator() -> Proxy {
    .init(content: content)
  }
  
  public init(
    @ViewBuilder content: () -> Content,
    reference: @escaping (UIHostingController<_WrapperView>) -> Void = { _ in }
  ) {
    self.content = content()
    self.reference = reference
  }
  
  public func makeUIViewController(context: Context) -> UIViewControllerType {
    UIHostingController(rootView: .init(proxy: context.coordinator))
  }
  
  public func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    // due to avoid the runtime error about updating state during updating view tree.
    // maybe related: https://www.donnywals.com/xcode-14-publishing-changes-from-within-view-updates-is-not-allowed-this-will-cause-undefined-behavior/
    DispatchQueue.main.async {
      withTransaction(context.transaction) {
        context.coordinator.content = content
      }
      reference(uiViewController)
    }
  }
  
  public final class Proxy: ObservableObject {
    
    @Published var content: Content
    
    init(content: Content) {
      
      self._content = .init(initialValue: content)
    }
    
  }
  
  public struct _WrapperView: View {
    
    @ObservedObject var proxy: Proxy
    
    init(proxy: Proxy) {
      self.proxy = proxy
    }
    
    public var body: some View {
      proxy.content
    }
    
  }
  
}

public struct VisualEffect: UIViewRepresentable {
  
  let style: UIBlurEffect.Style
  
  public init(style: UIBlurEffect.Style) {
    self.style = style
  }
  
  public func makeUIView(context: Context) -> UIVisualEffectView {
    return UIVisualEffectView(effect: UIBlurEffect(style: style))
  }
  
  public func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
    
  }
}

