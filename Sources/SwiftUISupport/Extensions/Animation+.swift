
import SwiftUI

extension Animation {
  
  public static var smoothSpring: Animation {
    .spring(
      response: 0.6,
      dampingFraction: 1,
      blendDuration: 0
    )
  }
  
}
