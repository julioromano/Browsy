
//
//  ViewController.swift
//  Browsy
//
//  Created by julionb on 31/03/2017.
//  Copyright © 2017 kJulio. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var urlField: NSTextField!
    @IBOutlet weak var tableView: NSTableView!
    var browserItems: [Bundle]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.refreshView(notification:)),
            name: NSNotification.Name(rawValue: "lastUrl"),
            object: nil
        )
        reloadBrowserList()
    }
    
    @objc func refreshView(notification: NSNotification) {
        let appDelegate = NSApplication.shared.delegate as! AppDelegate
        urlField.stringValue = (appDelegate.lastUrl?.absoluteString)!
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    func getInstalledBrowsers () -> [ Bundle ] {
        var browsers = [ Bundle ]()
        let array = LSCopyAllHandlersForURLScheme("https" as CFString)?
            .takeRetainedValue()
        // let array = LSCopyAllRoleHandlersForContentType(
        //     "public.html" as CFString, LSRolesMask.all)?.takeRetainedValue()
        for i in 0..<CFArrayGetCount(array!) {
            let bundleId = unsafeBitCast(
                CFArrayGetValueAtIndex(array!, i),
                to: CFString.self
                ) as String
            if let path = NSWorkspace.shared
                .absolutePathForApplication(withBundleIdentifier: bundleId) {
                if let bundle = Bundle(path: path) {
                    // let name: String = bundle.infoDictionary!["CFBundleName"] as String
                    if bundle.bundleIdentifier == Bundle.main.bundleIdentifier {
                        continue
                    }
                    browsers.append(bundle)
                }
            }
        }
        return browsers
    }
    
    func reloadBrowserList() {
        browserItems = getInstalledBrowsers()
        tableView.reloadData()
    }

}

extension ViewController: NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return browserItems?.count ?? 0
    }
    
}

extension ViewController: NSTableViewDelegate {
    
    fileprivate enum CellIdentifiers {
        static let NameCell = "NameCellID"
        static let DescriptionCell = "DescriptionCellID"
    }
    
    func tableView(_ tableView: NSTableView,
                   viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        var image: NSImage?
        var text: String = ""
        var cellIdentifier: String = ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .long
        // 1
        guard let item = browserItems?[row] else {
            return nil
        }
        // 2
        if tableColumn == tableView.tableColumns[0] {
            
            let appPath: String = item.bundlePath
            let appIcon: NSImage = NSWorkspace.shared.icon(forFile: appPath)
            
            image = appIcon
            text = item.bundleURL.lastPathComponent
            cellIdentifier = CellIdentifiers.NameCell
        }
        // 3
        if let cell = tableView
            .makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellIdentifier), owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = text
            cell.imageView?.image = image ?? nil
            return cell
        }
        return nil
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        let appDelegate = NSApplication.shared.delegate as! AppDelegate
        let itemsSelected = tableView.selectedRowIndexes
        for row in itemsSelected {
            appDelegate.openLastUrl(appId: browserItems?[row].bundleIdentifier)
        }
        NSApplication.shared.terminate(self)
    }
    
}

extension Bundle {
    var displayName: String? {
        return object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
    }
}
