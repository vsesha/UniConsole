//
//  AWSMicroServiceCommunication.swift
//  ProcessMonitor
//
//  Created by Vasudevan Seshadri on 2/5/18.
//  Copyright © 2018 Vasudevan Seshadri. All rights reserved.
//

import Foundation

class AWSCommunicator {
    
    func invokeMicroService(endpointURL:String, queryParams:[URLQueryItem], method:String, AwsMicroServiceResponseHandler: String) {
        let config         = URLSessionConfiguration.default       // Session Configuration
        let session        = URLSession(configuration: config)     // Load configuration into Session
        //let url            = URL(string: endpointURL)!
        
        var errStr         = ""
        var responseStr    = ""
        
        var urlComponent            = URLComponents( string: endpointURL)
        urlComponent?.queryItems    = queryParams
        
        var request                 = URLRequest(url: (urlComponent?.url)!)
        request.httpMethod          = method
        
        
         GLOBAL_notifyToViews(notificationMsg: "0.6", notificationType: NotificationTypes.PROGRESS_BAR_UPDATE )
        
        let task = session.dataTask(with: request, completionHandler: {
            (data, response, error) in
            
            if error != nil {
                print(error!.localizedDescription)
                errStr = error!.localizedDescription
            } else
                {
                    do {
                        let resposneObj = response as! HTTPURLResponse
                        
                        if(resposneObj.statusCode != 200) {
                            errStr = "Error while executing Microservice or Lambda"
                        }
                        else if let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]
                        {
//                            print(jsonResponse["PROCESS_NAME"])
  //                          responseStr = jsonResponse["PROCESS_NAME"] as! String
                             GLOBAL_notifyToViews(notificationMsg: "0.8", notificationType: NotificationTypes.PROGRESS_BAR_UPDATE )
                            
                            self.delegateResponse(responseFromMicroService: jsonResponse, AwsMicroServiceResponseHandler: AwsMicroServiceResponseHandler)
                        }
                    } catch {
                        print("error in JSONSerialization")
                    }
                }
            })
            task.resume()
    }
    
    func delegateResponse(responseFromMicroService : [String:Any], AwsMicroServiceResponseHandler: String){
        //let awsResponseHndlrObj = AWSResponseHandler()
        print("inside delegateResponse")
        switch (AwsMicroServiceResponseHandler) {
            
            case "getProcessOnBox":
                print("case getProcessOnBox")
               awsResponseHndlrObj.getProcessOnBox(AWSResponse: responseFromMicroService)
            break
            
            case "getProcessStatusAndScheduleDetails":
                awsResponseHndlrObj.getProcessStatusAndScheduleDetails(AWSResponse: responseFromMicroService)
            break
            
            case "getBoxCpuAndMemUsage":
                awsResponseHndlrObj.getBoxCpuAndMemUsage(AWSResponse: responseFromMicroService)
            break
            
            case "getBoxCpuAndMemUsage":
                awsResponseHndlrObj.getBoxCpuAndMemUsage(AWSResponse: responseFromMicroService)
            break
            
            case "getCounterpartyExposure":
            awsResponseHndlrObj.getCounterpartyExposure(AWSResponse: responseFromMicroService)
            break
            
            case "getTopCounterpartyExposure":
            awsResponseHndlrObj.getTopCounterpartyExposure(AWSResponse: responseFromMicroService)
            break
            
            case "getTopMemoryConsumptionProcess":
                awsResponseHndlrObj.getTopMemoryConsumptionProcess(AWSResponse: responseFromMicroService)
            break
            
        case "getAllRunningProcessOnHost":
            awsResponseHndlrObj.getAllRunningProcessOnHost (AWSResponse: responseFromMicroService)
            break
        
        default:
            print("Invalid case - No AWS Case handled for \(AwsMicroServiceResponseHandler)")
        }
    
    }
}
