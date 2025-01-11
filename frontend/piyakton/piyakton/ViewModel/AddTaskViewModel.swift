//
//  TaskViewModel.swift
//  piyakton
//
//  Created by Grace Kim on 1/11/25.
//
import SwiftUI

class AddTaskViewModel: ObservableObject {
    @Published var isShowingTimeSelection = false
    @Published var selectedTime: Int? = nil
    @Published var showConfirmation = false
    @Published var taskDescription = ""
    @Published var uploadedFiles: [UploadedFile] = []
    @Published var isShowingFilePicker = false
        
    init() {
            //loadSampleFiles()
        }
    
    func loadSampleFiles() {
        if let pdfURL = Bundle.main.url(forResource: "pdf_sample", withExtension: "pdf") {
            print("PDF file loaded successfully: \(pdfURL)")
            uploadedFiles.append(UploadedFile(name: "pdf_sample.pdf", type: .pdf, url: pdfURL))
        } else {
            print("Failed to load PDF file: pdf_sample.pdf not found in bundle")
        }
        
        if let mp3URL = Bundle.main.url(forResource: "mp3_sample", withExtension: "mp3") {
            print("MP3 file loaded successfully: \(mp3URL)")
            uploadedFiles.append(UploadedFile(name: "mp3_sample.mp3", type: .mp3, url: mp3URL))
        } else {
            print("Failed to load MP3 file: mp3_sample.mp3 not found in bundle")
        }
        
        // Log the uploadedFiles array
        print("Uploaded Files: \(uploadedFiles)")
    }
    
    func addFile(_ url: URL) {
        let fileType: FileType = url.pathExtension == "pdf" ? .pdf : .mp3
        let file = UploadedFile(name: url.lastPathComponent, type: fileType, url: url)
        uploadedFiles.append(file)
    }

    func removeFile(_ file: UploadedFile) {
        uploadedFiles.removeAll { $0.id == file.id }
    }

    func showFilePicker() {
        isShowingFilePicker = true
    }
}
