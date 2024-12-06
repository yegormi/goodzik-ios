// import ComposableArchitecture
// import SwiftUI
//
// struct TabBarVisibilityModifier: ViewModifier {
//    let isHidden: Bool
//    @Shared private var isTabBarHidden: Bool
//
//    @State private var previousState: Bool
//
//    init(isHidden: Bool) {
//        self.isHidden = isHidden
//        self._isTabBarHidden = Shared(wrappedValue: false, .isTabBarHidden)
//        self._previousState = State(wrappedValue: isHidden)
//    }
//
//    func body(content: Content) -> some View {
//        content
//            .onAppear {
//                // Store the current state before changing it
//                self.previousState = self.isTabBarHidden
//
//                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
//                    self.$isTabBarHidden.withLock {
//                        $0 = self.isHidden
//                    }
//                }
//            }
//            .onWillDisappear {
//                // Restore the previous state
//                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
//                    self.$isTabBarHidden.withLock {
//                        $0 = self.previousState
//                    }
//                }
//            }
//    }
// }
//
// public extension View {
//    /// Sets the visibility of the custom tab bar.
//    /// - Parameter isHidden: A boolean value indicating whether the tab bar should be hidden.
//    /// - Returns: A modified view with the specified tab bar visibility.
//    func hideTabBar(_ isHidden: Bool = true) -> some View {
//        modifier(TabBarVisibilityModifier(isHidden: isHidden))
//    }
// }
