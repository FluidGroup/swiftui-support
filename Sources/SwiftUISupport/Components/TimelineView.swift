import SwiftUI
import Combine

public protocol _backported_TimelineSchedule: ObservableObject { }

extension _backported_TimelineSchedule {
  public static func periodic(from startDate: Date, by interval: TimeInterval) -> _backported_PeriodicalTimelineSchedule {
    return .init(from: startDate, by: interval)
  }
}

public final class _backported_PeriodicalTimelineSchedule: _backported_TimelineSchedule, ObservableObject {
  
  @Published var date: Date
  
  private var cancellables: Set<AnyCancellable> = .init()
  
  init(from startDate: Date, by interval: TimeInterval) {
    
    self.date = startDate
    
    let now = Date()
    let delay = startDate.timeIntervalSinceReferenceDate - now.timeIntervalSinceReferenceDate
    
    Timer.publish(every: 1, on: .main, in: .common)
      .autoconnect()
      .delay(for: .seconds(delay), scheduler: DispatchQueue.main)
      .sink { [weak self] t in
        self?.date = Date()
      }
      .store(in: &cancellables)
  }
}

public typealias _backported_TimelineViewDefaultContext = _backported_TimelineView<_backported_PeriodicalTimelineSchedule, Never>.Context

@available(iOS, deprecated: 15.0)
public struct _backported_TimelineView<Schedule, Content> where Schedule: _backported_TimelineSchedule {
  
  public struct Context {
    public let date: Date
  }
  
  @_StateObject private var schedule: Schedule
  
  private let content: (_backported_TimelineViewDefaultContext) -> Content
}

extension _backported_TimelineView: View where Content: View, Schedule == _backported_PeriodicalTimelineSchedule {
  
  public init(
    _ schedule: Schedule,
    @ViewBuilder content: @escaping (_backported_TimelineViewDefaultContext) -> Content
  ) {
    self.content = content
    self._schedule = .init(wrappedValue: schedule)
  }
  
  public var body: some View {
    let context = _backported_TimelineViewDefaultContext(date: schedule.date)
    content(context)
  }
}

struct _backported_TimelineView_Previews: PreviewProvider {
  
  static var previews: some View {
    _backported_TimelineView(.periodic(from: Date(), by: 1)) { ctx in
      Text(ctx.date.description)
    }
  }
}
