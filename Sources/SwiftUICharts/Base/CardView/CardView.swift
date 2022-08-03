import SwiftUI

/// View containing data and some kind of chart content
public struct CardView<Content: View>: View, ChartBase {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    public var chartData = ChartData()
    let content: () -> Content
    
    private var showShadow: Bool
    
    @EnvironmentObject var style: ChartStyle
    
    /// Initialize with view options and a nested `ViewBuilder`
    /// - Parameters:
    ///   - showShadow: should card have a rounded-rectangle shadow around it
    ///   - content: <#content description#>
    public init(showShadow: Bool = true, @ViewBuilder content: @escaping () -> Content) {
        self.showShadow = showShadow
        self.content = content
    }
    
    /// The content and behavior of the `CardView`.
    ///
    ///
    public var body: some View {
        ZStack{
            if showShadow {
                RoundedRectangle(cornerRadius: 20)
                    .fill(colorScheme == .dark ? Color.black : Color.white)
                    .shadow(color: colorScheme == .dark ? Color.white.opacity(0.9) : Color.black.opacity(0.9), radius: 8)
            }
            VStack (alignment: .leading) {
                self.content()
            }
            .clipShape(RoundedRectangle(cornerRadius: showShadow ? 20 : 0))
        }
    }
}
