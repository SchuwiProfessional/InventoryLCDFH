//
//  ContentView.swift
//  SwiftInventory
//
//  Created by Alvaro  on 9/05/23.
//

import SwiftUI
import Firebase
import FirebaseAuth
import SDWebImageSwiftUI

struct ContentView: View {
    
    @StateObject var viewModel = ProductsViewModel()
    @AppStorage ("uid") var userID: String = ""
    @State var presentAddProductSheet = false
    @State private var searchText = ""
    @State var lowStockProducts: [Product] = []
    @StateObject private var registrosViewModel = NoteViewModel()
    @State private var newNote = ""
    
    
    private var addButton: some View {
        Button(action: { self.presentAddProductSheet.toggle() }) {
            Image(systemName: "plus")
        }
    }
    private func ProductRowView(product: Product) -> some View {
        NavigationLink(destination: ProductDetailsView(product: product)) {
            VStack(alignment: .leading) {
                HStack {
                    AnimatedImage(url: URL(string: product.image)!).resizable().frame(width: 65, height: 65).clipShape(Circle())
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Producto:")
                                .fontWeight(.bold)
                            Text(product.product)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        HStack {
                            Text("Marca:")
                                .fontWeight(.bold)
                            Text(product.brand)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        HStack {
                            Text("Cantidad:")
                                .fontWeight(.bold)
                            Text(String(product.amount))
                        }
                        HStack {
                            Text("Precio:")
                                .fontWeight(.bold)
                            Text(String("S/. \(product.price)"))
                        }
                    }
                    
                }
            }
        }
    }
    
    var body: some View {
        if userID == "" {
            AuthView()
        } else {
            TabView {
                NavigationView {
                    List {
                        TextField("Buscar", text: $searchText)
                            .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                        ForEach(viewModel.products.filter { searchText.isEmpty || $0.product.localizedCaseInsensitiveContains(searchText) || $0.brand.localizedCaseInsensitiveContains(searchText) }) { product in
                            ProductRowView(product: product)
                        }
                        
                    }
                    .navigationBarTitle("Inventario")
                    .navigationBarItems(trailing: addButton)
                    .onAppear() {
                        print("productsListviweapppp")
                        self.viewModel.subscribe()
                    }
                    .sheet(isPresented: self.$presentAddProductSheet) {
                        ProductEditView()
                    }
                }
                .tabItem {
                    Image(systemName: "house")
                    Text("Inicio")
                }.tag(0)
                
                VStack {
                    List(viewModel.outOfStockProducts) { product in
                        VStack {
                            ProductRowView(product: product)
                            Text("Poco stock")
                                .foregroundColor(.red)
                                .font(.caption)
                        }
                    }
                }
                
                .tabItem {
                    Image(systemName: "exclamationmark.triangle")
                    Text("Alertas")
                }
                .tag(1)
                
                
                VStack {
                    List(registrosViewModel.notes.sorted(by: { $0.timestamp > $1.timestamp })) { note in
                        VStack(alignment: .leading) {
                            Text(note.note)
                                .font(.headline)
                            Text(note.timestamp, style: .date)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                    .navigationBarTitle("Registro")
                    
                    VStack {
                        Text("Nuevo registro")
                            .font(.headline)
                            .padding(.bottom, 4)
                        
                        TextField("Añada el registro", text: $newNote)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.bottom, 8)
                        
                        Button(action: {
                            let note = Note(note: newNote, timestamp: Date())
                            registrosViewModel.addNote(note)
                            newNote = ""
                        }) {
                            Text("Agregar")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(Color.blue)
                                .cornerRadius(8)
                        }
                        .disabled(newNote.isEmpty)
                    }
                    .padding()
                }
                .onAppear {
                    registrosViewModel.fetchNotes()
                }
                .tabItem {
                    Image(systemName: "note.text.badge.plus")
                    Text("Registros")
                }
                
                List {
                    Section {
                        HStack {
                            Text("AO")
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(width: 72, height: 72)
                                .background(Color(.systemGray))
                                .clipShape(Circle())
                            
                            VStack (alignment: .leading, spacing: 4){
                                Text("\(userID)")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .padding(.top, 4)
                                
                                Text("test@test.com")
                                    .font(.footnote)
                                    .accentColor(.gray)
                            }
                        }
                    }
                    Section ("Opciones") {
                        HStack {
                            Button(action: {
                                let firebaseAuth = Auth.auth()
                                do {
                                    try firebaseAuth.signOut()
                                    withAnimation {
                                        userID = ""
                                    }
                                } catch let signOutError as NSError {
                                    print("Error signing out: %@", signOutError)
                                }
                            }) {
                                HStack {
                                    Image(systemName: "rectangle.portrait.and.arrow.right")
                                        .foregroundColor(.red)
                                    Text("Sign Out")
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                    }
                }
                .tabItem {
                    Image(systemName: "person")
                    Text("Perfil")
                }.tag(3)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
