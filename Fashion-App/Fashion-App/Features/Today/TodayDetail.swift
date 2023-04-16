import SwiftUI
import CoreLocation

struct TodayDetail: View {
    let currWeather: CurrentWeather
    @State var currTopIndex: Int = 0
    @State var currBottomIndex: Int = 0
    @State var isPresentingSelectionAlert: Bool = false
    @EnvironmentObject var wardrobeStore: WardrobeStore
    
    var body: some View {
        let tops = wardrobeStore.getCleanTops().sorted(by: { sortByTempDiff(i1: $0, i2: $1, currWeather: currWeather) } )
        let bottoms = wardrobeStore.getCleanBottoms().sorted(by: { sortByTempDiff(i1: $0, i2: $1, currWeather: currWeather) } )
        
        VStack {
            TempBox(currWeather: currWeather)
                .offset(y: -40)
            VStack {
                if (tops.count == 0) {
                    HStack { NoItemsAvailableView(currCat: .top) }
                } else {
                    HStack { SingleClothingItemView(currIndex: $currTopIndex, currItem: wardrobeStore.selectionConfirmed ? wardrobeStore.todayTop! : tops[currTopIndex], currCat: .top, sz: tops.count) }
                }
                if (bottoms.count == 0) {
                    HStack { NoItemsAvailableView(currCat: .bottom) }
                } else {
                    HStack { SingleClothingItemView(currIndex: $currBottomIndex, currItem: wardrobeStore.selectionConfirmed ? wardrobeStore.todayBottom! : bottoms[currBottomIndex], currCat: .bottom, sz: bottoms.count) }
                }
                
                Spacer()
                Spacer()
                
                HStack {
                    Button {
                        currTopIndex = Int.random(in: 0..<tops.count)
                        currBottomIndex = Int.random(in: 0..<bottoms.count)
                    } label: { Text("Generate Random Outfit") }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 8)
                        .foregroundColor(.white)
                        .background(.blue)
                        .cornerRadius(8)
                        .buttonStyle(PlainButtonStyle())
                        .disabled(wardrobeStore.selectionConfirmed || tops.count == 0 || bottoms.count == 0)
                    
                    
                    Button {
                        isPresentingSelectionAlert = true
                    } label: { wardrobeStore.selectionConfirmed ? Text("Reset") : Text("Confirm") }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 8)
                        .foregroundColor(.white)
                        .background(.blue)
                        .cornerRadius(8)
                        .buttonStyle(PlainButtonStyle())
                        .disabled(tops.count == 0 || bottoms.count == 0)
                        .alert(isPresented: $isPresentingSelectionAlert) {
                            wardrobeStore.selectionConfirmed ?
                            
                            Alert(title: Text("Undo selection?"),
                                  message: Text("Choose a different combination!"),
                                  primaryButton: .destructive(Text("Confirm")) {
                                    wardrobeStore.removeLastNotification()
                                    wardrobeStore.resetOutfitSelection()
                                  },
                                  secondaryButton: .cancel())
                            :
                            
                            Alert(title: Text("Confirm selection?"),
                                  message: Text("Boutta be lookin' sexy!"),
                                  primaryButton: .destructive(Text("Confirm")) {
                                    let notif: Notification = Notification(top: tops[currTopIndex], bottom: bottoms[currBottomIndex], timestamp: Date.now)
                                    wardrobeStore.addNotification(notif: notif)
                                    wardrobeStore.confirmOutfitSelection(selectedTop: tops[currTopIndex], selectedBottom: bottoms[currBottomIndex])
                                  },
                                  secondaryButton: .cancel())
                        }
                }
                
                Spacer()
                Spacer()
                Spacer()
                Spacer()
            }
            .offset(y: -35)
        }
        .offset(y: 15)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                NavigationLink {
                    NotificationsView(currTopIndex: $currTopIndex, currBottomIndex: $currBottomIndex)
                } label: { wardrobeStore.getNotifications().isEmpty ? Image(systemName: "envelope") : Image(systemName: "envelope.fill") }
            }
            ToolbarItem(placement: .principal) {
                Text(NumberFormatting.date()).font(.title2)
//                        .padding(10)
//                        .overlay(RoundedRectangle(cornerRadius: 16).stroke(.black, lineWidth: 2))
                    .offset(y: 10)
                
            }
        }
    }
}
