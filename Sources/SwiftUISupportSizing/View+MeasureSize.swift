import SwiftUI

extension View {

  /**
   Measures the receiver view size using GeometryReader.
   
   !! Should be deprecated in favor of using directly ``readingGeometry(transform:target:)``
   */
  @available(*, deprecated, message: "Use directly onGeometryChange")
  public func measureSize(_ size: Binding<CGSize>) -> some View {
    onGeometryChange(for: CGSize.self, of: { proxy in
      proxy.size
    }, action: { newSize in
      size.wrappedValue = newSize
    })
  }
  
}
