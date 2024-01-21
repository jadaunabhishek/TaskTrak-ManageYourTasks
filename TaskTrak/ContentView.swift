//
//  ContentView.swift
//  TaskTrak
//
//  Created by Abhishek Jadaun on 21/01/24.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @State private var presentTask = false
    @State private var showDate = false
    @State private var showTime = false
    @State private var showAlert = false
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Task.title, ascending: true)]) private var tasks: FetchedResults<Task>
    
    @State private var newTaskTitle = ""
    @State private var newTaskDescription = ""
    @State private var selectedDate: Date = Date()
    @State private var selectedTime: Date = Date()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(tasks) { task in
                    TaskView(task: task)
                }
                .onDelete(perform: deleteTasks)
            }
            .navigationTitle("Your tasks")
            .navigationBarItems(trailing: Button {
                presentTask.toggle()
            } label: {
                Image(systemName: "plus")
            })
            .sheet(isPresented: $presentTask) {
                NavigationView {
                    Form {
                        Section(header: Text("Task Details")) {
                            TextField("Title", text: $newTaskTitle)

                            TextField("Description", text: $newTaskDescription)
                        }

                        Section(header: Text("Due Date")) {
                            Toggle(isOn: $showDate) {
                                Text("Include Date")
                            }
                            if showDate {
                                DatePicker("Date", selection: $selectedDate, displayedComponents: .date)
                            }
                        }

                        Section(header: Text("Due Date and Time")) {
                            Toggle(isOn: $showTime) {
                                Text("Include Time")
                            }
                            if showTime {
                                DatePicker("Time", selection: $selectedTime, displayedComponents: .hourAndMinute)
                            }
                        }
                    }
                    .navigationBarTitle("Add Task", displayMode: .inline)
                    .navigationBarItems(trailing: Button(action: {
                        if newTaskTitle.isEmpty {
                            showAlert = true
                        } else {
                            addTask()
                            presentTask.toggle()
                            newTaskTitle = ""
                            newTaskDescription = ""
                            selectedDate = Date()
                            selectedTime = Date()
                        }
                    }) {
                        Text("Add")
                    })
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text("Error"), message: Text("Add Title for your task"))
                    }
                }
                .presentationDetents([.medium])
            }


        }
    }
    
    private func addTask() {
        withAnimation {
            let newTask = Task(context: viewContext)
            newTask.id = UUID()
            newTask.title = newTaskTitle
            newTask.isCompleted = false
            if showDate {
                newTask.dateTask = selectedDate
            }
            if showTime {
                newTask.timeTask = selectedTime
            }
            newTask.descriptionTask = newTaskDescription // Set the notes

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private func deleteTasks(offsets: IndexSet) {
        withAnimation {
            offsets.map { tasks[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

