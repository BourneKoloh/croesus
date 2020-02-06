//
//  ApiServiceImpl.swift
//  Croesus
//
//  Created by Bourne K on 05/02/2020.
//  Copyright © 2020 Triglobe Soft Solutions. All rights reserved.
//

import Foundation

class ApiServiceImpl:NSObject, ApiService {
    //Shared Instance
    fileprivate static var _inst:ApiService? = nil
    //
    private let dispatchQueue = DispatchQueue(label: "apiservice.queue.dispatcheueuq")
    
    static var Instance:ApiService{
        get{
            if _inst == nil {
                _inst = ApiServiceImpl()
            }
            return _inst!
        }
        set{}
    }
    
    fileprivate lazy var requestsSession: URLSession = {
        //
        let configuration = URLSessionConfiguration.default
        //
        return URLSession(configuration: configuration,
                        delegate: self,
                        delegateQueue: nil)
    }()
    
    // MARK: -
    func syncData(_ completion:@escaping(_ s:Bool, _ msg:String?)->Swift.Void){

        //Check Network Connection
        guard NetworkProps.connectivity.status != .unreachable else {
            //FAIL.
            completion(false,"Your NOT connected to the internet")
            return
        }
        //Check Network Intermitance.. WiFi should be connected
        guard NetworkProps.connectivity.isReachableViaWiFi else {
            //FAIL.
            completion(false,"WiFi Connection is Required to Update Profile")
            return
        }
        //Upload simulation..
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(2)) {
            //Dummy Static Data..
            completion(true,"Success")
        }
    }
    
    // MARK: -
    func buckupData(_ completion:@escaping(_ s:Bool, _ msg:String?)->Swift.Void){
        
        //Check Network Connection
        guard NetworkProps.connectivity.status != .unreachable else {
            //FAIL.
            completion(false,"Your NOT connected to the internet")
            return
        }
        //Check Network Intermitance.. WiFi should be connected
        guard NetworkProps.connectivity.isReachableViaWiFi else {
            //FAIL.
            completion(false,"WiFi Connection is Required to Update Profile")
            return
        }
        //Upload simulation..
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(2)) {
            //Dummy Static Data..
            
            completion(true,"Success")
        }
    }
    
    // MARK: -
    func submitSurvey(_ model:CompleteSurveyVM, _ completion:@escaping(_ s:Bool, _ msg:String?)->Swift.Void){
        //Check Network Connection
        guard NetworkProps.connectivity.status != .unreachable else {
            //FAIL.
            completion(false,"Your NOT connected to the internet")
            return
        }
        //Check Network Intermitance.. WiFi should be connected
        guard NetworkProps.connectivity.isReachableViaWiFi else {
            //FAIL.
            completion(false,"WiFi Connection is Required to Update Profile")
            return
        }
        //Upload simulation..
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(2)) {
            //Store to local DB
            if DataContext.Shared.storeSurvey(model.survey!) {
                //
                completion(true,"Success")
            }else{
                completion(true,"Operation Failed.")
            }
        }
    }
    
    // MARK: - Implement for loading loading surveys
    func fetchSurveys(_ completion: @escaping (_ s:Bool, _ list:[SurveyItem], _ msg: String?) -> Void) {
        //
        guard NetworkProps.connectivity.status != .unreachable else {
            //FAIL.
            completion(false,[SurveyItem](),"You are NOT connected to the internet.")
            return
        }
        //
        guard let url = URL(string: "\(Routes.HOST)/surveys") else {
            completion(false,[SurveyItem](),"Bad Service End-Point")
               return
        }
        //
        let rdata = SurveysRequest()
        //
        rdata.userId = "DEMO"
        //
        var request = self.composeRequest(url, "POST","XXXX-YYYY")
        //
        let body = String(data:try! JSONEncoder().encode(rdata),encoding: .utf8)!
        //
        request.httpBody = body.data(using: .utf8)
        //
        
        let task = self.requestsSession.dataTask(with: request) { data, response, error in
            // check for fundamental networking error
            guard let responseString = self.digestResponse(data, response, error) else {
                //
                completion(false, [SurveyItem](), "Service Error")
                return
            }
            //
            let decoder = JSONDecoder()
             //
             guard let rdata = responseString.data(using: .utf8), let payload = try? decoder.decode([SurveysResponse].self, from: rdata) else {
                 completion(false,[SurveyItem](), "Service Error")
                 return
             }
             
            //READ MORE SURVEY
            let list = [SurveyItem]()
            //
            for (g,h) in payload.enumerated() {
                
                let y = SurveyItem()
                y.id = g
                y.title = h.title
                y.desc = h.desc
                y.kind = h.status.lowercased() == "completed" ? .Completed : .Ongoing
                //
                if let qs = h.questions {
                    for (a,j) in qs.enumerated() {
                        let f = SurveyQuestion()
                        f.title = j.title
                        f.id = a
                        f.type = j.kind.lowercased() == "multiplechoice" ? .MultipleChoice : j.kind.lowercased() == "singlechoice" ? .SingleChoice : .Text
                        //
                        if let qa = j.answers {
                            for (i,l) in qa.enumerated() {
                                let ans = QuestionAnswer()
                                ans.value = l.value
                                ans.id = i
                                f.answers.append(ans)
                            }
                        }
                        //
                        if let qo = j.options {
                            for (s,l) in qo.enumerated() {
                                let c = QuestionChoice()
                                c.value = l.value
                                c.title = l.title
                                c.id = s
                                f.choices.append(c)
                            }
                        }
                        //
                        y.questions.append(f)
                    }
                }
            }
            //
            completion(true,list,"Success")
        }
        //
        task.resume()
    }
    
    //MARK: -
    func updateCustomerDetails(_ model:ProfileVM, _ completion:@escaping(_ s:Bool, _ msg:String?)->Swift.Void) {
        
        //Check Network Connection
        guard NetworkProps.connectivity.status != .unreachable else {
            //FAIL.
            completion(false,"Your NOT connected to the internet")
            return
        }
        //Check Network Intermitance.. WiFi should be connected
        guard NetworkProps.connectivity.isReachableViaWiFi else {
            //FAIL.
            completion(false,"WiFi Connection is Required to Update Profile")
            return
        }
        //Upload simulation..
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(2)) {
            //
            completion(true,"Success")
        }
    }
    
    //MARK: -
    func submitQuestion(_ model:QuestionVM, _ completion:@escaping(_ s:Bool, _ msg:String?)->Swift.Void){
        //Check Network Connection
        guard NetworkProps.connectivity.status != .unreachable else {
            //FAIL.
            completion(false,"Your NOT connected to the internet")
            return
        }
        //Check Network Intermitance.. WiFi should be connected
        guard NetworkProps.connectivity.isReachableViaWiFi else {
            //FAIL.
            completion(false,"WiFi Connection is Required to Update Profile")
            return
        }
        //Upload simulation..
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(2)) {
            //
            completion(true,"Success")
        }
    }
}

