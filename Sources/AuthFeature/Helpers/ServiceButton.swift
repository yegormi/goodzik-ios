import SwiftUI

public struct ProviderButton: View {
    private let type: AuthServiceType
    private let action: () -> Void

    public init(
        of type: AuthServiceType,
        action: @escaping () -> Void
    ) {
        self.type = type
        self.action = action
    }

    public var body: some View {
        Button {
            self.action()
        } label: {
            HStack {
                self.type.icon
                    .frame(width: 20, height: 20)
                    .fixedSize()
                Spacer()
                Text("Continue with " + self.type.title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Color.primary)
                Spacer()
            }
        }
        .buttonStyle(.provider)
    }
}

public enum AuthServiceType {
    case google
    case facebook

    public var title: String {
        switch self {
        case .google:
            "Google"
        case .facebook:
            "Facebook"
        }
    }

    public var icon: Image {
        switch self {
        case .google:
            Image(.google)
        case .facebook:
            Image(.facebook)
        }
    }
}
