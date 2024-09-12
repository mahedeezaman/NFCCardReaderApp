//
//  NFCReaderManager.swift
//  NFCCardReader
//
//  Created by Kobiraj on 2024-09-12.
//

import Foundation
import CoreNFC

class NFCReader: NSObject, ObservableObject, NFCNDEFReaderSessionDelegate {
    var session: NFCNDEFReaderSession?
    var completion: ((String?) -> Void)?
    
    func beginScanning(completion: @escaping (String?) -> Void) {
        self.completion = completion
        session = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: true)
        session?.alertMessage = "Hold your iPhone near an NFC tag to scan."
        session?.begin()
    }
    
    // Called when an NFC tag is successfully read
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        guard let message = messages.first, let record = message.records.first else {
            completion?(nil)
            return
        }
        
        if let payloadString = String(data: record.payload, encoding: .utf8) {
            completion?(payloadString)
        } else {
            completion?("Unable to decode NFC message")
        }
    }
    
    // Called when the NFC session becomes invalid (error, timeout, etc.)
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        completion?(nil)
    }
    
    func invalidateSession() {
        session?.invalidate()
    }
}
