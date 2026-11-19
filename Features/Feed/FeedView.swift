import SwiftUI

struct FeedView: View {
    @State private var selectedFeed = FeedCategory.home

    var body: some View {
        ZStack {
            OrbitTheme.background.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    header

                    Picker("Feed", selection: $selectedFeed) {
                        ForEach(FeedCategory.allCases) { category in
                            Text(category.title).tag(category)
                        }
                    }
                    .pickerStyle(.segmented)

                    introCard

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Your orbit is taking shape")
                            .font(.title3.weight(.semibold))
                            .foregroundStyle(OrbitTheme.primaryText)

                        Text("The feed will appear here when ORBIT is connected to an approved account. Until then, this is the design foundation — no fake posts or simulated live data.")
                            .font(.subheadline)
                            .foregroundStyle(OrbitTheme.secondaryText)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(18)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(OrbitTheme.surface, in: RoundedRectangle(cornerRadius: OrbitTheme.cardRadius))
                }
                .padding(.horizontal, OrbitTheme.horizontalPadding)
                .padding(.top, 12)
                .padding(.bottom, 32)
            }
        }
        .navigationBarHidden(true)
    }

    private var header: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 4) {
                Text("ORBIT")
                    .font(.system(size: 28, weight: .black, design: .rounded))
                    .tracking(2.4)
                    .foregroundStyle(OrbitTheme.primaryText)

                Text("The internet, in your orbit.")
                    .font(.caption)
                    .foregroundStyle(OrbitTheme.secondaryText)
            }

            Spacer()

            Image(systemName: "circle.hexagongrid.fill")
                .font(.system(size: 25, weight: .medium))
                .foregroundStyle(OrbitTheme.accent)
                .frame(width: 48, height: 48)
                .background(OrbitTheme.elevatedSurface, in: Circle())
                .accessibilityHidden(true)
        }
    }

    private var introCard: some View {
        HStack(spacing: 14) {
            Image(systemName: "sparkles")
                .font(.title2)
                .foregroundStyle(OrbitTheme.accent)
                .frame(width: 44, height: 44)
                .background(OrbitTheme.accent.opacity(0.12), in: RoundedRectangle(cornerRadius: 14))

            VStack(alignment: .leading, spacing: 4) {
                Text("A calmer way to keep up")
                    .font(.headline)
                    .foregroundStyle(OrbitTheme.primaryText)

                Text("Your communities. Your pace. Your rules.")
                    .font(.caption)
                    .foregroundStyle(OrbitTheme.secondaryText)
            }
            Spacer(minLength: 0)
        }
        .padding(16)
        .background(OrbitTheme.surface, in: RoundedRectangle(cornerRadius: OrbitTheme.cardRadius))
        .overlay {
            RoundedRectangle(cornerRadius: OrbitTheme.cardRadius)
                .stroke(OrbitTheme.separator, lineWidth: 1)
        }
    }
}

private enum FeedCategory: String, CaseIterable, Identifiable {
    case home
    case popular
    case all

    var id: String { rawValue }

    var title: String {
        switch self {
        case .home: "Home"
        case .popular: "Popular"
        case .all: "All"
        }
    }
}

#Preview {
    NavigationStack {
        FeedView()
    }
}
