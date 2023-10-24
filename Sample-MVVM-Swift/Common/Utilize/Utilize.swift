//
//  Utilize.swift
//  Sample-MVVM-Swift
//
//  Created by Chhan Sophearith on 23/10/23.
//

import Foundation
import UIKit

class Utilize {
    static let shared = Utilize()
    
    func debugerResult(urlRequest: URLRequest, data: Data?, error: Bool) {
        
        let url = urlRequest.url!
        let strurl = url.absoluteString
        let allHeaders =  urlRequest.allHTTPHeaderFields ?? [:]
        let body = urlRequest.httpBody.flatMap { String(decoding: $0, as: UTF8.self) }
        let result = """
              ⚡️⚡️⚡️⚡️ Headers: \(String(describing: allHeaders))
              ⚡️⚡️⚡️⚡️ Request Body: \(String(describing: body))
        """
        print(result)
        
        let newData = data ?? Data()
        
        //  #if DEBUG
        do {
            guard let json = try JSONSerialization.jsonObject(with: newData, options: []) as? [String: AnyObject] else {
                if let arrayObject = try JSONSerialization.jsonObject(with: newData, options: []) as? [AnyObject] {
                    self.formatArrayAnyObject(json: arrayObject, url: strurl, error: error)
                }
                return
            }
            self.formatDictionay(json: json, url: strurl, error: error)
        } catch {}
        //  #endif
    }
    
    private func printerFormat(url: String, data: String, error: Bool) {
        let printer = """
        URL -->: \(url)
        Response Received -->: \(data)
        """
        
        if error {
            print("❌❌❌❌ \(printer) ❌❌❌❌")
        } else {
            print("✅✅✅✅ \(printer) ✅✅✅✅")
        }
    }
    
    private func formatArrayAnyObject(json: [AnyObject], url: String, error: Bool) {
        guard let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) else { return }
        let data = "\(NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue) ?? NSString())"
        self.printerFormat(url: url, data: data, error: error)
    }
    
    private func formatDictionay(json: [String: AnyObject], url: String, error: Bool) {
        guard let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) else { return }
        let data = "\(NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue) ?? NSString())"
        self.printerFormat(url: url, data: data, error: error)
    }
    
    func validateModel<T: Codable>(model: T.Type, data: Data, fun: String, response: (T)->()) {
        do {
            let json = try JSONDecoder().decode(T.self, from: data)
            response(json)
        } catch let DecodingError.typeMismatch(type, context) {
            print(type)
            self.showAlert(title: "Error", message: context.showError(functionName: fun))
        } catch let error {
            self.showAlert(title: "Error", message: error.localizedDescription)
        }
    }
    
    func showAlert(title: String = "", message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "ok", style: .cancel, handler: nil)
        alert.addAction(action)
        if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
            window.rootViewController?.present(alert, animated: true, completion: nil)
        }
    }
}
