import Foundation
import Combine

@MainActor
final class Store: ObservableObject {
    @Published var entries: [CropEntry] = []
    @Published var isPro: Bool = false

    /// Free-tier item cap. Always kept well above seed data count so a fresh
    /// install never hits the paywall immediately.
    static let freeLimit = 10

    private let fileURL: URL

    init() {
        let appSupport = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let dir = appSupport.appendingPathComponent("Vinelog", isDirectory: true)
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        fileURL = dir.appendingPathComponent("entries.json")
        load()
    }

    var canAddMore: Bool {
        isPro || entries.count < Store.freeLimit
    }

    func add(_ entry: CropEntry) {
        guard canAddMore else { return }
        entries.append(entry)
        save()
    }

    func update(_ entry: CropEntry) {
        guard let idx = entries.firstIndex(where: { $0.id == entry.id }) else { return }
        entries[idx] = entry
        save()
    }

    func delete(at offsets: IndexSet) {
        entries.remove(atOffsets: offsets)
        save()
    }

    func delete(_ entry: CropEntry) {
        entries.removeAll { $0.id == entry.id }
        save()
    }

    private func load() {
        if let data = try? Data(contentsOf: fileURL),
           let decoded = try? JSONDecoder().decode([CropEntry].self, from: data) {
            entries = decoded
        } else {
            entries = [
        CropEntry(name: "Roma", variety: "Roma", bed: "Bed A", plantedDate: ""),
        CropEntry(name: "Genovese Basil", variety: "Genovese Basil", bed: "Bed B", plantedDate: ""),
        CropEntry(name: "Snap Peas", variety: "Snap Peas", bed: "Bed C", plantedDate: "")
            ]
            save()
        }
    }

    private func save() {
        if let data = try? JSONEncoder().encode(entries) {
            try? data.write(to: fileURL, options: .atomic)
        }
    }
}
