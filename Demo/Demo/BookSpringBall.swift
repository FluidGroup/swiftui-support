
import GestureVelocity
import SwiftUI

struct BookSpringBall: View {
  var body: some View {
    Joystick()
      .background(Color.purple)
  }
}

struct Joystick: View {

  var body: some View {
    stick
      .padding(10)
  }

  private var stick: some View {
    Circle()
      .fill(Color.blue)
      .frame(width: 100, height: 100)
      .modifier(StickyModifier())
  }
}

struct StickyModifier: ViewModifier {

  /**
   ???
   Use just State instead of GestureState to trigger animation on gesture ended.
   This approach is right?

   refs:
   https://stackoverflow.com/questions/72880712/animate-gesturestate-on-reset
   */
  @State private var position: CGSize = .zero

  @GestureVelocity private var velocity: CGVector

  func body(content: Content) -> some View {
    content
      .animatableOffset(x: position.width, y: position.height)
      .gesture(
        DragGesture(
          minimumDistance: 0,
          coordinateSpace: .local
        )
        .onChanged({ value in
          withAnimation(.interactiveSpring()) {
            position = value.translation
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
            .interpolatingSpring(stiffness: 50, damping: 2, initialVelocity: mappedVelocity.dx)
          ) {
            position.width = 0
          }
          withAnimation(
            .interpolatingSpring(stiffness: 50, damping: 2, initialVelocity: mappedVelocity.dy)
          ) {
            position.height = 0
          }

        })
        .updatingVelocity($velocity)

      )
  }

}

struct BookJoystick_Previews: PreviewProvider {
  static var previews: some View {

    VStack {
      BookSpringBall()
    }

  }
}
