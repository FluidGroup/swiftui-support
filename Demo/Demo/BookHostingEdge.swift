import SwiftUI
import SwiftUISupport

struct BookHostingEdge: View, PreviewProvider {
  var body: some View {
    Content()
  }
  
  static var previews: some View {
    Self()
  }
  
  private struct Content: View {
    
    @State var flag = false
    
    var body: some View {
      
      VStack {
        
        HostingEdge {
          Text("Book")
        }
        
        pyramid
        
        HStack {
          if flag {
            pyramid
          }
          HostingEdge {
            Text("Inside HostingEdge").font(.caption)
            pyramid
          }
        }
        
        HStack {
          if flag {
            HostingEdge {
              Text("Inside HostingEdge").font(.caption)
              pyramid
            }
          }
          HostingEdge {
            Text("Inside HostingEdge").font(.caption)
            pyramid
          }
        }
        
        HostingEdge {
          HStack {
            if flag {
              HostingEdge {
                Text("Inside HostingEdge").font(.caption)
                pyramid
              }
            }
            HostingEdge {
              Text("Inside HostingEdge").font(.caption)
              pyramid
            }
          }
        }
        
        Button("Update") {
          withAnimation {
            flag.toggle()
          }
        }
        
      }
      
    }
    
    private var pyramid: some View {
      Color(white: 0.5, opacity: 0.2)
        .frame(width: 60, height: 60)
        .padding(4)
        .overlay(Color(white: 0.5, opacity: 0.2))
        .padding(4)
        .overlay(Color(white: 0.5, opacity: 0.2))
        .padding(4)
        .overlay(Color(white: 0.5, opacity: 0.2))
        .padding(4)
        .overlay(Color(white: 0.5, opacity: 0.2))
    }
  }
  
}
