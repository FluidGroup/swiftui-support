import SwiftUI

private struct SizingPreferenceKey: PreferenceKey {
  
  typealias Value = CGSize
  
  static var defaultValue: Value = .zero
  
  static func reduce(value: inout Value, nextValue: () -> Value) {
    let next = nextValue()
    value = next
  }
  
}

extension View {
  
  /**
   Measures the receiver view size using GeometryReader.   
   */
  public func measureSize(_ size: Binding<CGSize>) -> some View {
    
    self.background(
      GeometryReader(content: { proxy in
        Color.clear
          .preference(key: SizingPreferenceKey.self, value: proxy.size)
      })
    )
    .onPreferenceChange(SizingPreferenceKey.self) { _size in
      size.wrappedValue = _size
    }
    
  }
  
}

