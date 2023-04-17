import SwiftUI
import CoreLocation

struct SelectTopForm: View {
    //let currWeather: CurrentWeather
    let forecastSummary: [ForecastSummary]
    var threeColumnGrid = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    @EnvironmentObject var wardrobeStore: WardrobeStore
    @Binding var dict: [Date: ClothingItem]
    @Binding var selectedDate: Date
    
    var body: some View {
        ScrollView {
            Text("Select Top for \(selectedDate.formatted(.dateTime.day().month(.wide).weekday(.wide)))")
                .padding()
                .font(.system(size: 23))
                .bold()
            
            ForecastBox(forecastSummary: forecastSummary, selectedDate: $selectedDate)
            //TempBox(currWeather: currWeather)
            
            LazyVGrid(columns: threeColumnGrid) {
                ForEach($wardrobeStore.clothes
                    .filter({ $0.category
                        .wrappedValue == .top})) { $clothingItem in
                            SelectTopCell(clothingItem: $clothingItem, dict: $dict, selectedDate: $selectedDate)
                }
            }
       }
    }
}

struct SelectTopCell: View {
    @Binding var clothingItem: ClothingItem
    @EnvironmentObject var wardrobeStore: WardrobeStore
    @Binding var dict: [Date: ClothingItem]
    @Binding var selectedDate: Date
    
    var body: some View {
            VStack {
                Button {
                    dict[selectedDate] = clothingItem
                } label: {
                    clothingItem.img
                        .resizable()
                        .scaledToFit()
                }
            }
        
        Spacer()
    }
}
