//
//  ServiceManager.swift
//  SSLPinning
//
//  Created by Gokberk Ozcan on 15.10.2021.
//

import Foundation
class ServiceManager : NSObject{
    
    static let shared : ServiceManager = ServiceManager()
    
    func callAPI(withUrl urlRequest: URLRequest, completion: @escaping    (String) -> Void){
        let session = URLSession(configuration: .ephemeral, delegate: self, delegateQueue: nil)
        var responseMessage = ""
        
        let task = session.dataTask(with: urlRequest) { (data,response,error) in
            if error != nil{
                print("error:\(error!.localizedDescription): \(error!)")
                      responseMessage = "Pinning failed."
                      }else if data != nil{
                    
                    let str = String(decoding: data!, as: UTF8.self)
                    print("Received data:\n\(str)")
                    responseMessage = "Public key pinning is successfully completed"
                }
                      
                      DispatchQueue.main.async {
                    completion(responseMessage)
                }
                      
                      }
                      task.resume()
                      }
            }
                      
extension ServiceManager : URLSessionDelegate{
                    
                    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge,completionHandler: @escaping
                    (URLSession.AuthChallengeDisposition,URLCredential?) -> Void) {
                        guard let serverTrust = challenge.protectionSpace.serverTrust else {
                        completionHandler(.cancelAuthenticationChallenge, nil);
                        return
                        }
                    
                        let certificate = SecTrustGetCertificateAtIndex(serverTrust, 0)
                        
                        //SSL Policies for domain name check.
                        let policy = NSMutableArray()
                        policy.add(SecPolicyCreateSSL(true, challenge.protectionSpace.host as CFString))
                        
                        //evelaute server sertificate
                        let isServerTrusted = SecTrustEvaluateWithError(serverTrust, nil)
                       
                        let remoteCertificateData: NSData = SecCertificateCopyData(certificate!)
                        
                        let pathToCertificate = Bundle.main.path(forResource: "divvydrive", ofType: "cer")
                        
                        let localCertificateData:NSData = NSData(contentsOfFile: pathToCertificate!)!
                        //compare certification
                        if(isServerTrusted && remoteCertificateData.isEqual(to: localCertificateData as Data)){
                            let _: URLCredential = URLCredential(trust: serverTrust)
                            print("Certificate pinning is succesfully completed.")
                           
                            completionHandler(.useCredential,nil)
                        }
                        else{
                            DispatchQueue.main.async {
                                print("Pinning Failed.")
                            }
                            completionHandler(.cancelAuthenticationChallenge,nil)
                        }
    
                }
    }
