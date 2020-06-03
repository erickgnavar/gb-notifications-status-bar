//
//  GithubApi.swift
//  gh-notifier
//
//  Created by Erick Navarro on 6/2/20.
//  Copyright © 2020 Erick Navarro. All rights reserved.
//

import Foundation

class GithubApi {
    let NOTIFICATIONS_URL = "https://api.github.com/notifications"
    let USER_AGENT = "gb-notifier"

    func getNotifications(callback: @escaping (Int) -> Void) {
        var request = URLRequest(url: URL(string: NOTIFICATIONS_URL)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let token = ""
        let username = ""

        let encodedToken = Data("\(username):\(token)".utf8).base64EncodedString()
        URLCache.shared.removeCachedResponse(for: request)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(USER_AGENT, forHTTPHeaderField: "User-Agent")
        request.addValue("Basic \(encodedToken)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, err in
            if err != nil {
                print(err!)
                return
            } else {
                let json = try? JSONSerialization.jsonObject(with: data!, options: [])
                if let values = json as? Array<Any> {
                    print("api: \(values.count)")
                    callback(values.count)
                }
            }
        })
        task.resume()
    }
}
