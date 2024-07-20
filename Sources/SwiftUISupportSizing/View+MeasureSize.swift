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
   
   !! Should be deprecated in favor of using directly ``readingGeometry(transform:target:)``
   */
  public func measureSize(_ size: Binding<CGSize>) -> some View {
    readingGeometry(transform: \.size, target: size)
  }
  
}

private enum GeometryReaderPreferenceKey<Projected: Equatable>: PreferenceKey {

  static var defaultValue: Projected? {
    return nil
  }

  static func reduce(value: inout Value, nextValue: () -> Projected?) {
    let next = nextValue()
    value = next
  }

}

extension View {
  
  public consuming func readingGeometry<Projected: Equatable>(
    transform: @escaping (GeometryProxy) -> Projected,
    target: Binding<Projected>
  ) -> some View {
    readingGeometry(transform: transform, onChange: {
      target.wrappedValue = $0
    })
  }
  
  public consuming func readingGeometry<Projected: Equatable>(
    transform: @escaping (GeometryProxy) -> Projected,
    onChange: @escaping (Projected) -> Void
  ) -> some View {
    background(
      Color.clear.background(
        GeometryReader(content: { proxy in
          Color.clear
            .preference(key: GeometryReaderPreferenceKey<Projected>.self, value: transform(proxy))
        })
      )
      .onPreferenceChange(GeometryReaderPreferenceKey<Projected>.self) { projected in
        guard let projected else { return }
        onChange(projected)
      }
    )
  }

}
