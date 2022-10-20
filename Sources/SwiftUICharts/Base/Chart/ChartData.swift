import SwiftUI

/// An observable wrapper for an array of data for use in any chart
@available(iOS 13.0, *)
public class ChartData: ObservableObject {
  @Published public var data: [(String, Double, Double)] = []
 
  var values: [String] {
    data.map { $0.0 }
  }
  
  var points: [Double] {
    data.map { $0.1 }
  }
  
  var pointsTarget: [Double] {
    data.map { $0.2 }
  }
  
  
  // https://stackoverflow.com/a/60092969/14414215
    var globalMin:Double {
      // Ignore if array is all zeros.
      if !data.compactMap({$0.2}).allSatisfy({$0 == 0}) {
        if let min = data.flatMap({[$0.1, $0.2]}).min() {
            return min
        }
      } else {
        if let min = data.map({$0.1}).min() {
            return min
        }
      }
      return 0
  }


  // https://stackoverflow.com/a/60092969/14414215
    var globalMax:Double {
      if let max = data.flatMap({[$0.1, $0.2]}).max() {
          return max
      }
      return 0
  }
  
  var normalisedPoints: [Double] {
    let maxData = points.map { abs($0) }.max() ?? 0.0
    let maxOverlay = pointsTarget.map { abs($0) }.max() ?? 0.0
    let maxOfMax = max(1.0, maxData, maxOverlay)
    let normalised = points.map { $0 / maxOfMax }
    // print("---- > nPts   pts:\(points) maxData:\(maxData) maxOverlay:\(maxOverlay) maxOfMax:\(maxOfMax) nPt:\(normalised)    pMap:\(points.map{$0})")
    
    return normalised
 }
  
  var normalisedPointsTarget: [Double] {
    let maxData = points.map { abs($0) }.max() ?? 0.0
    let maxOverlay = pointsTarget.map { abs($0) }.max() ?? 0.0
    let maxOfMax = max(1.0, maxData, maxOverlay)
    let normalised = pointsTarget.map { $0 / maxOfMax }
    //print("---- > nPtsT pTgt:\(pointsTarget) maxData:\(maxData) maxOverlay:\(maxOverlay) maxOfMax:\(maxOfMax) nPt:\(normalised) pTgMap:\(pointsTarget.map{$0})")
    
    return normalised
 }
  
  var normalisedRange: Double {
    let normalisedPtMin = normalisedPoints.min() ?? 0.0
    
    if !normalisedPointsTarget.allSatisfy({$0 == 0}) {
      let normalisedPtTgtMin = normalisedPointsTarget.min() ?? 0.0
      let minMin = normalisedPtMin > normalisedPtTgtMin ? normalisedPtTgtMin : normalisedPtMin
      let nRange = ((normalisedPoints.max() ?? 0.0) - minMin)
      
      // let _ = print("normalisedPtMin:\(normalisedPtMin) normalisePtTgtMin:\(normalisedPtTgtMin) minMin:\(minMin) nRange:\(nRange)")
      return nRange
    } else {
      let nRange = ((normalisedPoints.max() ?? 0.0) - normalisedPtMin)
      // let _ = print("normalisedPtMin:\(normalisedPtMin) nRange:\(nRange)")
      
      return nRange
    }
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
