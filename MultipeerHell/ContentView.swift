//
//  ContentView.swift
//  MultipeerHell
//
//  Created by Alex Cameron on 4/21/21.
//

import SwiftUI
import MultipeerConnectivity

struct ContentView: View {
    
    @State var backgroundColor = Color.gray
    @State var buttonColor = Color.blue
    @State var textColor = Color.black
    
    @ObservedObject var connect = Connect()
    
    let colors = [Color.gray, Color.blue, Color.black, Color.orange, Color.green, Color.white, Color.red, Color.yellow, Color.pink, Color.purple]
    
    func changeColor() {
        connect.numbers.shuffle()
        backgroundColor = colors[connect.numbers[0]]
        buttonColor = colors[connect.numbers[1]]
        textColor = colors[connect.numbers[2]]
        do {
            try connect.mcSession.send(JSONEncoder().encode(connect.numbers), toPeers: connect.mcSession.connectedPeers, with: .reliable)
        } catch {
        }
        
    }

    
    var body: some View {
        ZStack {
            backgroundColor.ignoresSafeArea()
            
            VStack {
                
                ForEach(connect.othersList) {other in
                    
                    if connect.connected.contains(other.mcid) {
                        
                        ZStack {
                            Rectangle()
                                .fill(colors[connect.colorConnection[other.mcid]![0]])
                                .frame(width:200, height: 200)
                                
                            
                            Button(other.mcid.displayName){
                                
                            }
                            .padding(.all)
                            .background(colors[connect.colorConnection[other.mcid]![1]])
                            .cornerRadius(20)
                            .foregroundColor(colors[connect.colorConnection[other.mcid]![2]])
                            .font(.headline)
                        }
                        
                    } else {
                        HStack{
                            Text(other.mcid.displayName)
                                .font(.largeTitle)
                                .foregroundColor(textColor)
                            Button("Connect"){
                                connect.connect(other.mcid)
                            }
                            .font(.caption)
                            .frame(width: 80, height: 40)
                            .background(buttonColor)
                            .cornerRadius(40)
                            .foregroundColor(textColor)
                            
                        }
                        .padding(.bottom)
                    }
                }
                
                Spacer()
                
                Button("Change Colors"){
                    changeColor()
                }
                .padding(.all)
                .background(buttonColor)
                .cornerRadius(20)
                .foregroundColor(textColor)
                .font(.headline)
                .padding(.bottom)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
