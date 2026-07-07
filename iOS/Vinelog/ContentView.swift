import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store: Store
    @EnvironmentObject var purchases: PurchaseManager

    @State private var showingAdd = false
    @State private var showingSettings = false
    @State private var showingPaywall = false
    @State private var editingEntry: CropEntry?

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.background.ignoresSafeArea()
                List {
                    ForEach(store.entries) { entry in
                        Button {
                            editingEntry = entry
                        } label: {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(entry.name)
                                    .font(Theme.bodyFont.weight(.semibold))
                                    .foregroundStyle(Theme.textPrimary)
                                Text("\(entry.variety)  路  \(entry.bed)")
                                    .font(Theme.captionFont)
                                    .foregroundStyle(Theme.textSecondary)
                            }
                        }
                        .listRowBackground(Theme.card)
                    }
                    .onDelete { offsets in
                        store.delete(at: offsets)
                    }
                }
                .scrollContentBackground(.hidden)
                .accessibilityIdentifier("entryList")

                if store.entries.isEmpty {
                    VStack(spacing: 8) {
                        Text("No crops yet")
                            .font(Theme.titleFont)
                            .foregroundStyle(Theme.textPrimary)
                        Text("Tap + to add your first one.")
                            .font(Theme.captionFont)
                            .foregroundStyle(Theme.textSecondary)
                    }
                }
            }
            .navigationTitle("Garden Log")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showingSettings = true
                    } label: {
                        Image(systemName: "gearshape")
                    }
                    .accessibilityIdentifier("settingsButton")
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        if store.canAddMore {
                            showingAdd = true
                        } else {
                            showingPaywall = true
                        }
                    } label: {
                        Image(systemName: "plus")
                    }
                    .accessibilityIdentifier("addEntryButton")
                }
            }
            .sheet(isPresented: $showingAdd) {
                EntrySheet(editing: nil)
                    .environmentObject(store)
            }
            .sheet(item: $editingEntry) { entry in
                EntrySheet(editing: entry)
                    .environmentObject(store)
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView()
                    .environmentObject(store)
            }
            .sheet(isPresented: $showingPaywall) {
                PaywallView()
                    .environmentObject(purchases)
            }
            .tint(Theme.accent)
        }
    }
}
