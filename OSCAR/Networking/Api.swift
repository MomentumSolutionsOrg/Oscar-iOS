//
//  Api.swift
//  OSCAR
//
//  Created by Mostafa Samir on 9/9/20.
//  Copyright © 2020 Safaa Mohamed. All rights reserved.
//

import Foundation
import Alamofire
import PromiseKit


typealias Completion = (MyError?)->Void

class Api {
    
    func fireRequestWithSingleResponse<T: Codable>(urlConvertible: Requestable, mappingClass: T.Type) -> Promise<T>{
        
        return Promise<T> {[weak self] seal in
            guard let self = self else {return}
            // Trigger the HTTPRequest using Alamofire
            if NetworkMonitor.shared.netOn {
                AF.request(urlConvertible).responseJSON { response in
                    self.handleResponse(response: response, mappingClass: mappingClass).done({ successData in
                        seal.fulfill(successData)
                    }).catch({ error in
                        print(error)
                        seal.reject(error)
                    })
                }
            } else {
                seal.reject(MyError.noInternet)
            }
        }
    }
    
    func fireMultipartRequest<T: Codable>(urlConvertible: Requestable, mappingClass: T.Type)-> Promise<T> {
        return Promise<T> {[weak self] seal in
            guard let self = self,
                  let multipart = urlConvertible.multipart else {
                seal.reject(MyError.unknown)
                return
            }
            if NetworkMonitor.shared.netOn {
                AF.upload(multipartFormData: multipart, with: urlConvertible).responseJSON {response in
                    self.handleResponse(response: response, mappingClass: mappingClass).done({ successData in
                        seal.fulfill(successData)
                    }).catch({ error in
                        seal.reject(error)
                    })
                }
            } else {
                seal.reject(MyError.noInternet)
            }
        }
    }
    
    static func cancelRequests() {
        Alamofire.Session.default.session.getTasksWithCompletionHandler { dataTasks, uploadTasks, downloadTasks in dataTasks.forEach { $0.cancel() }
            uploadTasks.forEach { $0.cancel() }
            downloadTasks.forEach { $0.cancel() }
        }
    }
    
    private func handleResponse<T: Codable>(response: AFDataResponse<Any>, mappingClass: T.Type) -> Promise<T> {
        return Promise<T> { seal in
            switch response.result {
            case .success:
                
                if (200...300).contains(response.response?.statusCode ?? 0) {
                    do {
                        guard let jsonResponse = response.data else {
                            seal.reject(MyError.unknown)
                            return
                        }
                        let responseObj = try JSONDecoder().decode(T.self, from: jsonResponse)
                        seal.fulfill(responseObj)
                    }catch {
                        print(error.localizedDescription)
                        seal.reject(error)
                    }
                } else {
                    seal.reject(parseErrorData(response: response))
                }
                
            case .failure(let error):
                print(error)
                seal.reject(parseErrorData(response: response))
            }
        }
    }
    
    private func parseErrorData(response: AFDataResponse<Any>?) -> Error{
        var errorString = ""
        guard let data = response?.data else {
            return MyError.noInternet
        }
        switch response?.response?.statusCode {
        case 502:
            return MyError.timeout
        case 500:
            return MyError.serverError
        default:
            if let errorResponse = try? JSONDecoder().decode(ErrorModel.self, from: data) {
                errorString = errorResponse.error
            } else if let errorResponse = try? JSONDecoder().decode(MessageModel.self, from: data) {
                errorString = errorResponse.message
            }
            else if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: [String]] {
                for value in json.values {
                    errorString += value.joined(separator: "")
                    errorString += "\n"
                }
            } else {
                errorString = MyError.unknown.message.localized
            }
            let error = NSError(domain: "validation", code: 0, userInfo: [NSLocalizedDescriptionKey: errorString])
            return error
        }
    }
}