extension ApiServiceImpl: URLSessionDelegate{
    //MARK: Hook SSL Pinning Module
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Swift.Void) {
        // Let Your Pinning Library handle it when using SSL Pinning ..
        //TrustKit.sharedInstance().pinningValidator.handle(challenge, completionHandler: completionHandler)
        completionHandler(URLSession.AuthChallengeDisposition.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!))
    }
}

extension ApiServiceImpl{

    private func composeRequest(_ url:URL,_ method:String, _ token:String?) -> URLRequest {
        
        var r = URLRequest(url: url)
        
        r.httpMethod = "POST"
        r.addValue("application/json",forHTTPHeaderField: "Content-Type")
        r.addValue("application/json",forHTTPHeaderField: "Accept")
        //
        if let t = token {
          r.addValue("Bearer \(t)",forHTTPHeaderField: "Authorization")
        }
        
        return r
    }
    
    private func digestResponse(_ data:Data?, _ response:URLResponse?, _ error:Error?) -> String? {
        //
        guard let data = data, error == nil else {
            // check for fundamental networking error
            return nil
        }
        //
        if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
            // check for http errors
            let _ = String(data: data, encoding: String.Encoding.utf8)
            //AppUtils.Log("Resp Code = \(httpStatus.statusCode), \n Failure Response: \(String(describing: httpStatus))")
            //
            return nil
        }
        //
        return String(data: data, encoding: .utf8)
    }
}
