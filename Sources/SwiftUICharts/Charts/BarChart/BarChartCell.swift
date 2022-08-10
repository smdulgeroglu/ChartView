import SwiftUI

/// A vertical bar in a `BarChart`
///
/// If a 2nd value is provided in the data, it will be used as a BG Value
/// to show the percentage completion to the target
/// eg: Actual Completed = 1hr against a 2hr plan duration
///
public struct BarChartCell: View {
  @Environment(\.colorScheme) var colorScheme: ColorScheme
  @EnvironmentObject var data: ChartData
  
  var value: Double
  var index: Int = 0
  var gradientColor: ColorGradient
  var touchLocation: CGFloat
  var label: String = ""
  var cornerRadius: CGFloat = 6.0

  @State private var didCellAppear: Bool = false
  
  public init( value: Double,
               index: Int = 0,
               gradientColor: ColorGradient,
               touchLocation: CGFloat,
               label: String = "") {
    self.value = value
    self.index = index
    self.gradientColor = gradientColor
    self.touchLocation = touchLocation
    self.label = label
  }
  
  /// The content and behavior of the `BarChartCell`.
  ///
  /// Animated when first displayed, using the `firstDisplay` variable, with an increasing delay through the data set.
  /// Add a background layer to show progress against a prescribed target metric (if provided) with a a low opacity
  public var body: some View {
    let zeroValueColor: Color = colorScheme == .dark ? Color.white : Color.black

    ZStack {
      VStack (spacing:0){
        let valueTarget = data.pointsTarget.count > 0 ? data.normalisedPointsTarget[index] : 0
        
        BarChartCellShape(value: didCellAppear ? valueTarget : 0.0, cornerRadius: 2)
          .fill( gradientColor.linearGradient(from: .bottom, to: .top))
          .opacity(0.3)
        Text("")
      }
      
      VStack (spacing:0){
        BarChartCellShape(value: didCellAppear ? value : 0.0, cornerRadius: 2)
          .fill(value == 0 ? LinearGradient(colors: [zeroValueColor], startPoint: .bottom, endPoint: .top) :  gradientColor.linearGradient(from: .bottom, to: .top))
          .onAppear {
            self.didCellAppear = true
          }
          .onDisappear {
            self.didCellAppear = false
          }
          .transition(.slide)
          .animation(Animation.spring().delay(self.touchLocation < 0 || !didCellAppear ? Double(self.index) * 0.04 : 0))
        Text(String(label))
          .font(.caption)
        // https://stackoverflow.com/a/63746977/14414215
        //        .overlay(Rectangle().frame(width:20 , height: 1, alignment: .top).foregroundColor(zeroValueColor), alignment: .top)
      }
    }
  }
}

struct BarChartCell_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      Group {
        BarChartCell(value: 0.2, gradientColor: ColorGradient.greenRed, touchLocation: CGFloat(), label: "Test-Label")
        BarChartCell(value: 0.5, gradientColor: ColorGradient.greenRed, touchLocation: CGFloat())
        BarChartCell(value: 0.75, gradientColor: ColorGradient.whiteBlack, touchLocation: CGFloat())
        BarChartCell(value: 1, gradientColor: ColorGradient(.purple), touchLocation: CGFloat())
      }
      
      Group {
        BarChartCell(value: 1, gradientColor: ColorGradient.greenRed, touchLocation: CGFloat())
        BarChartCell(value: 1, gradientColor: ColorGradient.whiteBlack, touchLocation: CGFloat())
        BarChartCell(value: 1, gradientColor: ColorGradient(.purple), touchLocation: CGFloat())
      }.environment(\.colorScheme, .dark)
    }
  }
}
