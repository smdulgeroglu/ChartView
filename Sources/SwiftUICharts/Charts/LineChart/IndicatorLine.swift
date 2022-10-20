//
//  IndicatorLine.swift
//  
//
//  Created by Mun Heng Ow on 18/10/2022.
//
import SwiftUI

/// A Vertical Line thru the multi line chart as user moves finger over line in `LineChart`
@available(iOS 14, *)
struct IndicatorLine: View {
  var geometry: GeometryProxy

  /// The content and behavior of the `IndicatorLine`.
  ///
  /// Vertical Line going thru the MultiLineChart
    public var body: some View {
        ZStack {
          Rectangle()
            .foregroundColor(Color(UIColor.label)).opacity(0.8)
            .frame(width: 2, height: geometry.size.height)
            .offset(x: 0, y: -geometry.size.height/2)
        }
        .frame(width: geometry.size.width, height: geometry.size.height)
    }
}
