import SwiftUI

struct SceltaSmaltimentoView: View {
    @State private var opzioneScelta: DeliveryOption? = nil
    @State private var lockerInfo = ""
    @State private var mostraMappa = false
    
    // Stati per la gestione della conferma e QR Code
    @State private var mostraConfermaOverlay = false
    @State private var vaiAQRCodes = false
    @State private var vaiAlMenu = false
    @State private var codiceTemporaneo = "RCS-123" // Codice simulato per lo smaltimento
    
    @State private var messaggioConferma: String? = nil
    @State private var mostraAlert = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.94, green: 0.95, blue: 0.97).ignoresSafeArea()
                
                VStack(spacing: 0) {
                    ScrollView {
                        VStack(spacing: 25) {
                            Text("Modalità di smaltimento")
                                .font(.system(size: 30, weight: .bold))
                                .foregroundColor(.black)
                                .padding(.top, 40)
                            
                            // --- SEZIONE OPZIONI ---
                            VStack(spacing: 15) {
                                ForEach(DeliveryOption.allCases, id: \.self) { option in
                                    Button(action: {
                                        withAnimation(.spring()) {
                                            opzioneScelta = option
                                            if option != .locker, option != .safeZone {
                                                lockerInfo = ""
                                            }
                                        }
                                    }) {
                                        HStack {
                                            Image(systemName: opzioneScelta == option ? "checkmark.circle.fill" : "circle")
                                                .resizable()
                                                .frame(width: 28, height: 28)
                                                .foregroundColor(opzioneScelta == option ? .blue : .gray)
                                            
                                            Text(option.rawValue)
                                                .font(.title3)
                                                .fontWeight(.medium)
                                                .foregroundColor(.black)
                                            
                                            Spacer()
                                        }
                                        .padding()
                                        .frame(height: 70)
                                        .background(Color.white)
                                        .cornerRadius(15)
                                        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 15)
                                                .stroke(opzioneScelta == option ? Color.blue : Color.clear, lineWidth: 2)
                                        )
                                    }
                                }
                            }
                            .padding(.horizontal)
                            
                            if opzioneScelta == .locker || opzioneScelta == .safeZone {
                                mapViewButton.transition(.opacity)
                            }
                        }
                    }
                    
                    // --- AREA BOTTONI IN BASSO ---
                    VStack(spacing: 15) {
                        Button(action: {
                            messaggioConferma = "Oggetto aggiunto con successo all'Archivio Ricordi!"
                            mostraAlert = true
                        }) {
                            HStack {
                                Image(systemName: "archivebox.fill")
                                Text("Aggiungi all'Archivio Ricordi")
                            }
                            .font(.headline)
                            .foregroundColor(.blue)
                        }
                        
                        Button(action: {
                            // Avviamo la logica di conferma stile "tendina"
                            withAnimation {
                                mostraConfermaOverlay = true
                            }
                        }) {
                            Text("CONFERMA SMALTIMENTO")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 60)
                                .background(isFormValid ? Color.blue : Color.gray.opacity(0.5))
                                .cornerRadius(15)
                                .shadow(radius: 5)
                        }
                        .disabled(!isFormValid)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                    .padding(.top, 10)
                }
            }
            .navigationTitle("")
            // TENDINA QR CODE / CONFERMA
            .fullScreenCover(isPresented: $mostraConfermaOverlay) {
                schermataConfermaSmaltimento
            }
            // NAVIGAZIONE
            .navigationDestination(isPresented: $vaiAQRCodes) {
                QRCodes()
            }
            .navigationDestination(isPresented: $vaiAlMenu) {
                MainMenu(username: "Admin")
            }
            .alert("Info", isPresented: $mostraAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                if let msg = messaggioConferma { Text(msg) }
            }
        }
    }
    
    // --- SCHERMATA TEMPORANEA (Tendina) ---
    var schermataConfermaSmaltimento: some View {
        VStack(spacing: 30) {
            Spacer()
            
            if opzioneScelta == .locker {
                Text("Locker Prenotato!").font(.title).bold()
                
                Image(systemName: "qrcode")
                    .resizable().scaledToFit()
                    .frame(width: 200, height: 200)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(radius: 10)
                
                VStack(spacing: 5) {
                    Text("CODICE DEPOSITO").font(.caption2).foregroundColor(.secondary)
                    Text(codiceTemporaneo).font(.system(size: 32, weight: .black, design: .monospaced))
                }
                
                VStack(spacing: 15) {
                    Text("Istruzioni Deposito").font(.headline)
                    Text("Recati al locker scelto e scansiona il codice per aprire la cella.").font(.subheadline).multilineTextAlignment(.center).padding(.horizontal)
                }
            } else {
                Image(systemName: "checkmark.seal.fill")
                    .resizable().frame(width: 100, height: 100).foregroundColor(.green)
                Text("Richiesta Confermata!").font(.largeTitle).bold()
                Text("Segui le istruzioni per il metodo scelto.")
                    .font(.body).multilineTextAlignment(.center).padding(.horizontal)
            }
            
            Spacer()
        }
        .background(Color(red: 0.94, green: 0.95, blue: 0.97).ignoresSafeArea())
        .onAppear {
            // Sparisce dopo 3 secondi e naviga
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                mostraConfermaOverlay = false
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    if opzioneScelta == .locker {
                        vaiAQRCodes = true
                    } else {
                        vaiAlMenu = true
                    }
                }
            }
        }
    }
    
    var isFormValid: Bool {
        guard let option = opzioneScelta else { return false }
        if option == .locker || option == .safeZone {
            return !lockerInfo.isEmpty
        }
        return true
    }
    
    var mapViewButton: some View {
        Button(action: { mostraMappa = true }) {
            HStack(spacing: 15) {
                Image(systemName: opzioneScelta == .locker ? "cube.box.fill" : "map.fill")
                    .font(.title2)
                VStack(alignment: .leading, spacing: 2) {
                    Text(lockerInfo.isEmpty ? (opzioneScelta == .locker ? "Cerca Locker su Mappe..." : "Scegli sulla mappa...") : "Posizione Selezionata")
                        .fontWeight(.semibold)
                    if !lockerInfo.isEmpty {
                        Text(lockerInfo).font(.caption).lineLimit(1)
                    }
                }
                Spacer()
                Image(systemName: "arrow.up.right.square")
            }
            .padding().frame(minHeight: 60)
            .background(Color.blue.opacity(0.1)).cornerRadius(12)
            .foregroundColor(.blue)
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.blue.opacity(0.3), lineWidth: 1))
        }
        .padding(.horizontal)
        .fullScreenCover(isPresented: $mostraMappa) {
            if let option = opzioneScelta {
                MappaSimulataView(option: option, lockerSelezionato: $lockerInfo)
            }
        }
    }
}
