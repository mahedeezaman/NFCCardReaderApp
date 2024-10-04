//
//  WriterView.swift
//  NFCCardReader
//
//  Created by Kobiraj on 2024-10-03.
//

import SwiftUI

struct WriterView: View {
    @State private var writeText = ""
    @FocusState private var focus: Bool
    var body: some View {
        VStack {
            TextEditor(text: $writeText)
                .autocapitalization(.words)
                .disableAutocorrection(true)
                .border(.blue, width: 2)
                .padding()
                .focused($focus)
                .toolbar {
                    ToolbarItem(placement: .keyboard) {
                        Button("Done Typing") {
                            focus = false
                        }
                    }
                }
            
            Button {
                //
            } label: {
                Text("Write")
                    .padding()
                    .padding(.horizontal, 10)
                    .background(Color.blue)
                    .foregroundStyle(Color.white)
                    .cornerRadius(10)
            }
        }
        .padding()
    }
}

#Preview {
    WriterView()
}
