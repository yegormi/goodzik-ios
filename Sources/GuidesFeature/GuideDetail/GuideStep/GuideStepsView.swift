import ComposableArchitecture
import SharedModels
import Styleguide
import SwiftUI
import SwiftUIHelpers

@ViewAction(for: GuideSteps.self)
public struct GuideStepsView: View {
    @Bindable public var store: StoreOf<GuideSteps>

    public init(store: StoreOf<GuideSteps>) {
        self.store = store
    }

    public var body: some View {
        GeometryReader { geometry in
            TabView(selection: Binding(
                get: { self.store.currentIndex },
                set: { send(.pageChanged($0)) }
            )) {
                ForEach(Array(self.store.steps.enumerated()), id: \.element.id) { index, step in
                    StepView(step: step)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .padding(.bottom, 70)
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .indexViewStyle(.page(backgroundDisplayMode: .never))
            .overlay(alignment: .bottom) {
                self.navigationBar
                    .padding([.leading, .trailing, .top], 30)
            }
        }
    }

    private var navigationBar: some View {
        HStack {
            Button {
                send(.previousTapped)
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(Color.primary)
                    .padding()
            }
            .disabled(self.store.currentIndex == 0)
            .padding(.leading)

            Spacer()

            Text("\(self.store.currentIndex + 1) / \(self.store.steps.count)")
                .monospacedDigit()
                .font(.system(size: 20))
                .foregroundStyle(Color.primary)
                .padding()

            Spacer()

            Button {
                send(.nextTapped)
            } label: {
                Image(systemName: "chevron.right")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(Color.primary)
                    .padding()
            }
            .disabled(self.store.currentIndex == self.store.steps.count - 1)
            .padding(.trailing)
        }
        .frame(maxWidth: .infinity)
        .background {
            RoundedRectangle(cornerRadius: 20)
                .foregroundStyle(Color(uiColor: .secondarySystemGroupedBackground).opacity(0.8))
                .shadow(color: Color.black.opacity(0.1), radius: 5)
        }
    }
}

private struct StepView: View {
    let step: GuideDetails.Step

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                ImageCard(imageURL: self.step.imageURL)

                self.stepTitle

                Divider()

                self.stepDescription
            }
        }
        .contentMargins(.all, 30, for: .scrollContent)
    }

    private var stepTitle: some View {
        Text(self.step.name)
            .font(.system(size: 20, weight: .semibold))
    }

    private var stepDescription: some View {
        Text(self.step.description)
            .font(.system(size: 15))
            .foregroundStyle(.secondary)
    }
}

struct ImageCard: View {
    let imageURL: URL?

    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(Color.black.opacity(0.4))
            .frame(maxWidth: .infinity)
            .aspectRatio(1.0, contentMode: .fit)
            .background(
                AsyncImage(url: self.imageURL) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .blur(radius: 10)
                    }
                }
            )
            .overlay(
                AsyncImage(url: self.imageURL) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .shadow(radius: 10)
                    } else {
                        ProgressView()
                    }
                }
            )
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(radius: 10)
            .progressViewStyle(.automatic)
    }
}
