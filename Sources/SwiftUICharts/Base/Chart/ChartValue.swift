import SwiftUI

/// Representation of a single data point in a chart that is being observed
@available(iOS 13.0, *)
public class ChartValue: ObservableObject {
    @Published public var currentString: String = ""
    @Published public var currentValue: Double = 0
    @Published public var currentValueTarget: Double = 0
    @Published public var interactionInProgress: Bool = false
}
