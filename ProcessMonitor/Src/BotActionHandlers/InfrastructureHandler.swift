//
//  ActionHandlerProcessStatus.swift
//  ProcessMonitor
//
//  Created by Vasudevan Seshadri on 1/17/18.
//  Copyright © 2018 Vasudevan Seshadri. All rights reserved.
//

import Foundation
import ApiAI

class InfrastructureActionHandler {
    

    
    func getTopMemoryConsumptionProcess(Params: [String: AIResponseParameter]){
        print ("Inside getTopMemoryConsumptionProcess")
        
        let TopNumberOfMemoryProcess = stripOffUnwantedCharaters(dirtyString: (Params["TOP_N"]?.stringValue)!)
        
        print("TopNumberOfProcess= \(TopNumberOfMemoryProcess) ")
        
        let urlStr = "https://1kzs148uhc.execute-api.us-east-2.amazonaws.com/prod/TOP_MEMORY_CONSUMERS"
        
        
        let querytopmemory    = URLQueryItem(name: "QUERY_TOP_N",
                                                value: TopNumberOfMemoryProcess)
        
        
        let paramsArray = [querytopmemory]
        
        let awsCommObj = AWSCommunicator()
        awsCommObj.invokeMicroService(endpointURL: urlStr, queryParams: paramsArray,
                                      method: "GET",
                            AwsMicroServiceResponseHandler:"getTopMemoryConsumptionProcess")
        
    }
    
    func getAllRunningProcessOnHost(Params: [String: AIResponseParameter]){
        print ("Inside getAllRunningProcessOnHost")
        
        let hostName = stripOffUnwantedCharaters(dirtyString: (Params["Box"]?.stringValue)!)
        print("On Host= \(hostName) ")
    
        let urlStr = "https://1kzs148uhc.execute-api.us-east-2.amazonaws.com/prod/GET_ALLRUNNINGPROCESS_ONHOST"
        
        
        let queryHostName    = URLQueryItem(name: "QUERY_HOST_NAME",
                                             value: hostName)
        
        
        let paramsArray = [queryHostName]
        
        let awsCommObj = AWSCommunicator()
        awsCommObj.invokeMicroService(endpointURL: urlStr, queryParams: paramsArray,
                                      method: "GET",
                                      AwsMicroServiceResponseHandler:"getAllRunningProcessOnHost")
        
    
    }
}





