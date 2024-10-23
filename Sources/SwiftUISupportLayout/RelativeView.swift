import SwiftUI

/// deprecated
public struct RelativeLayoutModifier {

  public enum HorizontalPosition {
    case leading
    @available(*, unavailable)
    case center
    case trailing
  }

  public enum VerticalPosition {
    case top
    @available(*, unavailable)
    case center
    case bottom
  }

}

extension View {

  /**
   * Lays out the view and positions it within the layout bounds according to vertical and horizontal positional specifiers.
   *  Can position the child at any of the 4 corners, or the middle of any of the 4 edges, as well as the center - similar to "9-part" image areas.
   */
  @available(*, deprecated, message: "use relative(alignment: )")
  public func relative(
    vertical: RelativeLayoutModifier.VerticalPosition,
    horizontal: RelativeLayoutModifier.HorizontalPosition
  ) -> some View {
            
    return self.relative(alignment: .init(
      horizontal: {
        switch horizontal {
        case .center:
          return .center
        case .leading:
          return .leading
        case .trailing:
          return .trailing
        }
      }(),
      vertical: {
        switch vertical {
        case .center:
          return .center
        case .top:
          return .top
        case .bottom:
          return .bottom
        }        
      }()
    )
    )    
  }
  
  @available(*, deprecated, message: "use relative(alignment: )")
  public func relative(
    horizontal: RelativeLayoutModifier.HorizontalPosition
  ) -> some View {
    
    return self.relative(horizontalAlignment: {
      switch horizontal {
      case .center:
        return .center
      case .leading:
        return .leading
      case .trailing:
        return .trailing
      }
    }()
    )    
  }
  
  @available(*, deprecated, message: "use relative(alignment: )")
  public func relative(
    vertical: RelativeLayoutModifier.VerticalPosition
  ) -> some View {
    
    return self.relative(verticalAlignment: {
      switch vertical {
      case .center:
        return .center
      case .top:
        return .top
      case .bottom:
        return .bottom
      }        
    }()                         
    )    
  }
  
  public func relative(
    alignment: Alignment
  ) -> some View {           
    self.frame(
      maxWidth: .infinity,
      maxHeight: .infinity,
      alignment: alignment
    )
  }
  
  public func relative(
    horizontalAlignment: HorizontalAlignment
  ) -> some View {           
    self.frame(maxWidth: .infinity, alignment: .init(horizontal: horizontalAlignment, vertical: .center))
  }
  
  public func relative(
    verticalAlignment: VerticalAlignment
  ) -> some View {    
    self.frame(maxHeight: .infinity, alignment: .init(horizontal: .center, vertical: verticalAlignment))
  }
  
  public func relative(
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
