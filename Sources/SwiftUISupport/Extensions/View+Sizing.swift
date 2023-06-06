import SwiftUI

private struct SizeStackingPreferenceKey: PreferenceKey {
  
  typealias Value = [String : CGSize]
  
  static var defaultValue: Value = [:]
  
  static func reduce(value: inout Value, nextValue: () -> Value) {
    value.merge(nextValue(), uniquingKeysWith: { _, dic in dic })
  }
}

extension View {

  /**
   Measures the receiver view size using GeometryReader.
   */
  public func measureSize(_ size: Binding<CGSize>, _ line: Int = #line, _ file: String = #file) -> some View {
    background(Color.clear._measureSize(key: "\(file)_\(line)", size: size))
  }

  private func _measureSize(key: String, size: Binding<CGSize>) -> some View {
    
    self.background(
      GeometryReader(content: { proxy in
        Color.clear
          .preference(key: SizeStackingPreferenceKey.self, value: [key : proxy.size])
      })
    )
    .onPreferenceChange(SizeStackingPreferenceKey.self) { _size in
      guard let value = _size[key] else { return }
      size.wrappedValue = value
    }
    
  }
  
}
