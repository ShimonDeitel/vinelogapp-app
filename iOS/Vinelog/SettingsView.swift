import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var store: Store
    @Environment(\.dismiss) private var dismiss
    @AppStorage("showNotes") private var showNotes = true
    @AppStorage("iCloudSyncPreview") private var iCloudSyncPreview = false

    var body: some View {
        NavigationStack {
            List {
                Section("Display") {
                    Toggle("Show notes field", isOn: $showNotes)
                        .accessibilityIdentifier("settingsShowNotesToggle")
                    Toggle("iCloud sync (coming soon)", isOn: $iCloudSyncPreview)
                        .disabled(true)
                }

                Section("Purchases") {
                    Button("Restore Purchases") {
                        Task { }
                    }
                    .accessibilityIdentifier("settingsRestoreButton")
                }

                Section("About") {
                    Link("Privacy Policy", destination: URL(string: "https://shimondeitel.github.io/vinelogapp-app/privacy.html")!)
                    Link("Terms of Use", destination: URL(string: "https://shimondeitel.github.io/vinelogapp-app/terms.html")!)
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0")
                            .foregroundStyle(Theme.textSecondary)
                    }
                }
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") { dismiss() }
                        .accessibilityIdentifier("settingsDoneButton")
                }
            }
        }
    }
}
