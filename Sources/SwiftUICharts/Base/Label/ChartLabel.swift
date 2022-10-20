import SwiftUI

/// What kind of label - this affects color, size, position of the label
@available(iOS 14, *)
public enum ChartLabelType {
  case title
  case subTitle
  case largeTitle
  case custom(size: CGFloat, padding: EdgeInsets, color: Color)
  case legend
}

/// A chart may contain any number of labels in pre-set positions based on their `ChartLabelType`
@available(iOS 14, *)
public struct ChartLabel: View {
  @EnvironmentObject var chartValue: ChartValue
  @State var textToDisplay:String = ""
  @State var textToDisplay2:String = ""
  @State var textToDisplay3:String = ""
  @State var label1:String = ""
  @State var label2:String = ""
  @State var label3:String = ""
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
    } else if format.hasPrefix("metricDist") {
      return String(Int(value / 1000.0)) + "km"
    } else if format.hasPrefix("imperialDist") {
      return String(Int(value / 1609.0)) + "mi"
    } else if format.hasPrefix("metricElev") {
      return String(Int(value)) + "m"
    } else if format.hasPrefix("imperialElev") {
      return String(Int(value / 3.28084)) + "ft"
    } else if format.hasPrefix("calories") {
      return String(Int(value)) + "kCal"
    } else if format.hasPrefix("joules") {
      return String(Int(value / 1000.0)) + "kJ"
    } else if format.hasPrefix("RHR42D") {
      return String(Int(value))
    } else if format.hasPrefix("RHR") {
//      return chartValue.currentString + " " + String(Int(value))
      return String(Int(value))
    } else {
      return String(format: format, value)
    }
  }
  
  /// The content and behavior of the `ChartLabel`.
  ///
  /// Displays current value if chart is currently being touched along a data point, otherwise the specified text.
  public var body: some View {
//    let _ = print("chartValue:\(chartValue.currentValue) chartValueTarget:\(chartValue.currentValueTarget) labelPadding:\(labelPadding)")
//    let _ = print("")
//
    HStack {
      if !self.chartValue.interactionInProgress {
        Text(title)
          .font(.system(size: labelSize))
          .bold()
          .foregroundColor(self.labelColor)
          .padding(self.labelPadding)
          .minimumScaleFactor(0.7)
        Spacer()
      } else if format == "RHR" {
        VStack(alignment: .leading) {
          Group{
//            Text(label1)
//                .font(.caption) +
            Text(textToDisplay)
              .font(.system(size: labelSize)) +
            Text(label2)
                .font(.caption) +
            Text(textToDisplay2)
              .font(.system(size: labelSize)) +
            Text(label3)
              .font(.caption) +
            Text(textToDisplay3)
              .font(.system(size: labelSize))
          }
            .minimumScaleFactor(0.7)
            .lineLimit(1)
            .foregroundColor(self.labelColor)
            .padding(self.labelPadding)
        }
        .onAppear {
          self.textToDisplay = self.title
        }
        .onReceive(self.chartValue.objectWillChange) { _ in
          let currentString = self.chartValue.currentString
          let currentValue = self.chartValue.currentValue
          let currentTarget = self.chartValue.currentValueTarget
          
          let currentValueFmt = currentValue > 0 ? formattedValue(format, currentValue) : ""
          let avg42day = currentTarget > 0 ? formattedValue("RHR42D", currentTarget) : " "
          
          
          self.textToDisplay = self.chartValue.interactionInProgress ? currentString : self.title
          self.textToDisplay2 = self.chartValue.interactionInProgress ? currentValueFmt : ""
          self.textToDisplay3 = self.chartValue.interactionInProgress ? avg42day : ""
          self.label1 = self.chartValue.interactionInProgress ? "Date " : ""
          self.label2 = self.chartValue.interactionInProgress && currentValue  > 0 ? "  RHR " : ""
          self.label3 = self.chartValue.interactionInProgress && currentTarget > 0 ? "  42D " : ""
          
//          print("chartLabel chartStr:\(currentString) currentValue:\(currentValue) currentTarget:\(currentTarget) currentValueFmt:\(currentValueFmt) ")// pctOfTarget:\(pctOfTarget) targetValue:\(targetValue) FINAL:\(currentValueFmt + pctOfTarget + targetValue) format:\(format)")
        }
      } else {
        Text(textToDisplay)
        .font(.system(size: labelSize))
        .bold()
        .minimumScaleFactor(0.7)
        .lineLimit(1)
        .foregroundColor(self.labelColor)
        .padding(self.labelPadding)
        .onAppear {
          self.textToDisplay = self.title
        }
        .onReceive(self.chartValue.objectWillChange) { _ in
          let currentString = self.chartValue.currentString
          let currentValue = self.chartValue.currentValue
          let currentTarget = self.chartValue.currentValueTarget
          
          let pctOfTarget = currentTarget > 0 ? "(" + String(Int((currentValue / currentTarget) * 100)) + "%)" : ""
          let targetValue = currentValue == 0 && currentTarget > 0 ? " (" + formattedValue(format, currentTarget) + ")" : " "
          let currentValueFmt = currentValue > 0 ? formattedValue(format, currentValue) + " " : ""
          
          self.textToDisplay = self.chartValue.interactionInProgress ? currentValueFmt + pctOfTarget + targetValue : self.title
          
          // print("chartLabel chartStr:\(currentString) currentValue:\(currentValue) currentTarget:\(currentTarget) currentValueFmt:\(currentValueFmt) pctOfTarget:\(pctOfTarget) targetValue:\(targetValue) FINAL:\(currentValueFmt + pctOfTarget + targetValue) format:\(format)")
        }
      }
    }
  }
}
