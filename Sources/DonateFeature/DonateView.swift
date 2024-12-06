import ComposableArchitecture
import Foundation
import Styleguide
import SwiftUI
import SwiftUIHelpers

@ViewAction(for: Donate.self)
public struct DonateView: View {
    @Bindable public var store: StoreOf<Donate>

    public init(store: StoreOf<Donate>) {
        self.store = store
    }

    public var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                self.cardNumberView
                self.monoJarButton
                self.payPalButton
            }
        }
        .contentMargins(.all, 20, for: .scrollContent)
        .onAppear {
            send(.onAppear)
        }
    }

    private var monoJarButton: some View {
        Button {
            send(.monoJarButtonTapped)
        } label: {
            HStack {
                Image(.monobankLogo)
                    .resizable()
                    .frame(width: 24, height: 24)
                Text("Donate via Monobank")
                    .font(.headline)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.primary)
            .foregroundColor(Color(UIColor.systemBackground))
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.5), radius: 4, y: 2)
            .buttonStyle(.plain)
        }
    }

    private var cardNumberView: some View {
        VStack(alignment: .leading) {
            Text("Card Number")
                .font(.subheadline)
                .foregroundColor(.secondary)

            HStack {
                Text("5375 4112 0381 7304")
                    .font(.system(.body, design: .monospaced))

                Spacer()

                Button {
                    send(.copyCardButtonTapped)
                } label: {
                    Image(systemName: self.store.copiedCardNumber ? "checkmark" : "doc.on.doc")
                        .frame(width: 24, height: 24)
                        .foregroundColor(.accentColor)
                }
                .animation(.bouncy, value: self.store.copiedCardNumber)
            }
            .padding()
            .background(Color.secondary.opacity(0.1))
            .cornerRadius(12)
        }
    }

    private var payPalButton: some View {
        Button {
            send(.payPalButtonTapped)
        } label: {
            HStack {
                Image(.paypalLogo)
                    .resizable()
                    .frame(width: 24, height: 24)
                Text("Donate via PayPal")
                    .font(.headline)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color(UIColor.systemBackground))
            .foregroundColor(Color.primary)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.3), radius: 4, y: 2)
            .buttonStyle(.plain)
        }
    }
}

#Preview {
    DonateView(store: Store(initialState: Donate.State()) {
        Donate()
    })
}
