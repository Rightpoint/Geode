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

    private struct Row {
        let title: String
        let viewController: UIViewController.Type
    }

    private let reuseIdentifier = "com.raizlabs.geode.view-controller-cell"
    private let rows = [
        Row(title: "One-shot Location Monitoring", viewController: OneShotViewController.self),
        Row(title: "Continuous Location Monitoring", viewController: ContinuousViewontroller.self),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Geode"

        tableView.tableFooterView = UIView()
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
    }

}

// MARK: - Table View Data Source

extension RootViewController {

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let row = rows[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier) ?? UITableViewCell()
        cell.textLabel?.text = row.title

        return cell
    }

}

// MARK: - Table View Delegate

extension RootViewController {

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let row = rows[indexPath.row]
        navigationController?.pushViewController(row.viewController.init(), animated: true)
    }

}
