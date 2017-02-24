//
//  NetworkingSpec.swift
//  Clutch
//
//  Created by Juha Salo on 23/05/15.
//  Copyright (c) 2015 Solinor Oy. All rights reserved.
//

import Foundation
import Quick
import Nimble
import Clutch
import Alamofire

class NetworkingSpec: QuickSpec {
    override func spec() {
        
        var networking = SPHNetworking(merchantId: "test_merchantId", accountId: "test", hostname: "http://127.0.0.1:9000")
        
        let MobileBackendAddress = "http://127.0.0.1:8081"
        
        describe("transactionId") {
            it("we should get ID"){
                var receivedMessage = ""
                
                networking.transactionId(success: {(message) in receivedMessage = message}, failure: {(error) in print("error \(error)")})
            
                expect(receivedMessage).toEventually(contain("-"), timeout: 3)
            }
            
        }

        describe("getKey") {
            it("we should get key"){
                var transactionId = ""
                var receivedKey = ""
                
                networking.transactionId(success: {(message) in transactionId = message}, failure: {(error) in print("error \(error)")})
                
                expect(transactionId).toEventually(contain("-"), timeout: 3)
                
                networking.transactionKey(transactionId: transactionId, success: {(message) in receivedKey = message}, failure: {(error) in print("error \(error)")})
                
                expect(receivedKey).toEventually(contain("MII"), timeout: 3)
            }
        }
        
        describe("tokenize") {
            it("we should be able to tokenize card"){
                var transactionId = ""
                var receivedKey = ""
                var receivedResponse = "not empty"
                
                networking.transactionId(success: {(message) in transactionId = message}, failure: {(error) in print("error \(error)")})
                
                expect(transactionId).toEventually(contain("-"), timeout: 3)
                
                networking.transactionKey(transactionId: transactionId, success: {(message) in receivedKey = message}, failure: {(error) in print("error \(error)")})
                
                expect(receivedKey).toEventually(contain("MII"), timeout: 3)
                
                networking.tokenizeTransaction(transactionId: transactionId, expiryMonth: "11", expiryYear: "2017", cvc: "024", pan: "4153013999700024", certificateBase64Der: receivedKey, success: {(message) in receivedResponse = message}, failure: {(error) in print("error \(error)")})

                expect(receivedResponse).toEventually(contain(networking.tokenisationSuccessResultString), timeout: 5)

            }
        }
        
        describe("helperGetToken") {
            it("we should be able to get token"){
                var transactionId = ""
                var receivedKey = ""
                var receivedResponse = ""
                var receivedToken = ""
                
                networking.transactionId(success: {(message) in transactionId = message}, failure: {(error) in print("error \(error)")})
                expect(transactionId).toEventually(contain("-"), timeout: 3)
                
                networking.transactionKey(transactionId: transactionId, success: {(message) in receivedKey = message}, failure: {(error) in print("error \(error)")})
                expect(receivedKey).toEventually(contain("MII"), timeout: 3)
                
                networking.tokenizeTransaction(transactionId: transactionId, expiryMonth: "11", expiryYear: "2017", cvc: "024", pan: "4153013999700024", certificateBase64Der: receivedKey, success: {(message) in receivedResponse = message}, failure: {(error) in print("error \(error)")})
                expect(receivedResponse).toEventually(contain(networking.tokenisationSuccessResultString), timeout: 5)
                
                networking.transactionToken(transactionId: transactionId, success: {(message) in receivedToken = message}, failure: {(error) in print("error \(error)")})
                expect(receivedToken).toEventually(contain("-"), timeout: 5)
            }
        }
    }
}
