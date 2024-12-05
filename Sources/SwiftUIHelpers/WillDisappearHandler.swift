import SwiftUI

private struct WillDisappearHandler: UIViewControllerRepresentable {
    let onWillDisappear: () -> Void

    func makeUIViewController(context _: Context) -> UIViewController {
        ViewWillDisappearViewController(onWillDisappear: self.onWillDisappear)
    }

    func updateUIViewController(_: UIViewController, context _: Context) {}

    private class ViewWillDisappearViewController: UIViewController {
        let onWillDisappear: () -> Void

        init(onWillDisappear: @escaping () -> Void) {
            self.onWillDisappear = onWillDisappear
            super.init(nibName: nil, bundle: nil)
        }

        @available(*, unavailable)
        required init?(coder _: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            self.onWillDisappear()
        }
    }
}

extension View {
    func onWillDisappear(_ perform: @escaping () -> Void) -> some View {
        background(WillDisappearHandler(onWillDisappear: perform))
    }
}
