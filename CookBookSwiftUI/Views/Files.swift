//
//  Files.swift
//  CookBookSwiftUI
//
//  Created by Pavel Bartashov on 11/10/2024.
//

import SwiftUI

struct FilesContentView: View {

    @State private var input = ""
    @State private var fileContent = ""
    @State private var error: Error?

    let fileName = "message.txt"

    var body: some View {
        Form {
            Section("Write") {
                TextField("Enter text", text: $input)

                Button("Write") {
                    let data = Data(input.utf8)
                    let url = URL.documentsDirectory.appending(path: fileName)

                    do {
                        try data.write(to: url, options: [.atomic, .completeFileProtection])
                    } catch {
                        self.error = error
                    }
                }
            }
            
            Section("Read") {
                Button("Read") {
                    let url = URL.documentsDirectory.appending(path: fileName)

                    do {
                        fileContent = try String(contentsOf: url, encoding: .utf8)
                    } catch {
                        print(error.localizedDescription)
                    }
                }

                Text(fileContent)
            }

            if let error {
                Section("Error") {
                    Text(error.localizedDescription)
                }
            }
        }
    }
}

#Preview {
    FilesContentView()
}
