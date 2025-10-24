import Foundation

struct Person: Identifiable, Codable, Equatable {
	let id: UUID
	var name: String
	var role: String
	var email: String?
	var phone: String?
	var telegram: String?
	var influence: Int? // 0..100
	var interest: Int?  // 0..100
	var tags: [String]

	init(id: UUID = UUID(), name: String, role: String, email: String? = nil, phone: String? = nil, telegram: String? = nil, influence: Int? = nil, interest: Int? = nil, tags: [String] = []) {
		self.id = id
		self.name = name
		self.role = role
		self.email = email
		self.phone = phone
		self.telegram = telegram
		self.influence = influence
		self.interest = interest
		self.tags = tags
	}
}

struct Note: Identifiable, Codable, Equatable {
	let id: UUID
	var title: String
	var body: String
	var date: Date
	var personIds: [UUID]
	var projectTag: String?

	init(id: UUID = UUID(), title: String, body: String, date: Date = Date(), personIds: [UUID] = [], projectTag: String? = nil) {
		self.id = id
		self.title = title
		self.body = body
		self.date = date
		self.personIds = personIds
		self.projectTag = projectTag
	}
}

enum WaitingStatus: String, Codable { case open, done, snoozed }

struct WaitingItem: Identifiable, Codable, Equatable {
	let id: UUID
	var title: String
	var personId: UUID?
	var projectTag: String?
	var pingAt: Date
	var status: WaitingStatus

	init(id: UUID = UUID(), title: String, personId: UUID? = nil, projectTag: String? = nil, pingAt: Date, status: WaitingStatus = .open) {
		self.id = id
		self.title = title
		self.personId = personId
		self.projectTag = projectTag
		self.pingAt = pingAt
		self.status = status
	}
}

enum DocProvider: String, Codable { case iCloud, gDrive, notion, local }

enum DocStatus: String, Codable { case draft, inReview, approved }

struct Approver: Identifiable, Codable, Equatable {
	let id: UUID
	var personId: UUID
	var approvedAt: Date?

	init(id: UUID = UUID(), personId: UUID, approvedAt: Date? = nil) {
		self.id = id
		self.personId = personId
		self.approvedAt = approvedAt
	}
}

struct DocumentItem: Identifiable, Codable, Equatable {
	let id: UUID
	var title: String
	var link: String?
	var provider: DocProvider
	var status: DocStatus
	var approvers: [Approver]
	var deadline: Date?
	var projectTag: String?

	init(id: UUID = UUID(), title: String, link: String? = nil, provider: DocProvider = .iCloud, status: DocStatus = .draft, approvers: [Approver] = [], deadline: Date? = nil, projectTag: String? = nil) {
		self.id = id
		self.title = title
		self.link = link
		self.provider = provider
		self.status = status
		self.approvers = approvers
		self.deadline = deadline
		self.projectTag = projectTag
	}
}
