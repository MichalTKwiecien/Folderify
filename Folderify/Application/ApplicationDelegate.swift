@_exported import Prelude
import UIKit

@main
final class ApplicationDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        setup()
        return true
    }
}

private extension ApplicationDelegate {
    func setup() {
        // TODO: Setup Design System, World, etc.
    }
}
