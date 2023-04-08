import Architecture
import UIKit

public struct MainCoordinator: Coordinator {
    private let navigationController: UINavigationController
    private let onSuccessfulLogin: () -> Void

    public init(
        navigationController: UINavigationController,
        onSuccessfulLogin: @escaping () -> Void
    ) {
        self.navigationController = navigationController
        self.onSuccessfulLogin = onSuccessfulLogin
    }

    public func begin() {
        showLoginScreen()
    }
}

private extension MainCoordinator {
    func showLoginScreen() {
        let viewModel = LoginViewModel(onSuccessfulLogin: onSuccessfulLogin)
        let viewController = ViewWithAdapterHostingController<LoginView, LoginViewModel>(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
}
