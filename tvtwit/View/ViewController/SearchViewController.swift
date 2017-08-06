//
//  SearchViewController.swift
//  Hubtele
//
//  Created by NakamaTakaaki on 2016/01/15.
//  Copyright © 2016年 NakamaTakaaki. All rights reserved.
//

import Foundation
import ReactiveCocoa

class SearchViewController: UIViewController,UISearchBarDelegate,UIGestureRecognizerDelegate {
	
	private var viewModel: SearchViewModel!
	private var bindingHelper: TableViewBindingHelper!
	
    @IBOutlet weak var searchTextField: UISearchBar!
	@IBOutlet weak var searchResultTable: UITableView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.viewModel = SearchViewModel(service: SearchServiceImpl())
        searchTextField.rac_textSignal() ~> RAC(viewModel,"searchText")
        searchTextField.rac_pressSearchSignal().subscribeNext({
            _ -> () in
            self.viewModel.executeSearch!.execute(nil)
            if(self.searchTextField.isFirstResponder()){
                print("firstresponder")
                self.searchTextField.resignFirstResponder()
            }
        })

        self.viewModel.executeSearch!.executing.not() ~> RAC(searchTextField,"userInteractionEnabled")
		
		bindingHelper = TableViewBindingHelper(tableView: searchResultTable, sourceSignal: RACObserve(viewModel, keyPath: "searchResults"), nibName: "SearchTableViewCell", selectionCommand: RACCommand() {
				(any: AnyObject!) -> RACSignal! in
				let vm = any as! SearchResultsItemViewModel
                self.goChatScene(vm.program)
				return RACSignal.empty()
            })
        
        
        let touch = UIPanGestureRecognizer(target:self, action:#selector(scrollTouch(_:)))
        touch.delegate=self
        self.searchResultTable.addGestureRecognizer(touch)
	}
    
   func scrollTouch(recognizer:UIPanGestureRecognizer) {
    //empty
    }
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        if(searchTextField.isFirstResponder()){
            searchTextField.resignFirstResponder()
        }
        return false
    }
    override func viewWillAppear(animated: Bool) {
            self.navigationController?.title="検索"
            self.tabBarController?.title="検索"
            self.tabBarItem.title="検索"
            self.tabBarController?.navigationItem.title="検索"
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    }
    

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
    
    
    override func viewDidAppear(animated: Bool) {
        self.tabBarItem.title="検索"
        self.tabBarController?.navigationItem.title="検索"
    }
  
    //Write your code here
	
}