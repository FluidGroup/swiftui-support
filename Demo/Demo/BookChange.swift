import SwiftUI
import SwiftUISupport

struct BookChange: View, PreviewProvider {
  var body: some View {
    Content()
  }
  
  static var previews: some View {
    Self()
  }
  
  private struct Content: View {
    
    @State var count = 0
    
    var body: some View {
      VStack {
        Button("Hit") {
          count += 1
        }
        Text("Book")
          .onChangeWithPrevious(of: count, emitsInitial: true) { newValue, oldValue in
            print("\(newValue), \(oldValue)")
          }
      }
    }
  }
}

