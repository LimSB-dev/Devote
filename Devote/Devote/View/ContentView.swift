//
//  ContentView.swift
//  Devote
//
//  Created by 임성빈 on 2022/03/26.
//

import SwiftUI
import CoreData

struct ContentView: View {
    // MARK: Property
    
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    @State var task: String = ""
    @State private var showNewTaskItem: Bool = false
    
    // MARK: Fetching Data
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    // MARK: Function

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    // MARK: Body
    
    var body: some View {
        NavigationView {
            ZStack {
                // MARK: Main View
                VStack {
                    // MARK: Header
                    HStack(spacing: 10) {
                        // MARK: Title
                        Text("Devote")
                            .font(.system(.largeTitle, design: .rounded))
                            .fontWeight(.heavy)
                            .padding(.leading, 4)
                        
                        Spacer()
                        // MARK: Edit Button
                        EditButton()
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                            .padding(.horizontal, 10)
                            .frame(minWidth: 70, minHeight: 24)
                            .background(
                                Capsule().stroke(isDarkMode ? Color.gray : Color.white, lineWidth: 2)
                            )
                        
                        // MARK: Appearance Button
                        Button(action: {
                            // MARK: Toogle Appearance
                            isDarkMode.toggle()
                        }, label: {
                            Image(systemName: isDarkMode ? "moon" : "sun.max")
                                .resizable()
                                .frame(width: 24, height: 24, alignment: .center)
                                .font(.system(.title, design: .rounded))
                        })
                        
                    } // HStack
                    .padding()
                    .foregroundColor(isDarkMode ? .black : .white)
                    
                    Spacer(minLength: 80)
                    
                    // MARK: New Task Button
                    
                    Button(action: {
                        showNewTaskItem = true
                    }, label: {
                        Image(systemName: "plus.circle")
                            .font(.system(size: 30, weight: .semibold, design: .rounded))
                        Text("New Task")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                    })
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 15)
                    .background(
                        LinearGradient(gradient: Gradient(colors: [Color.pink, Color.blue]), startPoint: .leading, endPoint: .trailing)
                            .clipShape(Capsule())
                    )
                    .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.2), radius: 25, x: 0, y: 4)
                    
                    // MARK: Tasks
                    
                    List {
                        ForEach(items) { item in
                            ListRowItemView(item: item)
                        } // List Item
                        .onDelete(perform: deleteItems)
                    } // List
                    .listStyle(InsetGroupedListStyle())
                    .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.3), radius: 12)
                    .padding(.vertical, 0)
                    .frame(maxWidth: 640)
                } // VStack
                
                // MARK: New Task Item
                
                if showNewTaskItem {
                    BlankView()
                        .onTapGesture {
                            withAnimation() {
                                showNewTaskItem = false
                            }
                        }
                    
                    NewTaskItemView(isShowing: $showNewTaskItem)
                }
                
            } // ZStack
            .onAppear() {
                UITableView.appearance().backgroundColor = UIColor.clear
            }
            .navigationBarTitle("Daily Tasks", displayMode: .large)
            .navigationBarHidden(true)
            .background(
                BackgroundImageView()
            )
            .background(
                backgroundGradient
                    .ignoresSafeArea(.all)
            )
        } // Navigation
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

// MARK: Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice("iPhone 13")
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
