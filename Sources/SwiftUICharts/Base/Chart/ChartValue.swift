import SwiftUI

/// Representation of a single data point in a chart that is being observed
@available(iOS 13.0, *)
public class ChartValue: ObservableObject {
    @Published var currentString: String = ""
    @Published var currentValue: Double = 0
    @Published var currentValueTarget: Double = 0
    @Published var interactionInProgress: Bool = false
}
