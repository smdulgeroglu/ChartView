import SwiftUI

@available(iOS 14, *)
struct BarChartCellShape: Shape, Animatable {

  var value: Double
  var cornerRadius: CGFloat = 6.0
  var animatableData: CGFloat {
    get { CGFloat(value) }
    set { value = Double(newValue) }
  }
  
  // If value == 0, we proceed to add a single line to show separation between BarChart and Labels
  func path(in rect: CGRect) -> Path {
    let adjustedOriginY = rect.height - (rect.height * CGFloat(value))
    var path = Path()
    if value != 0 {
      path.move(to: CGPoint(x: 0.0 , y: rect.height))
      path.addLine(to: CGPoint(x: 0.0, y: adjustedOriginY + cornerRadius))
      path.addArc(center: CGPoint(x: cornerRadius, y: adjustedOriginY +  cornerRadius),
                  radius: cornerRadius,
                  startAngle: Angle(radians: Double.pi),
                  endAngle: Angle(radians: -Double.pi/2),
                  clockwise: false)
      path.addLine(to: CGPoint(x: rect.width - cornerRadius, y: adjustedOriginY))
      path.addArc(center: CGPoint(x: rect.width - cornerRadius, y: adjustedOriginY + cornerRadius),
                  radius: cornerRadius,
                  startAngle: Angle(radians: -Double.pi/2),
                  endAngle: Angle(radians: 0),
                  clockwise: false)
      path.addLine(to: CGPoint(x: rect.width, y: rect.height))
      path.closeSubpath()
    } else if value == 0 {
      path.move(to: CGPoint(x: 0.0 , y: rect.height - 1.0))
      path.addLine(to: CGPoint(x: 0.0, y: rect.height))
      path.addLine(to: CGPoint(x: rect.width, y: rect.height))
      path.addLine(to: CGPoint(x: rect.width, y: rect.height - 1.0))
      path.closeSubpath()
    }
    return path
  }
}

@available(iOS 14, *)
struct BarChartCellShape_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      BarChartCellShape(value: 0.0)
        .fill(Color.red)
      
      BarChartCellShape(value: 0.75)
        .fill(Color.blue)
    }
  }
}
