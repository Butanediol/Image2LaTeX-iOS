//
//  ImageViewModel.swift
//  Image2Latex
//
//  Created by Butanediol on 8/4/2021.
//

import SwiftUI
import CoreData

struct Settings {
    var app_id = UserDefaults.standard.string(forKey: "Settings.app_id") ?? ""
    var app_key = UserDefaults.standard.string(forKey: "Settings.app_key") ?? ""
}

class imageViewModel: ObservableObject {
    
//    @Published var imageData: Data?
    @Published var imageData: UIImage?
    @Published var response: Response?
    @Published var isLoading = false
    
    var mySettings = Settings()
    
    func processImageV2(context: NSManagedObjectContext) {
        
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        guard let URL = URL(string: "https://api.mathpix.com/v3/text") else { return }
        var request = URLRequest(url: URL)
        request.httpMethod = "POST"

        // Headers
        request.addValue(mySettings.app_id, forHTTPHeaderField: "app_id")
        request.addValue(mySettings.app_key, forHTTPHeaderField: "app_key")
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
                        print("[Response]: \(self.response!)")
                        self.response!.saveAsHistory(imageData: self.imageData!.pngData()!, context: context)
                    } catch {
                        print(error)
                    }
                    self.isLoading = false
                }
            }
        }
        task.resume()
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
        
        func saveAsHistory(imageData: Data, context: NSManagedObjectContext) {
            let newHistoryImage = HistoryImage(context: context)
            newHistoryImage.imageData = imageData
            newHistoryImage.timestamp = Date()
            print("Date\(dateFormatter.string(from: newHistoryImage.timestamp!))")
            
            do {
                try context.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}
