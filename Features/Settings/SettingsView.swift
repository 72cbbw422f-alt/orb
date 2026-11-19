import SwiftUI

struct SettingsView: View {
    @AppStorage("orbit.feedDensity") private var feedDensity = FeedDensity.comfortable.rawValue
    @AppStorage("orbit.hapticsEnabled") private var hapticsEnabled = true

    var body: some View {
        ZStack {
            OrbitTheme.background.ignoresSafeArea()

            Form {
                Section {
                    HStack(spacing: 12) {
                        Image(systemName: "circle.hexagongrid.fill")
                            .font(.title2)
                            .foregroundStyle(OrbitTheme.accent)
                            .frame(width: 48, height: 48)
                            .background(OrbitTheme.accent.opacity(0.12), in: RoundedRectangle(cornerRadius: 14))

                        VStack(alignment: .leading, spacing: 3) {
                            Text("ORBIT")
                                .font(.headline.weight(.bold))
                                .tracking(1.2)
                            Text("Your personal reading space")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.vertical, 6)
                    .listRowBackground(OrbitTheme.surface)
                }

                Section("Reading") {
                    Picker("Feed density", selection: $feedDensity) {
                        ForEach(FeedDensity.allCases) { density in
                            Text(density.title).tag(density.rawValue)
                        }
                    }
                    .tint(OrbitTheme.accent)

                    Toggle("Haptic feedback", isOn: $hapticsEnabled)
                        .tint(OrbitTheme.accent)
                }

                Section("Account") {
                    Label("Account connection", systemImage: "person.crop.circle")
                    Text("Account sign-in will be enabled after the platform API access and OAuth requirements have been verified.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Section("About") {
                    LabeledContent("Version", value: "0.1.0 · Preview")
                    LabeledContent("Build", value: "Development")
                }
            }
            .scrollContentBackground(.hidden)
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.large)
    }
}

enum FeedDensity: String, CaseIterable, Identifiable {
    case comfortable
    case compact
    case classic

    var id: String { rawValue }

    var title: String {
        switch self {
        case .comfortable: "Comfortable"
        case .compact: "Compact"
        case .classic: "Classic"
        }
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
}
