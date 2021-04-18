//
//  ImageViewModel.swift
//  Image2Latex
//
//  Created by Butanediol on 8/4/2021.
//

import SwiftUI
import CoreData

class imageViewModel: ObservableObject {
    
    @Published var imageData: UIImage?
    @Published var response: Response?
    @Published var isLoading = false
    
    func processImageV2(context: NSManagedObjectContext) {
        
        // API Settings
        let app_id = UserDefaults.standard.string(forKey: "Settings.app_id") ?? ""
        let app_key = UserDefaults.standard.string(forKey: "Settings.app_key") ?? ""
        
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        guard let URL = URL(string: "https://api.mathpix.com/v3/text") else { return }
        var request = URLRequest(url: URL)
        request.httpMethod = "POST"

        // Headers
        request.addValue(app_id, forHTTPHeaderField: "app_id")
        request.addValue(app_key, forHTTPHeaderField: "app_key")
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        //JSON Body
        let bodyObject: [String : Any] = [
            "src": "data:image/png;base64,\(imageData?.pngData()?.base64EncodedString() ?? "")"
        ]
        request.httpBody = try! JSONSerialization.data(withJSONObject: bodyObject, options: [])
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                DispatchQueue.main.async {
                    do {
                        self.response = try JSONDecoder().decode(Response.self, from: data)
                        self.saveAsHistory(imageData: self.imageData!.pngData()!, response: self.response,context: context)
                    } catch {
                        fatalError("Unresolved Error: \(error as NSError)")
                    }
                    self.isLoading = false
                }
            }
        }
        task.resume()
    }
    
    func saveAsHistory(imageData: Data, response: Response?, context: NSManagedObjectContext) {
        
        guard let response = response else { return }
        
        let newHistoryImage = HistoryImage(context: context)
        newHistoryImage.imageData = imageData
        newHistoryImage.timestamp = Date()
        
        if let html = response.html {
            newHistoryImage.html = html
        }
        
        if let latex = response.latex_styled {
            newHistoryImage.latex = latex
        }
        
        if let text = response.text {
            newHistoryImage.text = text
        }
        
        do {
            try context.save()
        } catch {
            fatalError("Unresolved error: \(error as NSError)")
        }
    }
    
    struct Response: Codable {
        var request_id: String?
        var text: String?
        var latex_styled: String?
        var confidence: Float?
        var confidence_rate: Float?
        var is_printed: Bool?
        var is_handwritten: Bool?
        var html: String?
        var data: [ResponseData]?
        var auto_rotate_confidence: Float?
        var auto_rotate_degrees: Float?
        var error: String?
        var error_info: ErrorInfo?
        
        struct ResponseData: Codable {
            var type: String
            var value: String
        }
        
        struct ErrorInfo: Codable {
            var id: String
            var message: String
            var detail: String?
        }
    }
}
