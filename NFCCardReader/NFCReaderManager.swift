//
//  NFCReaderManager.swift
//  NFCCardReader
//
//  Created by Kobiraj on 2024-09-12.
//

import Foundation
import CoreNFC

class NFCReaderManager: NSObject, ObservableObject, NFCNDEFReaderSessionDelegate {
    var session: NFCNDEFReaderSession?
    var completion: ((String?) -> Void)?
    var cantScan: Bool = false
    
    func beginScanning(completion: @escaping (String?) -> Void) {
        guard NFCNDEFReaderSession.readingAvailable else {
            self.cantScan = true
            return
        }
        
        self.completion = completion
        session = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: true)
        session?.alertMessage = "Hold your iPhone near an NFC tag to scan."
        session?.begin()
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        for message in messages {
            for record in message.records {
                let data = String(data: record.payload, encoding: .utf8)
                print("NFC Tag Detected: \(data ?? "no data")")
                DispatchQueue.main.async {[weak self] in
                    self?.completion?(data)
                    session.invalidate()
                }
            }
        }
    }
    
    func readerSessionDidBecomeActive(_ session: NFCNDEFReaderSession) {
        print(session.alertMessage)
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        let nsError = error as NSError
        let errorCode = nsError.code
        
        switch errorCode {
        case NFCReaderError.readerErrorSecurityViolation.rawValue:
            print("Error: \(error.localizedDescription)")
            completion?("Error: \(error.localizedDescription)")
        case NFCReaderError.readerSessionInvalidationErrorFirstNDEFTagRead.rawValue:
            print("Error: \(error.localizedDescription)")
        case NFCReaderError.readerSessionInvalidationErrorSessionTerminatedUnexpectedly.rawValue:
            print("Error: \(error.localizedDescription)")
            completion?("Error: \(error.localizedDescription)")
        case NFCReaderError.readerSessionInvalidationErrorSessionTimeout.rawValue:
            print("Error: \(error.localizedDescription)")
            completion?("Error: \(error.localizedDescription)")
        case NFCReaderError.readerSessionInvalidationErrorUserCanceled.rawValue:
            print("Error: \(error.localizedDescription)")
        case NFCReaderError.readerTransceiveErrorSessionInvalidated.rawValue:
            print("Error: \(error.localizedDescription)")
        case NFCReaderError.readerTransceiveErrorTagResponseError.rawValue:
            print("Error: \(error.localizedDescription)")
            completion?("Error: \(error.localizedDescription)")
        case NFCReaderError.readerTransceiveErrorTagNotConnected.rawValue:
            print("Error: \(error.localizedDescription)")
            completion?("Error: \(error.localizedDescription)")
        case NFCReaderError.readerTransceiveErrorRetryExceeded.rawValue:
            print("Error: \(error.localizedDescription)")
            completion?("Error: \(error.localizedDescription)")
        default:
            completion?(nil)
        }
    }
    
    func invalidateSession() {
        session?.invalidate()
    }
}
