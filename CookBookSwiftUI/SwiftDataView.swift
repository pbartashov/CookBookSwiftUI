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
    @Query(sort: [
        SortDescriptor(\Book.title),
        SortDescriptor(\Book.author)
    ]) private var books: [Book]

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
        }
    }

    private func deleteBooks(offsets: IndexSet) {
        for offset in offsets {
            let book = books[offset]
            modelContext.delete(book)
        }
    }
}

#Preview {
    let previewDataProvider = PreviewDataProvider()
    if let error = previewDataProvider.error {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }

    return SwiftDataView()
        .modelContainer(previewDataProvider.container)
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
            container = try ModelContainer(for: Book.self, configurations: config)
            demoBook = Book(title: "Test Book", author: "Test Author", genre: .fantasy, review: "This was a great book; I really enjoyed it.", rating: 4, date: .now)
            container.mainContext.insert(demoBook)

            error = nil
        } catch {
            container = nil
            demoBook = nil
            self.error = error
        }
    }
}
