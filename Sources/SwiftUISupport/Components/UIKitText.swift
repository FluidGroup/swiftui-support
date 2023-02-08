import SwiftUI

/**
 UILabel backed SwiftUI.View
 */
public struct UIKitText: UIViewRepresentable {
  
  public typealias UIViewType = UILabel
  
  public let attributedString: NSAttributedString
  
  public init(attributedString: NSAttributedString) {
    self.attributedString = attributedString
  }
  
  public func makeUIView(context: Context) -> UILabel {
    let label = UILabel()
    label.numberOfLines = 0
    return label
  }
  
  public func updateUIView(_ uiView: UILabel, context: Context) {
    uiView.attributedText = attributedString
  }
  
}
