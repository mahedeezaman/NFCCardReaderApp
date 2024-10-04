//
//  WriterView.swift
//  NFCCardReader
//
//  Created by Kobiraj on 2024-10-03.
//

import SwiftUI

struct WriterView: View {
    @FocusState private var focus: Bool
    @StateObject private var nfcWriter = NFCWriterManager()
    var body: some View {
        VStack {
            TextEditor(text: $nfcWriter.textToWrite)
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
                nfcWriter.beginWriting()
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
        .alert(isPresented: $nfcWriter.cantScan) {
            Alert(
                title: Text(
                    "Scanning Failed"
                ),
                message: Text(
                    "This device doesn't support tag scanning."
                ),
                dismissButton: .default(Text("Cancel"), action: {
                    nfcWriter.cantScan = false
                    nfcWriter.invalidateSession()
                })
            )
        }
    }
}

#Preview {
    WriterView()
}
