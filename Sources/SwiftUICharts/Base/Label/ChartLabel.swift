import SwiftUI

/// What kind of label - this affects color, size, position of the label
public enum ChartLabelType {
  case title
  case subTitle
  case largeTitle
  case custom(size: CGFloat, padding: EdgeInsets, color: Color)
  case legend
}

/// A chart may contain any number of labels in pre-set positions based on their `ChartLabelType`
public struct ChartLabel: View {
  @EnvironmentObject var chartValue: ChartValue
  @State var textToDisplay:String = ""
  var format: String = "%.01f"
  
  private var title: String
  
  /// Label font size
  /// - Returns: the font size of the label
  private var labelSize: CGFloat {
    switch labelType {
    case .title:
      return 32.0
    case .legend:
      return 14.0
    case .subTitle:
      return 24.0
    case .largeTitle:
      return 38.0
    case .custom(let size, _, _):
      return size
    }
  }
  
  /// Padding around label
  /// - Returns: the edge padding to use based on position of the label
  private var labelPadding: EdgeInsets {
    switch labelType {
    case .title:
      return EdgeInsets(top: 16.0, leading: 8.0, bottom: 0.0, trailing: 8.0)
    case .legend:
      return EdgeInsets(top: 4.0, leading: 8.0, bottom: 0.0, trailing: 8.0)
    case .subTitle:
      return EdgeInsets(top: 8.0, leading: 8.0, bottom: 0.0, trailing: 8.0)
    case .largeTitle:
      return EdgeInsets(top: 24.0, leading: 8.0, bottom: 0.0, trailing: 8.0)
    case .custom(_, let padding, _):
      return padding
    }
  }
  
  /// Which type (color, size, position) for label
  private let labelType: ChartLabelType
  
  /// Foreground color for this label
  /// - Returns: Color of label based on its `ChartLabelType`
  private var labelColor: Color {
    switch labelType {
    case .title:
      return Color(UIColor.label)
    case .legend:
      return Color(UIColor.secondaryLabel)
    case .subTitle:
      return Color(UIColor.label)
    case .largeTitle:
      return Color(UIColor.label)
    case .custom(_, _, let color):
      return color
    }
  }
  
  /// Initialize
  /// - Parameters:
  ///   - title: Any `String`
  ///   - type: Which `ChartLabelType` to use
  public init (_ title: String,
               type: ChartLabelType = .title,
               format: String = "%.01f") {
    self.title = title
    labelType = type
    self.format = format
  }
  
  
  private func secondsTohhmm(_ seconds: Int) -> String {
    let minutes = seconds / 60
    let minutesComponent = minutes % 60
    let hours = minutes / 60
    
    var formattedTimeDuration = ""
    
    if hours > 0 {
      formattedTimeDuration.append("\(hours)h ")
    }
    
    if minutesComponent < 10 && minutesComponent > 0 && hours > 0 {
      formattedTimeDuration.append("0")
    }
    formattedTimeDuration.append("\(minutesComponent)m")
    
    return formattedTimeDuration
  }
  
  // We need a way to convert the shown value to a custom format (vs the provided number of decimal points.
  private func formattedValue(_ format: String, _ value: Double) -> String {
    if format.hasPrefix("hhmmss") {
      return secondsTohhmm(Int(value)) + " "
    } else if format.hasPrefix("dist") {
      return String(Int(value / 1000.0)) + " km"
    } else {
      return String(format: format, value)
    }
  }
  
  /// The content and behavior of the `ChartLabel`.
  ///
  /// Displays current value if chart is currently being touched along a data point, otherwise the specified text.
  public var body: some View {
//    let _ = print("chartValue:\(chartValue)")
//    let _ = print("")
//
    HStack {
      if !self.chartValue.interactionInProgress {
        Text(title)
          .font(.system(size: labelSize))
          .bold()
          .foregroundColor(self.labelColor)
          .padding(self.labelPadding)
        Spacer()
      } else {
        Text(textToDisplay)
        .font(.system(size: labelSize))
        .bold()
        .foregroundColor(self.labelColor)
        .padding(self.labelPadding)
        .onAppear {
          self.textToDisplay = self.title
        }
        .onReceive(self.chartValue.objectWillChange) { _ in
          let currentValue = self.chartValue.currentValue
          let currentTarget = self.chartValue.currentValueTarget
          
          let pctOfTarget = currentTarget > 0 ? "(" + String(format: "%.0f%%", currentValue / currentTarget * 100 ) + ")" : ""
          let targetValue = currentValue == 0 && currentTarget > 0 ? " (" + formattedValue(format, currentTarget) + ")" : " "
          let currentValueFmt = currentValue > 0 ? formattedValue(format, currentValue) + " " : ""
          
          self.textToDisplay = self.chartValue.interactionInProgress ? currentValueFmt + pctOfTarget + targetValue : self.title
          
          //  print("chartLabel currentValue:\(currentValue) currentTarget:\(currentTarget) currentValueFmt:\(currentValueFmt) pctOfTarget:\(pctOfTarget) targetValue:\(targetValue) FINAL:\(currentValueFmt + pctOfTarget + targetValue)")
        }
      }
    }
  }
}
