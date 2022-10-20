import SwiftUI

@available(iOS 14, *)
struct LineShapeView: View, Animatable {
  var chartData: ChartData
  var geometry: GeometryProxy
  var style: ChartStyle
  var trimTo: Double = 0
  
  var animatableData: CGFloat {
    get { CGFloat(trimTo) }
    set { trimTo = Double(newValue) }
  }
  
  var body: some View {
    LineShape(data: chartData.normalisedPoints, cData: chartData)
      .trim(from: 0, to: CGFloat(trimTo)) // for animation
      .transform(CGAffineTransform(scaleX: geometry.size.width / CGFloat(chartData.normalisedPoints.count - 1),
                                   y: geometry.size.height / CGFloat(chartData.normalisedRange)))
      .stroke(LinearGradient(gradient: style.foregroundColor.first?.gradient ?? ColorGradient.orangeBright.gradient,
                             startPoint: .leading,
                             endPoint: .trailing),
              style: StrokeStyle(lineWidth: 2, lineJoin: .round))
      .rotationEffect(.degrees(180), anchor: .center)
      .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
    
    // Ignore if entire array are zeros
    if !chartData.normalisedPointsTarget.allSatisfy({$0 == 0}) {
      LineShape(data: chartData.normalisedPointsTarget, cData: chartData)
        .trim(from: 0, to: CGFloat(trimTo))
        .transform(CGAffineTransform(scaleX: geometry.size.width / CGFloat(chartData.normalisedPointsTarget.count - 1),
                                     y: geometry.size.height / CGFloat(chartData.normalisedRange)))
        .stroke(Color(UIColor.blue), style: StrokeStyle(lineWidth: 2, lineJoin: .round))
        .rotationEffect(.degrees(180), anchor: .center)
        .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
    }
  }
}
