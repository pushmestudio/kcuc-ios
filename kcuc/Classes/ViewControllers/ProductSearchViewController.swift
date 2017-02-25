//
//  ProductSearchViewController.swift
//  kcuc
//
//  Created by meltest on 2017/02/23.
//  Copyright © 2017年 Pushme Studio. All rights reserved.
//

import UIKit

class ProductSearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // MARK:Pproperties
    var viewModel: SearchedProductsViewModel!
    let appleProducts = ["Mac", "iPhone", "Apple Watch", "iPad"]
    
    @IBOutlet weak var searchTextField: UITextField!        // 検索box
    @IBOutlet weak var searchResultTableView: UITableView!  // 検索結果表示用のtableview
    
    // MARK: Actions
    @IBAction func searchProdctButton(_ sender: UIButton) {
        guard let query = searchTextField.text else { return }
        print(query)
        let pagesParameters: [String: Any] = [ "query": query ]
        
        // ここが何してるかわからん
        SearchedProductsViewModel.initialize(with: pagesParameters){ (viewModel, error) in
            if let _ = error {
                print("init error")
                return
            }
            
            self.viewModel = viewModel
            self.searchResultTableView.reloadData()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        /* 今回はstoryboardで繋いでいるため記述不要
        searchResultTableView.delegate = self
        searchResultTableView.dataSource = self
        */
        
        self.searchResultTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // viewModelはImplicity Unwrapped Optionalなので仮にnilだった場合クラッシュする
        // そのため、あえてOptionalにしてデフォルト値を設けることで、エラーを防止している？
        // print(viewModel?.topics.count ?? 0)
        return viewModel?.topics.count ?? 0
        // return appleProducts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchedProductCell", for: indexPath)
        
        let topic = viewModel.topics[indexPath.row]
        print(topic)
        // ページ名を取得
        let pageName = topic.label
        // 製品名を取得(未使用).kcucからの返りが配列であるため、productsは配列で受け取る必要がありそう
        // let product = topic.products
        // let productName = product[0].label
        print(pageName ?? "")
        // productは[String : AnyObject]のため、textに代入するにはStringにdowncastが必要
        cell.textLabel?.text = pageName

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
