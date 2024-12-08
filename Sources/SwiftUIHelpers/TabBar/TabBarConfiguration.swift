import SwiftUI

public struct TabBarAnimation: Sendable {
    public let selection: SwiftUI.Animation
    public let visibility: SwiftUI.Animation

    public static let `default` = TabBarAnimation(
        selection: .spring(response: 0.3, dampingFraction: 0.7),
        visibility: .spring(response: 0.3, dampingFraction: 0.7)
    )
}

public struct TabBarLayout: Sendable {
    public let itemSize: CGSize
    public let iconSize: CGSize
    public let itemSpacing: CGFloat
    public let labelSpacing: CGFloat
    public let contentPadding: EdgeInsets
    public let safeAreaPadding: EdgeInsets

    public static let `default` = TabBarLayout(
        itemSize: CGSize(width: 50, height: 50),
        iconSize: CGSize(width: 24, height: 24),
        itemSpacing: 8,
        labelSpacing: 2,
        contentPadding: EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5),
        safeAreaPadding: EdgeInsets(top: 0, leading: 20, bottom: 30, trailing: 20)
    )
}

public struct TabBarBadgeStyle: Sendable {
    let backgroundColor: Color
    let foregroundColor: Color
    let font: Font
    let padding: EdgeInsets

    public static let `default` = TabBarBadgeStyle(
        backgroundColor: .red,
        foregroundColor: .white,
        font: .system(size: 12, weight: .semibold),
        padding: EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
    )
}

public protocol TabBarTheme {
    associatedtype Background: ShapeStyle
    associatedtype ItemBackground: ShapeStyle
    associatedtype Container: Shape
    associatedtype ActiveItem: Shape

    var containerBackground: Background { get }
    var containerShape: Container { get }
    var activeItemShape: ActiveItem { get }
    var activeItemColor: Color { get }
    var inactiveItemColor: Color { get }
    var activeItemBackgroundColor: ItemBackground { get }
    var badgeStyle: TabBarBadgeStyle { get }
}

public struct DefaultTabBarTheme: TabBarTheme {
    public var containerBackground: some ShapeStyle {
        Color(.secondarySystemBackground)
            .shadow(.drop(radius: 10, y: 5))
    }

    public var containerShape: some Shape {
        RoundedRectangle(cornerRadius: 50)
    }

    public var activeItemShape: some Shape {
        Circle()
    }

    public var activeItemColor: Color { .white }
    public var inactiveItemColor: Color { .primary }
    public var activeItemBackgroundColor: Color { .accentColor }
    public var badgeStyle: TabBarBadgeStyle { .default }

    public init() {}
}

public struct TabBarConfiguration<Theme: TabBarTheme> {
    let theme: Theme
    let layout: TabBarLayout
    let animation: TabBarAnimation
    let haptics: HapticFeedbackType
    let showLabels: Bool
    let labelFont: Font

    public static var `default`: TabBarConfiguration<DefaultTabBarTheme> {
        TabBarConfiguration<DefaultTabBarTheme>(
            theme: DefaultTabBarTheme(),
            layout: .default,
            animation: .default,
            haptics: .impact(.light),
            showLabels: false,
            labelFont: .system(size: 11)
        )
    }
}
