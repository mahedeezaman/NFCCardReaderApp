//
//  NFCWriterManager.swift
//  NFCCardReader
//
//  Created by Kobiraj on 2024-10-03.
//

import Foundation
import CoreNFC

class NFCWriterManager: NSObject, ObservableObject, NFCNDEFReaderSessionDelegate {
    @Published var textToWrite = ""
    @Published var cantScan: Bool = false
    var session: NFCNDEFReaderSession?
    
    func beginWriting() {
        guard NFCNDEFReaderSession.readingAvailable else {
            self.cantScan = true
            return
        }
        
        session = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: false)
        session?.alertMessage = "Hold your iPhone near an NFC tag to write data"
        session?.begin()
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetect tags: [NFCNDEFTag]) {
        guard tags.count == 1, let currentTag = tags.first else {
            session.invalidate(errorMessage: "Cannot Write More Than One Tag in NFC")
            return
        }
        
        session.connect(to: currentTag) { error in
            guard error == nil else {
                session.invalidate(errorMessage: "Could not connect to NFC card")
                return
            }
            
            currentTag.queryNDEFStatus { status, _, error in
                guard error == nil else {
                    session.invalidate(errorMessage: "Write error")
                    return
                }
                
                switch status {
                case .readWrite:
                    let textPayload = NFCNDEFPayload.wellKnownTypeTextPayload(string: self.textToWrite, locale: Locale(identifier: "en"))!
                    let message = NFCNDEFMessage(records: [textPayload])
                    
                    currentTag.writeNDEF(message) { error in
                        if error != nil {
                            session.invalidate(errorMessage: "Failed to write NFC tag")
                        } else {
                            session.alertMessage = "Successfully written"
                            session.invalidate()
                        }
                    }
                    
                case .notSupported:
                    session.invalidate(errorMessage: "Tag not supported")
                    
                case .readOnly:
                    session.invalidate(errorMessage: "Tag is read-only")
                    
                @unknown default:
                    session.invalidate(errorMessage: "Unknown error")
                }
            }
        }
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        print("Session ended with error: \(error.localizedDescription)")
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        for message in messages {
            for record in message.records {
                let data = String(data: record.payload, encoding: .utf8)
                print("NFC Tag Detected: \(data ?? "no data")")
            }
        }
    }
    
    func invalidateSession() {
        session?.invalidate()
    }
}
