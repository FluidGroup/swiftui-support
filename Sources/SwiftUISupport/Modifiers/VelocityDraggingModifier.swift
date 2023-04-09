import GestureVelocity
import SwiftUI

public struct VelocityDraggingModifier: ViewModifier {

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
      return .init(min: .infinity, max: .infinity, bandLength: 0)
    }
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

  public let axis: Axis.Set
  public let springParameter: SpringParameter

  private let horizontalBoundary: Boundary
  private let verticalBoundary: Boundary

  public init(
    axis: Axis.Set = [.horizontal, .vertical],
    horizontalBoundary: Boundary = .infinity,
    verticalBoundary: Boundary = .infinity,
    springParameter: SpringParameter = .hard
  ) {
    self.axis = axis
    self.springParameter = springParameter
    self.horizontalBoundary = horizontalBoundary
    self.verticalBoundary = verticalBoundary
  }

  public func body(content: Content) -> some View {
    content
      .animatableOffset(x: position.width, y: position.height)
      .gesture(
        DragGesture(
          minimumDistance: 0,
          coordinateSpace: .local
        )
        .onChanged({ value in
          // TODO: stop the current animation when dragging restarted.
          withAnimation(.interactiveSpring()) {
            if axis.contains(.horizontal) {
              position.width = RubberBandingModifier.rubberBand(
                value: value.translation.width,
                min: horizontalBoundary.min,
                max: horizontalBoundary.max,
                bandLength: horizontalBoundary.bandLength
              )
            }
            if axis.contains(.vertical) {
              position.height = RubberBandingModifier.rubberBand(
                value: value.translation.height,
                min: verticalBoundary.min,
                max: verticalBoundary.max,
                bandLength: verticalBoundary.bandLength

              )
            }
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
            position.width = 0
          }

          withAnimation(
            animationY
          ) {
            position.height = 0
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
        .modifier(VelocityDraggingModifier(axis: [.vertical], verticalBoundary: .init(min: -10, max: 10, bandLength: 50)))

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
