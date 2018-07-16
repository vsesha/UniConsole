//
//  BoxHealthCpuAndMemoryHandler.swift
//  ProcessMonitor
//
//  Created by Vasudevan Seshadri on 2/9/18.
//  Copyright © 2018 Vasudevan Seshadri. All rights reserved.
//

import Foundation
//
//  ActionHandlerProcessStatus.swift
//  ProcessMonitor
//
//  Created by Vasudevan Seshadri on 1/17/18.
//  Copyright © 2018 Vasudevan Seshadri. All rights reserved.
//

import Foundation
import ApiAI

class BoxHealthCpuAndMemoryHandler {
    
    func getBoxCpuAndMemUsage (Params: [String: AIResponseParameter]){


        print("Inside getBoxCpuAndMemUsage")
        
        var responseString = ""
        let BoxName = stripOffUnwantedCharaters(dirtyString: (Params["Box"]?.stringValue)!)

        
        
        print("BoxName = \(BoxName) ")
        
        let urlStr = "https://1kzs148uhc.execute-api.us-east-2.amazonaws.com/prod/BoxHealth_Lambda"
        
        
        let queryBox    = URLQueryItem(name: "QUERY_BOX",   value: BoxName)

        
        let paramsArray = [queryBox]
        print("calling BoxHealthMS")
        let awsCommObj = AWSCommunicator()
        awsCommObj.invokeMicroService(endpointURL: urlStr, queryParams: paramsArray,
                                      method: "GET",
                                      AwsMicroServiceResponseHandler:"getBoxCpuAndMemUsage")
        
        
    }
 
}



