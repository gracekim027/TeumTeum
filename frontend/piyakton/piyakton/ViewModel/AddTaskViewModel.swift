//
//  TaskViewModel.swift
//  piyakton
//
//  Created by Grace Kim on 1/11/25.
//

import SwiftUI
import FirebaseFirestore

@MainActor
class AddTaskViewModel: ObservableObject {
    @Published var isShowingTimeSelection = false
    @Published var selectedTime: Int? = nil
    @Published var showConfirmation = false
    @Published var taskDescription = ""
    @Published var uploadedFiles: [UploadedFile] = []
    @Published var isShowingFilePicker = false
    
    // Properties for task submission
    @Published var isLoading = false
    @Published var error: Error?
    @Published var createdTaskId: String?
    
    private let taskService: TaskService
    
    init(taskService: TaskService = TaskService()) {
        self.taskService = taskService
        loadSampleFiles()
    }
    
    func loadSampleFiles() {
        if let pdfURL = Bundle.main.url(forResource: "pdf_sample", withExtension: "pdf") {
            print("PDF file loaded successfully: \(pdfURL)")
            let file = UploadedFile(
                id: UUID().uuidString,  // Using string ID instead of UUID
                name: "pdf_sample.pdf",
                type: .pdf,
                url: pdfURL
            )
            uploadedFiles.append(file)
        } else {
            print("Failed to load PDF file: pdf_sample.pdf not found in bundle")
        }
        
        if let mp3URL = Bundle.main.url(forResource: "mp3_sample", withExtension: "mp3") {
            print("MP3 file loaded successfully: \(mp3URL)")
            let file = UploadedFile(
                id: UUID().uuidString,  // Using string ID instead of UUID
                name: "mp3_sample.mp3",
                type: .mp3,
                url: mp3URL
            )
            uploadedFiles.append(file)
        } else {
            print("Failed to load MP3 file: mp3_sample.mp3 not found in bundle")
        }
        
        print("Uploaded Files: \(uploadedFiles)")
    }

    func addFile(_ url: URL) {
        let fileType: FileType = url.pathExtension == "pdf" ? .pdf : .mp3
        let file = UploadedFile(
            id: UUID().uuidString,  // Using string ID instead of UUID
            name: url.lastPathComponent,
            type: fileType,
            url: url
        )
        uploadedFiles.append(file)
    }
    
    func removeFile(_ file: UploadedFile) {
        uploadedFiles.removeAll { $0.id == file.id }
    }
    
    func showFilePicker() {
        isShowingFilePicker = true
    }
    
    @MainActor
    func submitTask() async {
        guard let unitTime = selectedTime else {
            error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Please select a time"])
            return
        }
        
        guard let fileInfo = uploadedFiles.first else {
            error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Please upload a file"])
            return
        }
        
        isLoading = true
        
        do {
            let taskId = try await taskService.createTask(
                description: taskDescription,
                unitTime: unitTime,
                fileInfo: fileInfo
            )
            
            self.createdTaskId = taskId
            self.showConfirmation = true
            self.isLoading = false
            
        } catch {
            self.error = error
            self.isLoading = false
        }
    }
}
