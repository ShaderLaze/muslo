import SwiftUI

struct ProgressBar: View {
    @Binding var currentTime: TimeInterval
    let duration: TimeInterval
    var seek: (TimeInterval) -> Void

    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.white.opacity(0.3))
                    .frame(height: 8)
                Capsule()
                    .fill(Color.white)
                    .frame(width: width * CGFloat(progress), height: 8)
            }
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        let clamped = min(max(0, value.location.x), width)
                        let newTime = TimeInterval(clamped / width) * duration
                        currentTime = newTime
                        seek(newTime)
                    }
            )
        }
        .frame(height: 20)
    }

    private var progress: Double {
        guard duration > 0 else { return 0 }
        return currentTime / duration
    }
}
