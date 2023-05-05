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
      (_ velocity: inout CGVector, _ offset: CGSize, _ contentSize: CGSize) -> CGSize

    public var onStartDragging: () -> Void

    public init(
      onStartDragging: @escaping () -> Void = {},
      onEndDragging: @escaping (_ velocity: inout CGVector, _ offset: CGSize, _ contentSize: CGSize)
        -> CGSize = { _, _, _ in .zero }
    ) {
      self.onStartDragging = onStartDragging
      self.onEndDragging = onEndDragging
    }
  }

  public enum GestureMode {
    case normal
    case highPriority
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
  @GestureState private var isTracking = false

  @State private var contentSize: CGSize = .zero

  public let axis: Axis.Set
  public let springParameter: SpringParameter
  public let gestureMode: GestureMode
  public let minimumDistance: Double

  private let horizontalBoundary: Boundary
  private let verticalBoundary: Boundary
  private let handler: Handler


  public init(
    minimumDistance: Double = 0,
    axis: Axis.Set = [.horizontal, .vertical],
    horizontalBoundary: Boundary = .infinity,
    verticalBoundary: Boundary = .infinity,
    springParameter: SpringParameter = .hard,
    gestureMode: GestureMode = .normal,
    handler: Handler = .init()
  ) {
    self.axis = axis
    self.springParameter = springParameter
    self.horizontalBoundary = horizontalBoundary
    self.verticalBoundary = verticalBoundary
    self.gestureMode = gestureMode
    self.handler = handler
    self.minimumDistance = minimumDistance
  }

  public func body(content: Content) -> some View {

    let base = content
      .measureSize($contentSize)
      .animatableOffset(x: currentOffset.width, y: currentOffset.height)

    Group {
      switch gestureMode {
      case .normal:
        base.gesture(gesture, including: .all)
      case .highPriority:
        base.highPriorityGesture(gesture, including: .all)
      }
    }
    .onChange(of: isTracking) { newValue in
      if newValue {
        handler.onStartDragging()
      }
    }

  }

  private var gesture: some Gesture {
    DragGesture(
      minimumDistance: minimumDistance,
      coordinateSpace: .local
    )
    .updating($isTracking, body: { _, state, _ in
      state = true
    })
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

      var usingVelocity = self.velocity

      let targetOffset: CGSize = handler.onEndDragging(
        &usingVelocity,
        self.currentOffset,
        self.contentSize
      )

      let velocity = usingVelocity

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
