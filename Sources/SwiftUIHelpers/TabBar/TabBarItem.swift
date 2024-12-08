import SwiftUI

public protocol TabBarItem: Identifiable, Hashable {
    associatedtype Icon: View
    var id: Self { get }
    var title: LocalizedStringKey { get }
    var icon: Icon { get }
    var badgeCount: Int? { get }
}

public extension TabBarItem {
    var id: Self { self }
    var badgeCount: Int? { nil }
}
