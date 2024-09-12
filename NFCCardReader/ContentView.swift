//
//  ContentView.swift
//  NFCCardReader
//
//  Created by Kobiraj on 08/09/2024.
//

import SwiftUI
import CoreNFC

struct ContentView: View {
    @StateObject private var nfcReader = NFCReader()
    @State private var nfcMessage: String = "Tap to Scan NFC"
    @State private var isScanning: Bool = false

    var body: some View {
        GeometryReader { gr in
            VStack {
                Text(nfcMessage)
                    .padding()

                Button("Start NFC Scan") {
                    nfcReader.beginScanning { message in
                        if let message = message {
                            nfcMessage = message
                        } else {
                            nfcMessage = "No NFC tags found"
                        }
                    }
                }
                .padding()
                .background(Color.blue)
                .cornerRadius(10)
            }
            .frame(width: gr.size.width, height: gr.size.height, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            .background(Color.black)
            .foregroundColor(.white)
        }
        .alert(isPresented: $isScanning) {
            Alert(title: Text("Scanning..."), message: Text("Hold your iPhone near an NFC tag"), dismissButton: .default(Text("Cancel"), action: {
                nfcReader.invalidateSession()
            }))
        }
    }
}

#Preview {
    ContentView()
}
