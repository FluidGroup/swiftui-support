import GestureVelocity
import SwiftUI

public struct VelocityDraggingModifier: ViewModifier {

  public struct Handler {
    /**
     A callback closure that is called when the user finishes dragging the content.
     This closure takes a CGSize as a return value, which is used as the target offset to finalize the animation.

     For example, return CGSize.zero to put it back to the original position.
     */
    public var onEndDragging:
      (_ velocity: CGVector, _ offset: CGSize, _ contentSize: CGSize) -> CGSize

    public init(
      onEndDragging: @escaping (_ velocity: CGVector, _ offset: CGSize, _ contentSize: CGSize)
        -> CGSize = { _, _, _ in .zero }
    ) {
      self.onEndDragging = onEndDragging
    }
  }

  public enum Action {
    case onEndDragging(velocity: CGVector, offset: CGSize)
  }

  public enum SpringParameter {
    case interpolation(
      mass: Double,
      stiffness: Double,
      damping: Double
    )

    public static var hard: Self {
      .interpolation(mass: 1.0, stiffness: 200, damping: 20)
    }
  }

  public struct Boundary {
    public let min: Double
    public let max: Double
    public let bandLength: Double

    public init(min: Double, max: Double, bandLength: Double) {
      self.min = min
      self.max = max
      self.bandLength = bandLength
    }

    public static var infinity: Self {
      return .init(
        min: -Double.greatestFiniteMagnitude,
        max: Double.greatestFiniteMagnitude,
        bandLength: 0
      )
    }
  }

  /**
   ???
   Use just State instead of GestureState to trigger animation on gesture ended.
   This approach is right?

   refs:
   https://stackoverflow.com/questions/72880712/animate-gesturestate-on-reset
   */
  @State private var currentOffset: CGSize = .zero

  /// pt/s
  @GestureVelocity private var velocity: CGVector

  @State private var contentSize: CGSize = .zero

  public let axis: Axis.Set
  public let springParameter: SpringParameter

  private let horizontalBoundary: Boundary
  private let verticalBoundary: Boundary
  private let handler: Handler

  public init(
    axis: Axis.Set = [.horizontal, .vertical],
    horizontalBoundary: Boundary = .infinity,
    verticalBoundary: Boundary = .infinity,
    springParameter: SpringParameter = .hard,
    handler: Handler = .init()
  ) {
    self.axis = axis
    self.springParameter = springParameter
    self.horizontalBoundary = horizontalBoundary
    self.verticalBoundary = verticalBoundary
    self.handler = handler
  }

  public func body(content: Content) -> some View {
    content
      .measureSize($contentSize)
      .animatableOffset(x: currentOffset.width, y: currentOffset.height)
      .gesture(
        DragGesture(
          minimumDistance: 0,
          coordinateSpace: .local
        )
        .onChanged({ value in
          // TODO: stop the current animation when dragging restarted.
          withAnimation(.interactiveSpring()) {
            if axis.contains(.horizontal) {
              currentOffset.width = RubberBandingModifier.rubberBand(
                value: value.translation.width,
                min: horizontalBoundary.min,
                max: horizontalBoundary.max,
                bandLength: horizontalBoundary.bandLength
              )
            }
            if axis.contains(.vertical) {
              currentOffset.height = RubberBandingModifier.rubberBand(
                value: value.translation.height,
                min: verticalBoundary.min,
                max: verticalBoundary.max,
                bandLength: verticalBoundary.bandLength

              )
            }
          }
        })
        .onEnded({ value in

          let targetOffset: CGSize = handler.onEndDragging(
            self.velocity,
            self.currentOffset,
            self.contentSize
          )

          let velocity = self.velocity

          let distance = CGSize(
            width: targetOffset.width - currentOffset.width,
            height: targetOffset.height - currentOffset.height
          )

          let mappedVelocity = CGVector(
            dx: velocity.dx / distance.width,
            dy: velocity.dy / distance.height
          )

          var animationX: Animation {
            switch springParameter {
            case .interpolation(let mass, let stiffness, let damping):
              return .interpolatingSpring(
                mass: mass,
                stiffness: stiffness,
                damping: damping,
                initialVelocity: mappedVelocity.dx
              )
            }
          }

          var animationY: Animation {
            switch springParameter {
            case .interpolation(let mass, let stiffness, let damping):
              return .interpolatingSpring(
                mass: mass,
                stiffness: stiffness,
                damping: damping,
                initialVelocity: mappedVelocity.dy
              )
            }
          }

          withAnimation(
            animationX
          ) {
            currentOffset.width = targetOffset.width
          }

          withAnimation(
            animationY
          ) {
            currentOffset.height = targetOffset.height
          }

        })
        .updatingVelocity($velocity)

      )
  }

}

#if DEBUG
struct VelocityDraggingModifier_Previews: PreviewProvider {
  static var previews: some View {

    BookRubberBanding()

    Group {

      RoundedRectangle(cornerRadius: 16, style: .circular)
        .frame(width: 120, height: 50)
        .modifier(
          VelocityDraggingModifier(
            axis: [.vertical],
            verticalBoundary: .init(min: -10, max: 10, bandLength: 50)
          )
        )

    }
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
