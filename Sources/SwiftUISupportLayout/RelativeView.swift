import SwiftUI

extension View {

  /**
   Using frame modifier inside, let the view place itself relative to the parent view.
   */
  public nonisolated func relative(
    alignment: Alignment
  ) -> some View {           
    self.frame(
      maxWidth: .infinity,
      maxHeight: .infinity,
      alignment: alignment
    )
  }

  /**
   Using frame modifier inside, let the view place itself relative to the parent view.
   */
  public nonisolated func relative(
    horizontalAlignment: HorizontalAlignment
  ) -> some View {           
    self.frame(maxWidth: .infinity, alignment: .init(horizontal: horizontalAlignment, vertical: .center))
  }

  /**
   Using frame modifier inside, let the view place itself relative to the parent view.
   */
  public nonisolated func relative(
    verticalAlignment: VerticalAlignment
  ) -> some View {    
    self.frame(maxHeight: .infinity, alignment: .init(horizontal: .center, vertical: verticalAlignment))
  }

  /**
   Using frame modifier inside, let the view place itself relative to the parent view.
   */
  public nonisolated func relative(
    horizontalAlignment: HorizontalAlignment,
    verticalAlignment: VerticalAlignment
  ) -> some View {    
    self.frame(
      maxWidth: .infinity,
      maxHeight: .infinity,
      alignment: .init(horizontal: horizontalAlignment, vertical: verticalAlignment)
    )
  }
  
}

#Preview {
  HStack(alignment: .top) {
    
    Rectangle()
      .frame(width: 100, height: 100)
    
    Rectangle()
      .frame(width: 50, height: 50)
      .foregroundColor(.red)
      .relative(verticalAlignment: .center)

  }    
  .background(Color.green)
}
