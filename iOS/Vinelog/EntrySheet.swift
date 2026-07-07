import SwiftUI

struct EntrySheet: View {
    @EnvironmentObject var store: Store
    @Environment(\.dismiss) private var dismiss

    var editing: CropEntry?

    @State private var name: String = ""
    @State private var field1: String = ""
    @State private var field2: String = ""
    @State private var extraField: String = ""
    @State private var notes: String = ""
    @FocusState private var isFocused: Bool

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Name", text: $name)
                        .accessibilityIdentifier("entryNameField")
                    TextField("Variety", text: $field1)
                        .accessibilityIdentifier("entryField1Field")
                    TextField("Bed", text: $field2)
                        .accessibilityIdentifier("entryField2Field")
                    TextField("Planted", text: $extraField)
                        .accessibilityIdentifier("entryExtraField")
                    TextField("Notes", text: $notes, axis: .vertical)
                        .accessibilityIdentifier("entryNotesField")

                }
            }
            .scrollDismissesKeyboard(.interactively)
            .contentShape(Rectangle())
            .onTapGesture { isFocused = false }
            .navigationTitle(editing == nil ? "Add Crop" : "Edit Crop")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .accessibilityIdentifier("entryCancelButton")
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                        .accessibilityIdentifier("entrySaveButton")
                        .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
            .onAppear {
                if let e = editing {
                    name = e.name
                    field1 = e.variety
                    field2 = e.bed
                    extraField = e.plantedDate
                    notes = e.notes
                }
            }
        }
    }

    private func save() {
        if var e = editing {
            e.name = name
            e.variety = field1
            e.bed = field2
            e.plantedDate = extraField
            e.notes = notes
            store.update(e)
        } else {
            let entry = CropEntry(name: name, variety: field1, bed: field2, plantedDate: extraField, notes: notes)
            store.add(entry)
        }
        dismiss()
    }
}
