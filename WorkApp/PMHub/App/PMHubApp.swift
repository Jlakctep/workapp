import SwiftUI

@main
struct PMHubApp: App {
	@State private var didLoad = false
	var body: some Scene {
		WindowGroup {
			RootView()
				.task {
					guard didLoad == false else { return }
					didLoad = true
					try? await FileDataStore.shared.load()
				}
		}
	}
}

struct RootView: View {
	@State private var isFabExpanded: Bool = false
	@State private var presentQuickNote: Bool = false
	@State private var presentNewWaiting: Bool = false
	@State private var presentNewDocument: Bool = false

	var body: some View {
		ZStack {
			TabView {
				HomeView()
					.tabItem { Label("Home", systemImage: "sparkles") }

				WaitingView()
					.tabItem { Label("Waiting", systemImage: "clock") }

				PeopleView()
					.tabItem { Label("People", systemImage: "person.2") }

				DocsView()
					.tabItem { Label("Docs", systemImage: "doc.text") }
			}

			FloatingActionMenu(isExpanded: $isFabExpanded) {
				FloatingActionMenu.Item(title: "Нотатка", systemImage: "note.text") {
					presentQuickNote = true
				}
				FloatingActionMenu.Item(title: "Очікування", systemImage: "hourglass") {
					presentNewWaiting = true
				}
				FloatingActionMenu.Item(title: "Документ", systemImage: "doc.badge.plus") {
					presentNewDocument = true
				}
			}
		}
		.sheet(isPresented: $presentQuickNote) { QuickNoteView() }
		.sheet(isPresented: $presentNewWaiting) { NewWaitingView() }
		.sheet(isPresented: $presentNewDocument) { NewDocumentView() }
	}
}
