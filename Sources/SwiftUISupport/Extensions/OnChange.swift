import SwiftUI

extension View {
  
  public func onChange<each T: Equatable>(each value: repeat each T, action: @escaping () -> Void)
  -> some View
  {
    
    if #available(iOS 17, *) {
      
      let box = RepeatingBox<repeat each T>(value: (repeat each value))
      
      return self.onChange(
        of: box,
        perform: { _ in
          action()
        })
      
    } else {
      
      let box = TupleBox<(repeat each T)>(
        value: (repeat each value),
        isEqual: { lhs, rhs in
          
          for (left, right) in repeat (each lhs, each rhs) {
            guard left == right else { return false }
          }
          return true
          
        })
      
      return self.onChange(
        of: box,
        perform: { _ in
          action()
        })
    }
    
  }
  
}

private struct TupleBox<T>: Equatable {
  
  static func == (lhs: TupleBox<T>, rhs: TupleBox<T>) -> Bool {
    lhs.isEqual(lhs.value, rhs.value)
  }
  
  let value: T
  let isEqual: (T, T) -> Bool
  
  init(
    value: T,
    isEqual: @escaping (T, T) -> Bool
  ) {
    self.value = value
    self.isEqual = isEqual
  }
  
}

@available(iOS 17.0.0, *)
private struct RepeatingBox<each T: Equatable>: Equatable {
  
  static func == (lhs: Self, rhs: Self) -> Bool {
    for (left, right) in repeat (each lhs.value, each rhs.value) {
      guard left == right else { return false }
    }
    return true
  }
  
  let value: (repeat each T)
  
}

#if DEBUG

private struct Book: View {
  
  @State var a: Int = 0
  @State var b: Int = 0
  @State var c: Int = 0
  
  var body: some View {
    
    VStack {
      
      Button("Increment A") {
        a += 1
      }
      Button("Increment B") {
        b += 1
      }
      Button("Increment C") {
        c += 1
        
      }
      .onChange(each: a, b, c) {
        print("a, b, or c changed")
      }
      
    }
    
  }
  
}

#Preview {
  Book()
}

#endif
