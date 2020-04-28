//
//  AverageDayView.swift
//  McGoMas
//
//  Created by Swopnil Joshi on 4/27/20.
//  Copyright © 2020 Capstone. All rights reserved.
//

import SwiftUI

struct AverageDayView: View {
    func getPredictionBar(pred: Prediction) -> some View {
        var color = Color.green
        switch pred.prediction { // color based on prediction
        case 0...75:
            color = Color.green
        case 76...150:
            color = Color.yellow
        case 151...225:
            color = Color.orange
        default:
            color = Color.red
        }
        return AnyView(HStack {
            Text("\(predictionTimeFormatter.string(from: pred.dateTime))")
                .frame(width: 50) // frame ensures bars start evenly
            
            Rectangle().fill(color).frame(width: CGFloat(pred.prediction) / 1.5 + 2, height: 10) // +2 so <=0 predictions aren't empty
            //Text(" \(pred.prediction)") //don't need to know exact prediction
        })
    }
    
    var body: some View {
        NavigationView { // check if date is in range
            List {
                ForEach(averagePredictions, id: \.id) { pred in //render predictions
                    self.getPredictionBar(pred: pred)
                }
            }
            .navigationBarTitle(Text("Average Day"))
        }
    }
}

struct AverageDayView_Previews: PreviewProvider {
    static var previews: some View {
        AverageDayView()
    }
}
