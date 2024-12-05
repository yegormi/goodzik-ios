import ComposableArchitecture
import Foundation
import SharedModels
import Styleguide
import SwiftUI

public struct SettingsGeneralView: View {
    @Bindable public var store: StoreOf<SettingsGeneral>
    @Environment(\.colorScheme) private var colorScheme

    public init(store: StoreOf<SettingsGeneral>) {
        self.store = store
    }

    public var body: some View {
        VStack(spacing: 24) {
            VStack(alignment: .leading, spacing: 16) {
                Text("Appearance")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.neutral500)
                    .padding(.horizontal, 16)

                self.appearancePicker
            }

            Spacer()
        }
        .padding(.top, 30)
    }

    private var appearancePicker: some View {
        HStack(spacing: 8) {
            ForEach(PhoneAppearance.allCases, id: \.self) { appearance in
                self.appearanceOption(appearance)
            }
        }
        .padding(.horizontal, 16)
    }

    private func appearanceOption(_ appearance: PhoneAppearance) -> some View {
        Button {
            self.store.send(.view(.appearanceSelected(appearance)))
        } label: {
            VStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(self.appearanceBackground(for: appearance))
                        .overlay {
                            Image(systemName: appearance.icon)
                                .font(.system(size: 24))
                                .foregroundStyle(self.appearanceIconColor(for: appearance))
                        }
                        .overlay {
                            if self.store.selectedAppearance == appearance {
                                RoundedRectangle(cornerRadius: 12)
                                    .strokeBorder(Color.accentColor, lineWidth: 2)
                            }
                        }
                }
                .frame(maxWidth: .infinity, maxHeight: 70)
                .shadow(color: self.shadowColor(for: appearance), radius: 2, x: 0, y: 1)

                Text(appearance.rawValue)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(self.store.selectedAppearance == appearance ? Color.accentColor : Color.primary)
            }
        }
        .frame(maxWidth: .infinity)
    }

    private func appearanceBackground(for appearance: PhoneAppearance) -> Color {
        switch appearance {
        case .system:
            self.colorScheme == .dark ? Color(white: 0.2) : Color(white: 0.95)
        case .light:
            .white
        case .dark:
            Color(white: 0.15)
        }
    }

    private func appearanceIconColor(for appearance: PhoneAppearance) -> Color {
        switch appearance {
        case .system:
            .primary
        case .light:
            .black
        case .dark:
            .white
        }
    }

    private func shadowColor(for appearance: PhoneAppearance) -> Color {
        switch appearance {
        case .system:
            self.colorScheme == .dark ? Color.black.opacity(0.3) : Color.black.opacity(0.1)
        case .light:
            Color.black.opacity(0.1)
        case .dark:
            Color.black.opacity(0.3)
        }
    }
}

#Preview {
    SettingsGeneralView(
        store: Store(
            initialState: SettingsGeneral.State(user: .mock)
        ) {
            SettingsGeneral()
        }
    )
}
