import SwiftUI

@available(iOS 14, *)
public struct ChartGrid<Content: View>: View, ChartBase {
    public var chartData = ChartData()
    let content: () -> Content
    let numberOfHorizontalLines = 4

    @EnvironmentObject var data: ChartData
    @EnvironmentObject var style: ChartStyle

    public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    public var body: some View {
        HStack {
            ZStack {
                VStack {
                  // https://www.hackingwithswift.com/forums/swiftui/compiler-warning-non-constant-range-argument-must-be-an-integer-literal/14878
                    ForEach(0..<numberOfHorizontalLines, id: \.self) { _ in
                        GridElement()
                        Spacer()
                    }
                }
                self.content()
            }
        }
    }
}

@available(iOS 14, *)
struct GridElement: View {
    var body: some View {
        DashedLine()
            .frame(maxHeight: 2, alignment: .center)
    }
}

@available(iOS 14, *)
struct DashedLine: View {
    func line(frame: CGRect) -> Path {
        let baseLine: CGFloat = CGFloat(frame.height / 2)
        var hLine = Path()
        hLine.move(to: CGPoint(x:0, y: baseLine))
        hLine.addLine(to: CGPoint(x: frame.width, y: baseLine))
        return hLine
    }

    var body: some View {
        GeometryReader { geometry in
            line(frame: geometry.frame(in: .local))
                .stroke(Color(white: 0.85), style: StrokeStyle(lineWidth: 1, lineCap: .round, dash: [5, 10]))
        }
    }
}

