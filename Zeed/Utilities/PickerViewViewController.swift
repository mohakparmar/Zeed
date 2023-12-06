//  How To Uses
//
//  Normal PickerView
//
//    let alert = UIAlertController(title: "Picker View", message: "Preferred Content Height", preferredStyle: .actionSheet)
//    alert.addPickerView(values: ["a","b","a","b","a","b","a","b","a","b"]) { vc, picker, index, values in
//        print(index)
//    }
//    // i pad uses
//    if let popoverPresentationController = alert.popoverPresentationController {
//        popoverPresentationController.sourceView = sender
//    }
//    alert.addAction(UIAlertAction(title: "Done", style: .cancel, handler: nil))
//    self.present(alert, animated: true, completion: nil)
//
//  DatePicker View
//
//    let alert = UIAlertController(title: "Picker View", message: "Preferred Content Height", preferredStyle: .actionSheet)
//    alert.addDatePicker(mode: .date, date: Date(), minimumDate: nil, maximumDate: nil) { date in
//        print(date)
//    }
//    // i pad uses
//    if let popoverPresentationController = alert.popoverPresentationController {
//        popoverPresentationController.sourceView = sender
//    }
//    alert.addAction(UIAlertAction(title: "Done", style: .cancel, handler: nil))
//    self.present(alert, animated: true, completion: nil)

import UIKit

extension UIAlertController {
   
    func addPickerView(values: PickerViewViewController.Values,  initialSelection: PickerViewViewController.Index? = nil, action: PickerViewViewController.Action?) {
        let pickerView = PickerViewViewController(values: values, initialSelection: initialSelection, action: action)
        set(vc: pickerView, height: 216)
    }
    
    func set(vc: UIViewController?, width: CGFloat? = nil, height: CGFloat? = nil) {
          guard let vc = vc else { return }
          setValue(vc, forKey: "contentViewController")
            
          if let height = height {
              preferredContentSize.height = height
          }
      }
    
    // Date Picker
    func addDatePicker(mode: UIDatePicker.Mode, date: Date?, minimumDate: Date? = nil, maximumDate: Date? = nil, action: PickerViewViewController.DateAction?) {
           let datePicker = PickerViewViewController(mode: mode, date: date, minimumDate: minimumDate, maximumDate: maximumDate, action: action)
           set(vc: datePicker, height: 217)
       }
}

final class PickerViewViewController: UIViewController {
    
    public typealias Values = [String]
    public typealias Index = (column: Int, row: Int)
    public typealias Action = (_ vc: UIViewController, _ picker: UIPickerView, _ index: Index, _ values: Values) -> ()
     public typealias DateAction = (Date) -> Void
    
      fileprivate var dateaction: DateAction?
    fileprivate var action: Action?
    fileprivate var values: Values = []
    fileprivate var initialSelection: Index?
    var isDatePicker = false
    fileprivate lazy var pickerView: UIPickerView = {
        return $0
    }(UIPickerView())
    
    fileprivate lazy var datePicker: UIDatePicker = { [unowned self] in
           $0.addTarget(self, action: #selector(PickerViewViewController.actionForDatePicker), for: .valueChanged)
           return $0
       }(UIDatePicker())
    
    init(values: Values, initialSelection: Index? = nil, action: Action?) {
        super.init(nibName: nil, bundle: nil)
        self.values = values
        self.initialSelection = initialSelection
        self.action = action
    }
    
     init(mode: UIDatePicker.Mode, date: Date? = nil, minimumDate: Date? = nil, maximumDate: Date? = nil, action: DateAction?) {
           super.init(nibName: nil, bundle: nil)
           datePicker.datePickerMode = mode
           datePicker.date = date ?? Date()
           datePicker.minimumDate = minimumDate
           datePicker.maximumDate = maximumDate
           dateaction = action
           isDatePicker = true
       }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        
        if(isDatePicker)
        {
             view = datePicker
        }
        else
        {
             view = pickerView
        }
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.dataSource = self
        pickerView.delegate = self
    }
    
    @objc func actionForDatePicker() {
       dateaction?(datePicker.date)
       }
    
    public func setDate(_ date: Date) {
          datePicker.setDate(date, animated: true)
      }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if let initialSelection = initialSelection, values.count > initialSelection.column, values[initialSelection.column].count > initialSelection.row {
            pickerView.selectRow(initialSelection.row, inComponent: initialSelection.column, animated: true)
        }
    }
}

extension PickerViewViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    // returns the # of rows in each component..
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return values.count
    }
    
    // If you return back a different object, the old one will be released. the view will be centered in the row rect
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return values[row]
    }
   
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        action?(self, pickerView, Index(column: component, row: row), values)
    }
}
