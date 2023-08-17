//
//  ViewController.swift
//  api post 3
//
//  Created by Admin on 15/08/23.
//

import UIKit





struct root: Codable{
    var status: String?
    var variantList: [String?]
    var vehicleInfo: vehicleInfo?
}
struct vehicleInfo: Codable{
    var segment: String?
}


class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jsondata?.variantList.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"tablecell")as! TableViewCell
        cell.label1.text = jsondata?.variantList[indexPath.row]
        cell.label2.text = jsondata?.vehicleInfo?.segment
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150 
    }
    
    var jsondata: root?
    

    
    @IBOutlet weak var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        response()
        
    }
    
    func response(){
        let url = "https://kuwycredit.in/servlet/rest/ltv/forecast/ltvVariants"
        let request = NSMutableURLRequest (url: NSURL(string: url)! as URL)
        request.httpMethod = "POST"
        request.addValue ("application/json",forHTTPHeaderField: "Content-Type")
        var params: [String: Any] = ["year":"2020","make":"RENAULT","model":"KWID"]
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions())
            let task = URLSession.shared.dataTask(with: request as URLRequest as URLRequest, completionHandler: {(data, response, error) in
                
                if let response = response {
                    let nsHTTPResponse = response as! HTTPURLResponse
                    let statusCode = nsHTTPResponse.statusCode
                    print("status rode = \(statusCode)")
                }
                if let error = error {
                    print ("\(error)")
                }
                if let data = data {
                    do {
                        let content = try? JSONDecoder().decode(root.self, from: data)
                        self.jsondata = content
                        print (content as Any)
                        
                        DispatchQueue.main.async{
                            self.tableview.reloadData()
                        }
                    }
                    catch{
                        print(error)
                    }
                }
            })
            task.resume()
        }catch _ {
            print("oops something happened buddy")
        }
            
            
    }


}



