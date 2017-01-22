//
//  RootViewController.swift
//  Example
//
//  Created by John Watson on 1/27/16.
//
//  Copyright © 2016 Raizlabs. All rights reserved.
//  http://raizlabs.com
//
//  Permission is hereby granted, free of charge, to any person obtaining
//  a copy of this software and associated documentation files (the
//  "Software"), to deal in the Software without restriction, including
//  without limitation the rights to use, copy, modify, merge, publish,
//  distribute, sublicense, and/or sell copies of the Software, and to
//  permit persons to whom the Software is furnished to do so, subject to
//  the following conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
//  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
//  LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
//  OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
//  WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import UIKit

final class RootViewController: UITableViewController {

    fileprivate struct Row {
        let title: String
        let viewController: UIViewController.Type
    }

    fileprivate let reuseIdentifier = "com.raizlabs.geode.view-controller-cell"
    fileprivate let rows = [
        Row(title: "One-shot Location Monitoring", viewController: OneShotViewController.self),
        Row(title: "Continuous Location Monitoring", viewController: ContinuousViewontroller.self),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Geode"

        tableView.tableFooterView = UIView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
    }

}

// MARK: - Table View Data Source

extension RootViewController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = rows[(indexPath as NSIndexPath).row]
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) ?? UITableViewCell()
        cell.textLabel?.text = row.title

        return cell
    }

}

// MARK: - Table View Delegate

extension RootViewController {

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = rows[(indexPath as NSIndexPath).row]
        navigationController?.pushViewController(row.viewController.init(), animated: true)
    }

}
