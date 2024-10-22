//
//  SwiftDataView.swift
//  CookBookSwiftUI
//
//  Created by Pavel Bartashov on 4/10/2024.
//

import SwiftData
import SwiftUI

struct SwiftDataView: View {

    @Environment(\.modelContext) private var modelContext
    @Query(
        filter: #Predicate<Book> { book in
            if book.title.localizedStandardContains("x") {
                if book.author == "Test Author 6" {
                    return true
                } else {
                    return false
                }
            } else {
                return false
            }
        },
        sort: [
            SortDescriptor(\Book.title),
            SortDescriptor(\Book.author)
        ]) private var books: [Book]

    @State private var lastModified = Date.now
    private var didSavePublisher: NotificationCenter.Publisher {
        NotificationCenter.default
            .publisher(for: ModelContext.didSave, object: modelContext)
    }

    @State private var showAddScreen = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(books) { book in
                    NavigationLink(value: book) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(book.title)
                                    .font(.headline)

                                Text(book.author)
                                    .foregroundStyle(.secondary)
                            }

                            Spacer()
                        }
                    }
                }
                .onDelete(perform: deleteBooks)
            }
            .navigationBarTitle("Bookworm")
            .navigationDestination(for: Book.self) { book in
                //                BookDetailView(book: book)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add book", systemImage: "plus") {
                        showAddScreen.toggle()
                    }
                }

                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }
            }
            .sheet(isPresented: $showAddScreen) {
                //                AddBookView()
            }

            Text("Last modified: \(lastModified, format: .dateTime)")
                .font(.caption2)
                .foregroundStyle(.secondary)
                .onReceive(didSavePublisher) { _ in
                    lastModified = Date.now
                }
        }
    }

    private func deleteBooks(offsets: IndexSet) {
        for offset in offsets {
            let book = books[offset]
            modelContext.delete(book)
        }
    }
}

// MARK: - Dynamically

struct DynamicallyFilteringAndSortingContentView: View {

    @State private var showingUpcomingOnly = false
    @State private var sortOrder = [
        SortDescriptor(\Book.title),
        SortDescriptor(\Book.date),
    ]

    var body: some View {
        NavigationStack {
            BooksView(
                minimumDate:
                    showingUpcomingOnly ? .now : .distantPast,
                sortOrder: sortOrder
            )
            .navigationTitle("Books")
            .toolbar {
                Button(showingUpcomingOnly ? "Show Everyone" : "Show Upcoming") {
                    showingUpcomingOnly.toggle()
                }

                Menu("Sort", systemImage: "arrow.up.arrow.down") {
                    Picker("Sort", selection: $sortOrder) {
                        Text("Sort by Name")
                            .tag([
                                SortDescriptor(\Book.title),
                                SortDescriptor(\Book.date),
                            ])
                        
                        Text("Sort by Join Date")
                            .tag([
                                SortDescriptor(\Book.date),
                                SortDescriptor(\Book.title)
                            ])
                    }
                }
            }
        }
    }
}

struct BooksView: View {

    @Query var books: [Book]

    var body: some View {
        List(books) { book in
            Text(book.title)
        }
    }

    init(
        minimumDate: Date,
        sortOrder: [SortDescriptor<Book>]
    ) {
        _books = Query(
            filter: #Predicate<Book> { book in
                book.date >= minimumDate
            },
            sort: sortOrder
        )
    }
}

// MARK: - Relationship

struct RelationshipContentView: View {

    @Environment(\.modelContext) var modelContext
    @Query var users: [SwiftDataUser]

    var body: some View {
        NavigationStack {
            List(users) { user in
                HStack {
                    Text(user.name)
                    
                    Spacer()
                    
                    Text(String(user.jobs.count))
                        .fontWeight(.black)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(.blue)
                        .foregroundStyle(.white)
                        .clipShape(.capsule)
                }
            }
            .toolbar {
                Button("Add sample") {
                    addSample()
                }
            }
        }
    }

    private func addSample() {
        let user1 = SwiftDataUser(name: "Piper Chapman", city: "New York", joinDate: .now)
        let job1 = Job(name: "Organize sock drawer", priority: 3)
        let job2 = Job(name: "Make plans with Alex", priority: 4)

        modelContext.insert(user1)

        user1.jobs.append(job1)
        user1.jobs.append(job2)
    }
}


// MARK: - Previews

#Preview {
    let previewDataProvider = PreviewDataProvider()
    if let error = previewDataProvider.error {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }

    return SwiftDataView()
        .modelContainer(previewDataProvider.container)
}

#Preview("Dynamically") {
    let previewDataProvider = PreviewDataProvider()
    if let error = previewDataProvider.error {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }

    return DynamicallyFilteringAndSortingContentView()
        .modelContainer(previewDataProvider.container)
}

#Preview("Relationship") {
    RelationshipContentView()
        .modelContainer(for: SwiftDataUser.self)
}


// MARK: - PreviewDataProvider

@MainActor
struct PreviewDataProvider {

    let container: ModelContainer!
    let demoBook: Book!
    let error: Error?

    init() {
        do {
            let config = ModelConfiguration(isStoredInMemoryOnly: true)
            let container = try ModelContainer(for: Book.self, configurations: config)

            try container.mainContext.delete(model: Book.self)

            self.demoBook = Book(title: "Test Book", author: "Test Author", genre: .fantasy, review: "This was a great book; I really enjoyed it.", rating: 4, date: .now)
            container.mainContext.insert(demoBook)

            self.container = container
            self.error = nil

            addMoreBooks()
        } catch {
            self.container = nil
            self.demoBook = nil
            self.error = error
        }
    }

    private func addMoreBooks() {
        let first = Book(title: "Test Book 1", author: "Test Author 1", genre: .horror, review: "This was a great book; I really enjoyed it 1.", rating: 1, date: .now)

        container.mainContext.insert(first)

        let second = Book(title: "Test Book 2", author: "Test Author 2", genre: .horror, review: "This was a great book; I really enjoyed it 2.", rating: 2, date: .now.addingTimeInterval(86400 * -10))

        container.mainContext.insert(second)

        let third = Book(title: "Test Book 3", author: "Test Author 3", genre: .horror, review: "This was a great book; I really enjoyed it 3.", rating: 3, date: .now.addingTimeInterval(86400 * 10))

        container.mainContext.insert(third)

        let fourth = Book(title: "Test Book 4", author: "Test Author 4", genre: .horror, review: "This was a great book; I really enjoyed it 4.", rating: 2, date: .now.addingTimeInterval(86400 * -5))

        container.mainContext.insert(fourth)

        let fifth = Book(title: "Test Book 5", author: "Test Author 5", genre: .horror, review: "This was a great book; I really enjoyed it 5.", rating: 5, date: .now.addingTimeInterval(86400 * 5))

        container.mainContext.insert(fifth)

        let xBook = Book(title: "Test Book X", author: "Test Author 6", genre: .horror, review: "This was a great book; I really enjoyed it 6.", rating: 5, date: .now.addingTimeInterval(86400 * 5))

        container.mainContext.insert(xBook)
    }
}
