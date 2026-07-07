import Foundation

struct CropEntry: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var name: String
    var variety: String
    var bed: String
    var plantedDate: String
    var notes: String = ""
    var createdAt: Date = Date()
}
