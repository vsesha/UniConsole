//
//  ActionHandlerProcessStatus.swift
//  ProcessMonitor
//
//  Created by Vasudevan Seshadri on 1/17/18.
//  Copyright © 2018 Vasudevan Seshadri. All rights reserved.
//

import Foundation
import ApiAI

class ProcessHandler {
    
    func getProcessOnBox (Params: [String: AIResponseParameter]){
        print("Inside getProcessStatus")
        
        var responseString = ""
        let processName = stripOffUnwantedCharaters(dirtyString: (Params["PROCESS_NAME"]?.stringValue)!)
        var environment = stripOffUnwantedCharaters(dirtyString: (Params["Environment"]?.stringValue)!)
        let runSchedule = stripOffUnwantedCharaters(dirtyString: (Params["RUN_SCHEDULE"]?.stringValue)!)
        
        
        print("processName = \(processName) - environment = \(environment) - runSchedule = \(runSchedule)")
       
        let urlStr = "https://1kzs148uhc.execute-api.us-east-2.amazonaws.com/prod/ProcessOnBox_Lambda"
 
        
        let queryprocess    = URLQueryItem(name: "QUERY_PROCESS",   value: processName)
        let queryEnv        = URLQueryItem(name: "QUERY_ENV",       value: environment)
        let querySchedule   = URLQueryItem(name: "QUERY_SCHEDULE",  value: runSchedule)
        
        let paramsArray = [queryprocess, queryEnv, querySchedule]
        
        let awsCommObj = AWSCommunicator()
        awsCommObj.invokeMicroService(endpointURL: urlStr, queryParams: paramsArray,
                                      method: "GET",
                                      AwsMicroServiceResponseHandler:"getProcessOnBox")
        
       
    }
    
    func getProcessStatusAndScheduleDetails(Params: [String: AIResponseParameter]){
        print ("Inside getProcessDetails")
        
        var responseString = ""
        let processName = stripOffUnwantedCharaters(dirtyString: (Params["PROCESS_NAME"]?.stringValue)!)


        
        
        print("processName = \(processName)")
        
        let urlStr = "https://1kzs148uhc.execute-api.us-east-2.amazonaws.com/prod/ProcessOnBox_Lambda"
        
        
        let queryprocess    = URLQueryItem(name: "QUERY_PROCESS", value: processName)
        let queryEnv        = URLQueryItem(name: "QUERY_ENV", value: "")
        let querySchedule   = URLQueryItem(name: "QUERY_SCHEDULE", value: "")
        
        let paramsArray = [queryprocess, queryEnv, querySchedule]
        
        let awsCommObj = AWSCommunicator()
        awsCommObj.invokeMicroService(endpointURL: urlStr, queryParams: paramsArray,
                                      method: "GET",
                                      AwsMicroServiceResponseHandler:"getProcessStatusAndScheduleDetails")
        
    }
}



