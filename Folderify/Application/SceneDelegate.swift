import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    private let bootstrap = ApplicationBootstrap()

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let scene = (scene as? UIWindowScene) else { return }

        bootstrap.start()
        let window = UIWindow(windowScene: scene)
        window.rootViewController = bootstrap.navigationController
        self.window = window
        window.makeKeyAndVisible()
    }
}
