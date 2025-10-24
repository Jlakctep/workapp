import Foundation

actor FileDataStore {
	static let shared = FileDataStore()

	private struct DB: Codable {
		var people: [Person] = []
		var notes: [Note] = []
		var waiting: [WaitingItem] = []
		var docs: [DocumentItem] = []
	}

	private var db = DB()
	private let url: URL

	init(filename: String = "pmhub-db.json") {
		let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
		self.url = dir.appendingPathComponent(filename)
	}

	// MARK: - Load/Save
	func load() async throws {
		if FileManager.default.fileExists(atPath: url.path) == false {
			try await save() // создаём пустую БД
			return
		}
		let data = try Data(contentsOf: url)
		let decoded = try JSONDecoder().decode(DB.self, from: data)
		self.db = decoded
	}

	func save() async throws {
		let encoder = JSONEncoder()
		encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
		let data = try encoder.encode(db)
		try data.write(to: url, options: .atomic)
	}

	// MARK: - People
	func getPeople() -> [Person] { db.people }
	func upsert(person: Person) async throws {
		if let idx = db.people.firstIndex(where: { $0.id == person.id }) { db.people[idx] = person } else { db.people.append(person) }
		try await save()
	}

	// MARK: - Notes
	func add(note: Note) async throws { db.notes.append(note); try await save() }
	func getNotes(for personId: UUID?) -> [Note] {
		guard let pid = personId else { return db.notes }
		return db.notes.filter { $0.personIds.contains(pid) }
	}

	// MARK: - Waiting
	func add(waiting: WaitingItem) async throws { db.waiting.append(waiting); try await save() }
	func getWaiting() -> [WaitingItem] { db.waiting }
	func completeWaiting(id: UUID) async throws {
		guard let i = db.waiting.firstIndex(where: { $0.id == id }) else { return }
		db.waiting[i].status = .done
		try await save()
	}
	func snoozeWaiting(id: UUID, by days: Int) async throws {
		guard let i = db.waiting.firstIndex(where: { $0.id == id }) else { return }
		if let newDate = Calendar.current.date(byAdding: .day, value: days, to: db.waiting[i].pingAt) { db.waiting[i].pingAt = newDate }
		try await save()
	}

	// MARK: - Docs
	func add(document: DocumentItem) async throws { db.docs.append(document); try await save() }
	func getDocuments() -> [DocumentItem] { db.docs }
	func update(document: DocumentItem) async throws {
		guard let i = db.docs.firstIndex(where: { $0.id == document.id }) else { return }
		db.docs[i] = document
		try await save()
	}
}
