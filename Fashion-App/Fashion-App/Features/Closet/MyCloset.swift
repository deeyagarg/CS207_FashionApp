import SwiftUI

struct MyCloset: View {
    @EnvironmentObject var wardrobeStore: WardrobeStore
    @State var isPresentingClothingForm: Bool = false
    @State var newClothingFormData = ClothingItem.FormData()
    
    
    var body: some View {
        List($wardrobeStore.clothes) { $clothingItem in ClothingItemRow(clothingItem: $clothingItem) }
        .navigationTitle("My Closet")
        .toolbar {
          ToolbarItem(placement: .navigationBarTrailing) {
            Button("Add") { isPresentingClothingForm.toggle() }
          }
        }
        .sheet(isPresented: $isPresentingClothingForm) {
            NavigationStack {
                ClothingForm(data: $newClothingFormData)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel") {
                            isPresentingClothingForm = false
                            newClothingFormData = ClothingItem.FormData()
                        }
                        
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Save") {
                            let newClothingItem = ClothingItem.create(from: newClothingFormData)
                            wardrobeStore.addClothingItem(newClothingItem)
                            isPresentingClothingForm = false
                            newClothingFormData = ClothingItem.FormData()
                        }
                    }
                }
            }
            .padding()
        }
        
        Text("My Closet")
    }
}

struct ClothingItemRow: View {
    @Binding var clothingItem: ClothingItem
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(clothingItem.name).fontWeight(.semibold)
            }
        }
    }
}

struct ClothingList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView { MyCloset().environmentObject( WardrobeStore() ) }
    }
}
