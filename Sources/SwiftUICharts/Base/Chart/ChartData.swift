import SwiftUI

/// An observable wrapper for an array of data for use in any chart
public class ChartData: ObservableObject {
  @Published public var data: [(String, Double, Double)] = []
  
  var points: [Double] {
    data.map { $0.1 }
  }
  
  var pointsTarget: [Double] {
    data.map { $0.2 }
  }
  
  var values: [String] {
    data.map { $0.0 }
  }
  
  var normalisedPoints: [Double] {
    let maxData = points.map { abs($0) }.max() ?? 0.0
    let maxOverlay = pointsTarget.map { abs($0) }.max() ?? 0.0
    let maxOfMax = max(1.0, maxData, maxOverlay)
    let normalised = points.map { $0 / maxOfMax }
//    print("---- > normalisedPoints               points:\(points) maxData:\(maxData) maxOverlay:\(maxOverlay) maxOfMax:\(maxOfMax) normalisedPt:\(normalised)")
    
    return normalised
 }
  
  var normalisedPointsTarget: [Double] {
    let maxData = points.map { abs($0) }.max() ?? 0.0
    let maxOverlay = pointsTarget.map { abs($0) }.max() ?? 0.0
    let maxOfMax = max(1.0, maxData, maxOverlay)
    let normalised = pointsTarget.map { $0 / maxOfMax }
//    print("---- > normalisedPointsOverlay pointsOverlay:\(pointsOverlay) maxData:\(maxData) maxOverlay:\(maxOverlay) maxOfMax:\(maxOfMax) normalisedPt:\(normalised)")
    
    return normalised
 }
  
  var normalisedRange: Double {
    (normalisedPoints.max() ?? 0.0) - (normalisedPoints.min() ?? 0.0)
  }
  
  var isInNegativeDomain: Bool {
    (points.min() ?? 0.0) < 0
  }
  
  /// Initialize with data array
  /// - Parameter data: Array of `Double`
  public init(_ data: [Double]) {
    self.data = data.map { ("", $0, 0.0) }
  }
  
  public init(_ data: [(String, Double)]) {
    self.data = data.map { ($0, $1, 0.0)}
  }
  
  public init(_ data: [(String, Double, Double)]) {
    self.data = data
  }
  
  public init() {
    self.data = []
  }
}
