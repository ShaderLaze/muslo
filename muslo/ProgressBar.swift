import SwiftUI

struct ProgressBar: View {
    @Binding var currentTime: TimeInterval
    let duration: TimeInterval
    var seek: (TimeInterval) -> Void

    @State private var dragging = false

    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.white.opacity(0.3))
                    .frame(height: barHeight)
                Capsule()
                    .fill(Color.white)
                    .frame(width: width * CGFloat(progress), height: barHeight)
                    .animation(.linear(duration: 0.4), value: progress)
            }
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        let clamped = min(max(0, value.location.x), width)
                        let newTime = TimeInterval(clamped / width) * duration
                        currentTime = newTime
                        if !dragging { dragging = true }
                    }
                    .onEnded { _ in
                        dragging = false
                        seek(currentTime)
                    }
            )
        }
        .frame(height: 20)
        .animation(.easeInOut(duration: 0.2), value: dragging)
    }

    private var progress: Double {
        guard duration > 0 else { return 0 }
        return currentTime / duration
    }

    private var barHeight: CGFloat { dragging ? 12 : 8 }
}
