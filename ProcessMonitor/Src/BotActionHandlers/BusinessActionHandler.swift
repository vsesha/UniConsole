//
//  ActionHandlerProcessStatus.swift
//  ProcessMonitor
//
//  Created by Vasudevan Seshadri on 1/17/18.
//  Copyright © 2018 Vasudevan Seshadri. All rights reserved.
//

import Foundation
import ApiAI

class BusinessActionHandler {
    
    func getCounterpartyExposure (Params: [String: AIResponseParameter]){
        print("Inside getCounterpartyExposure")
        
        var responseString = ""
        let counterpartyName = stripOffUnwantedCharaters(dirtyString: (Params["COUNTERPARTIES"]?.stringValue)!)
        
        print("counterpartyName = \(counterpartyName) ")
        
        let urlStr = "https://1kzs148uhc.execute-api.us-east-2.amazonaws.com/prod/CounterpartyExecution_Lambda"
        
        
        let querycounterparty    = URLQueryItem(name: "QUERY_COUNTERPARTY",   value: counterpartyName)
       
        
        let paramsArray = [querycounterparty]
        
        let awsCommObj = AWSCommunicator()
        awsCommObj.invokeMicroService(endpointURL: urlStr, queryParams: paramsArray,
                                      method: "GET",
                                      AwsMicroServiceResponseHandler:"getCounterpartyExposure")
        
        
    }
    
    func getTopCounterpartyExposure(Params: [String: AIResponseParameter]){
        print ("Inside getTopCounterpartyExposure")
        
        let TopNumberOfCounterparties = stripOffUnwantedCharaters(dirtyString: (Params["TOP_N"]?.stringValue)!)
        
        print("TopNumberOfCounterparties = \(TopNumberOfCounterparties) ")
        
        let urlStr = "https://1kzs148uhc.execute-api.us-east-2.amazonaws.com/prod/TOP_COUNTERPARTY_EXPOSURE"
        
        
        let querycounterparty    = URLQueryItem(name: "QUERY_TOP_N",   value: TopNumberOfCounterparties)
        
        
        let paramsArray = [querycounterparty]
        
        let awsCommObj = AWSCommunicator()
        awsCommObj.invokeMicroService(endpointURL: urlStr, queryParams: paramsArray,
                                      method: "GET",
                                      AwsMicroServiceResponseHandler:"getTopCounterpartyExposure")
        
    }
}




