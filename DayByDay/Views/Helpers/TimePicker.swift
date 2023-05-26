//
//  TimePicker.swift
//  DayByDay
//
//  Created by Porter Glines on 5/19/23.
//

import SwiftUI

struct TimePicker: View {
    
    @Binding var hour: Int
    @Binding var minute: Int
    
    @State var selections: [Int] = [0, 0, 0]
    
    let data: [[String]] = [
        Array(1...12).map { "\($0)" },
        Array(0...59).map { String(format: "%02d", $0) },
        ["AM", "PM"]
    ]
    
    var body: some View {
        VStack {
            PickerView(data: data, selections: $selections)
                .onAppear {
                    setSelectionsFor(hour: hour, minute: minute)
                }
                .onChange(of: selections) { selections in
                    setHourAndMinuteFor(selections: selections)
                }
        }
    }
    
    private func setSelectionsFor(hour: Int, minute: Int = 0) {
        let hour = hour.clamped(to: 0...24)
        let minute = minute.clamped(to: 0...59)
        
        selections[0] = (hour >= 12 ? hour-12 : hour) - 1
        selections[1] = minute
        
        selections[2] = hour >= 12 ? 1 : 0
    }
    
    private func setHourAndMinuteFor(selections: [Int]) {
        let isAM = selections[2] == 0
        let hour_selected = selections[0] + 1
        
        if hour_selected == 12 && isAM {
            hour = 0
        } else if isAM {
            hour = hour_selected
        } else if hour_selected == 12 && !isAM {
            hour = hour_selected
        } else {
            hour = hour_selected + 12
        }
        minute = selections[1]
    }
}


struct PickerView: UIViewRepresentable {
    var data: [[String]]
    @Binding var selections: [Int]
    
    func makeCoordinator() -> PickerView.Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> UIPickerView {
        let picker = UIPickerView(frame: .zero)
        picker.dataSource = context.coordinator
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIView(_ uiView: UIPickerView, context: Context) {
        for i in 0..<selections.count {
            uiView.selectRow(selections[i], inComponent: i, animated: false)
        }
        context.coordinator.parent = self
    }
    
    class Coordinator: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
        
        var parent: PickerView
        
        init(_ pickerView: PickerView) {
            parent = pickerView
        }
        
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return parent.data.count
        }
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return parent.data[component].count
        }
        
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return parent.data[component][row]
        }
        
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            parent.selections[component] = row
        }
        
        func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
            return 60.0
        }
    }
}
