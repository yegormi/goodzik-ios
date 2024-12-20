import AppearanceClient
import AppFeature
import AppTrackingTransparency
import ComposableArchitecture
import OSLog
import SharedModels
import Styleguide
import SwiftUI

private let logger = Logger(subsystem: "iOS", category: "App")

final class AppDelegate: NSObject, UIApplicationDelegate {
    @Dependency(\.appearance) var appearance

    func application(
        _: UIApplication,
        didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]? = nil
    )
        -> Bool
    {
        Task { await self.appearance.configure() }

        // Override apple's buggy alerts tintColor not taking effect.
        UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = UIColor.accent

        self.requireAppTrackingTransparency()

        return true
    }

    func requireAppTrackingTransparency() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            ATTrackingManager.requestTrackingAuthorization { status in
                switch status {
                case .authorized:
                    logger.info("Tracking permissions are allowed. Analytics are initialized.")
                case .notDetermined:
                    logger.info("Tracking permissions are not determined.")
                case .restricted:
                    logger.info("Tracking permissions are restricted.")
                case .denied:
                    logger.info("Tracking permissions are denied.")
                @unknown default:
                    logger.info("Tracking permissions have an unknown status.")
                }
            }
        }
    }
}

@main
struct GoodzikApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    let store = Store(initialState: AppReducer.State()) {
        AppReducer()
            ._printChanges()
    }

    var body: some Scene {
        WindowGroup {
            AppView(store: self.store)
                .scrollIndicators(.never)
        }
    }
}
