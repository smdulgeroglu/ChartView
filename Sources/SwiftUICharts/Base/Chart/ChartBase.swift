import SwiftUI

/// Protocol for any type of chart, to get access to underlying data
@available(iOS 13.0, *)
public protocol ChartBase {
    var chartData: ChartData { get }
}
