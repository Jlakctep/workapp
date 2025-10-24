import SwiftUI

struct QuickNoteView: View {
	@Environment(\.dismiss) private var dismiss
	@State private var title: String = "Зустріч: "
	@State private var bodyText: String = ""
	var body: some View {
		NavigationStack {
			Form {
				Section {
					TextField("Тема", text: $title)
					TextEditor(text: $bodyText)
						.frame(minHeight: 120)
				}
			}
			.navigationTitle("Нотатка")
			.toolbar {
				ToolbarItem(placement: .cancellationAction) { Button("Закрити") { dismiss() } }
				ToolbarItem(placement: .confirmationAction) { Button("Зберегти") { Task { await saveAndClose() } } }
			}
		}
		.darkTheme()
	}
	private func saveAndClose() async {
		let note = Note(title: title, body: bodyText)
		try? await FileDataStore.shared.add(note: note)
		dismiss()
	}
}
