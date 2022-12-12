//
//  NotificationService.swift
//  NotificationService
//
//  Created by aalaa on 23/08/2022.
//

import UserNotifications

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
            self.contentHandler = contentHandler
            bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)

        guard let bestAttemptContent = bestAttemptContent else {
                return
            }
    

        // Print full message.
        print(request.content.userInfo)


        let yyy = request.content.userInfo["aps"] as? [String:Any]
        let xxx = yyy?["alert"] as? [String:Any]
        let link = request.content.userInfo["link"] as? String
        print(xxx?["Title"] as? String ?? "")
        print(xxx?["body"] as? String ?? "")
        
        print(link ?? "")
        if request.content.userInfo["attachment"] != nil {
          
            guard let attachmentUrlString = request.content.userInfo["attachment"] as? String else { return }
            guard let url = URL(string: attachmentUrlString) else {
                return
            }
            
            URLSession.shared.downloadTask(with: url, completionHandler: { (optLocation: URL?, optResponse: URLResponse?, error: Error?) -> Void in
                if error != nil {
                    print("Download file error: \(String(describing: error))")
                    return
                }
                guard let location = optLocation else {
                    return
                }
                guard let response = optResponse else {
                    return
                }
                
                OperationQueue.main.addOperation({() -> Void in
                    self.contentHandler?(bestAttemptContent);
                })
            }).resume()
        }else {
         
            guard let y = request.content.userInfo["fcm_options"] as? [String:Any] else {return}
            guard let imageUrlString = y["image"] as? String else { return }
            guard let url = URL(string: imageUrlString) else {
                return
            }
            
            URLSession.shared.downloadTask(with: url, completionHandler: { (optLocation: URL?, optResponse: URLResponse?, error: Error?) -> Void in
                if error != nil {
                    print("Download file errrrror: \(String(describing: error))")
                    return
                }
                guard let location = optLocation else {
                    return
                }
                guard let response = optResponse else {
                    return
                }
                
                do {
                    let lastPathComponent = response.url?.lastPathComponent ?? ""
                    var attachmentID = UUID.init().uuidString + lastPathComponent
                    
                    if response.suggestedFilename != nil {
                        attachmentID = UUID.init().uuidString + response.suggestedFilename!
                    }
                    
                    let tempDict = NSTemporaryDirectory()
                    let tempFilePath = tempDict + attachmentID
                    
                    try FileManager.default.moveItem(atPath: location.path, toPath: tempFilePath)
                    let attachment = try UNNotificationAttachment.init(identifier: attachmentID,
                                                                       url: URL.init(fileURLWithPath: tempFilePath))
                    
        
                    
                    bestAttemptContent.attachments.append(attachment)
                }
                catch {
                    print("Download file error: \(String(describing: error))")
                }
              

                OperationQueue.main.addOperation({() -> Void in
                    self.contentHandler?(bestAttemptContent);
                })
            }).resume()
        }
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }

}
