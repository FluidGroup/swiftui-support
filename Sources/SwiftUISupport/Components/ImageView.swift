#if canImport(UIKit)
import SwiftUI
import UIKit

/**
 UIImageView backed ImageView

 For supporting PDF rendering
 https://stackoverflow.com/questions/61164005/why-do-pdfs-resized-in-swiftui-getting-sharp-edges
 */
public struct ImageView: View {

  let contentMode: UIView.ContentMode
  let tintColor: UIColor?
  let image: UIImage?

  public init(
    image: UIImage?,
    contentMode: UIView.ContentMode = .scaleAspectFill,
    tintColor: UIColor? = nil
  ) {
    self.image = image
    self.contentMode = contentMode
    self.tintColor = tintColor
  }

  public var body: some View {
    _ImageView(image: image, contentMode: contentMode, tintColor: tintColor)
      .aspectRatio(image?.size ?? .zero, contentMode: .fit)
  }

  private struct _ImageView: UIViewRepresentable {

    let contentMode: UIView.ContentMode
    let tintColor: UIColor?
    let image: UIImage?

    init(
      image: UIImage?,
      contentMode: UIView.ContentMode = .scaleAspectFill,
      tintColor: UIColor? = nil
    ) {
      self.image = image
      self.contentMode = contentMode
      self.tintColor = tintColor
    }

    func makeUIView(context: Context) -> UIImageView {
      let imageView = UIImageView()
      imageView.clipsToBounds = true
      return imageView
    }

    func updateUIView(_ uiView: UIImageView, context: Context) {
      uiView.contentMode = contentMode
      uiView.tintColor = tintColor
      uiView.image = image
    }

  }
}

#if DEBUG

enum Preview_ImageView: PreviewProvider {

  static var previews: some View {

    Group {
      ImageView(image: nil)
    }

  }

}

#endif

#endif
