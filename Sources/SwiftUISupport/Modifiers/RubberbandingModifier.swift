import GestureVelocity
import SwiftUI

/**
 The rubber banding effect is a popular user interface technique that provides a natural, elastic behavior when a user drags or pulls an element beyond its limit. This effect is commonly observed in scrollable lists or pages, where reaching the edge of the content allows the user to pull it further, creating a sensation of tension. When the user releases the drag, the content bounces back smoothly to its original position, emulating the behavior of a rubber band.

 Implementing the rubber banding effect in your user interface helps create a more responsive and engaging experience for users. It provides visual feedback that informs the user they have reached the edge of the content, while still allowing them to interact with the interface in a natural and intuitive manner.
 */
public struct RubberBandingModifier: ViewModifier {

  public static func rubberBand(value: CGFloat, min: CGFloat, max: CGFloat, bandLength: CGFloat)
    -> CGFloat
  {
    if value >= min && value <= max {
      // While we're within range we don't rubber band the value.
      return value
    }

    if bandLength <= 0 {
      // The rubber band doesn't exist, return the minimum value so that we stay put.
      return min
    }

    let rubberBandCoefficient: CGFloat = 0.55
    // Accepts values from [0...+inf and ensures that f(x) < bandLength for all values.
    let band: (CGFloat) -> CGFloat = { value in
      let demoninator = value * rubberBandCoefficient / bandLength + 1
      return bandLength * (1 - 1 / demoninator)
    }
    if value > max {
      return band(value - max) + max;

    } else if value < min {
      return min - band(min - value);
    }

    return value;
  }

  /**
   ???
   Use just State instead of GestureState to trigger animation on gesture ended.
   This approach is right?

   refs:
   https://stackoverflow.com/questions/72880712/animate-gesturestate-on-reset
   */
  @State private var position: CGSize = .zero

  @GestureVelocity private var velocity: CGVector

  private var handler: @MainActor (Bool) -> Void
  private let bandLength: CGFloat

  public init(
    bandLength: CGFloat = 50,
    onSliding: @escaping @MainActor (Bool) -> Void = { _ in }
  ) {
    self.handler = onSliding
    self.bandLength = bandLength
  }

  public func body(content: Content) -> some View {
    content
      .animatableOffset(position)
      .gesture(
        DragGesture(
          minimumDistance: 0,
          coordinateSpace: .local
        )
        .onChanged({ value in
          withAnimation(.interactiveSpring()) {

            position.height = Self.rubberBand(
              value: value.translation.height,
              min: 0,
              max: 0,
              bandLength: bandLength
            )

            position.width = Self.rubberBand(
              value: value.translation.width,
              min: 0,
              max: 0,
              bandLength: bandLength
            )

          }
        })
        .onEnded({ value in

          let velocity = self.velocity

          let distance = CGSize(
            width: -position.width,
            height: -position.height
          )

          let mappedVelocity = CGVector(
            dx: velocity.dx / distance.width,
            dy: velocity.dy / distance.height
          )

          withAnimation(
            .interpolatingSpring(stiffness: 200, damping: 50, initialVelocity: mappedVelocity.dx)
          ) {
            position.width = 0
          }
          withAnimation(
            .interpolatingSpring(stiffness: 200, damping: 50, initialVelocity: mappedVelocity.dy)
          ) {
            position.height = 0
          }

        })
        .updatingVelocity($velocity)

      )
      .preference(key: RubberBandingIsSlidingPreferenceKey.self, value: position != .zero)
    // To trigger on initial
      .onPreferenceChange(RubberBandingIsSlidingPreferenceKey.self) { value in
        handler(value)
      }
  }

}

public struct RubberBandingIsSlidingPreferenceKey: PreferenceKey {
  public typealias Value = Bool

  public static var defaultValue: Bool { false }

  public static func reduce(value: inout Bool, nextValue: () -> Bool) {
    let next = nextValue()
    value = next
  }
}


#if DEBUG
struct BookRubberBanding_Previews: PreviewProvider {
  static var previews: some View {
    BookRubberBanding()
  }

  struct BookRubberBanding: View {

    @State var isSliding: Bool = false

    var body: some View {

      ZStack {

        // make notification bar
        RoundedRectangle(cornerRadius: 16, style: .circular)
          .fill(isSliding ? .red : .blue)
          .modifier(AmbientShadowModifier(blurRadius: 18))
          .frame(width: 120, height: 50)
          .scaleEffect(x: isSliding ? 1 : 1.2, y: isSliding ? 1 : 1.2)
          .modifier(
            RubberBandingModifier(onSliding: { isSliding in
              print(isSliding)
              withAnimation(.spring()) {
                self.isSliding = isSliding
              }
            })
          )
      }
    }
  }
}
#endif
