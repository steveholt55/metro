//
//  Copyright © 2016 Brandon Jenniges. All rights reserved.
//

import UIKit

extension ProvidersViewController: UITableViewDataSource {
    
    // MARK: - UITableview datasource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.providers.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let provider = self.viewModel.providers[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        cell.textLabel?.text = provider.text!
        return cell
    }
}