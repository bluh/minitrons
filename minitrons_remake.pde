int screenX;
int screenY;
int mode;
int tronicsId;
float dt;
float mouseTime;
String[] MODES;
String messageText;
String fileName;
ArrayList<Tronic> tronics;
ArrayList<Wire> wires;
ArrayList<QueuedWrapper> events;
Tronic dragTronic;
MouseWire wireStart;
MenuDisplay menu;
DataEntry dataEntry;
boolean shiftDown;
boolean ctrlDown;
boolean altDown;

void setup(){
    size(800,600,P2D);
    surface.setResizable(true);
    textFont(loadFont("neverfont8.vlw"),8);
    println("Loaded.");
    screenX = 0;
    screenY = 0;
    mode = 0;
    dt = 0;
    mouseTime = 0;
    tronicsId = 0;
    shiftDown = false;
    ctrlDown = false;
    altDown = false;
    MODES = new String[]{"EDIT", "COMPUTE", "WIRE", "FILE"};
    messageText = "NEW FILE";
    fileName = "";
    tronics = new ArrayList<Tronic>();
    wires = new ArrayList<Wire>();
    events = new ArrayList<QueuedWrapper>();
    menu = new MenuDisplay();
    dataEntry = new DataEntry();
    dataEntry.addWindowListener(new java.awt.event.WindowListener() {
       public void windowOpened(java.awt.event.WindowEvent e) {}
       public void windowIconified(java.awt.event.WindowEvent e) {}
       public void windowDeiconified(java.awt.event.WindowEvent e) {}
       public void windowDeactivated(java.awt.event.WindowEvent e) {}
       public void windowClosing(java.awt.event.WindowEvent e) {
           dataEntry.setVisible(false);
           dataEntry.setTronic(null);
       }
       public void windowClosed(java.awt.event.WindowEvent e) {}
       public void windowActivated(java.awt.event.WindowEvent e) {}
    });
}

void keyPressed(){
    mouseTime = 0;
    //println(keyCode);
    if(key == 'r'){
        screenX = 0;
        screenY = 0;
    }else if(key == ' '){
        mode = (mode + 1) % 2;
        menu.deselectAll();
    }else if(key == 'c'){
        menu.deselectAll();
        tronics.clear();
        wires.clear();
    }else if(key == 'q' && mode == 0){
        tronicsId++;
        Button newTronic = new Button((int)random(0,4), screenX + mouseX - 24, screenY + mouseY - 24,"Button"+tronicsId);
        tronics.add(newTronic);
    }else if(key == 'w' && mode == 0){
        tronicsId++;
        Keyboard newTronic = new Keyboard(screenX + mouseX - 48, screenY + mouseY - 24, "Keboard"+tronicsId);
        tronics.add(newTronic);
    }else if(key == 'e' && mode == 0){
        tronicsId++;
        OperatorTronic newTronic = new OperatorTronic((int)random(0,5), screenX + mouseX - 24, screenY + mouseY - 24,"Operator"+tronicsId);
        tronics.add(newTronic);
    }else if(key == 'z' && mode == 0){
        tronicsId++;
        Data newTronic = new Data(screenX + mouseX - 24, screenY + mouseY - 24,"Data"+tronicsId);
        newTronic.setData(Float.toString(random(1,3)));
        tronics.add(newTronic);
    }else if(key == 'x' && mode == 0){
        tronicsId++;
        Monitor newTronic = new Monitor(screenX + mouseX - 128, screenY + mouseY - 112,"Monitor"+tronicsId);
        tronics.add(newTronic);
    }else if((keyCode == 83 || key == 's') && ctrlDown && mode == 0){
        messageText = "SAVING...";
        mode = 3;
        menu.deselectAll();
        new SmallTextEntry(fileName, new SmallTextEntryEvent(){
            public void canceled(){
                messageText = "SAVING CANCELED.";
                mode = 0;
            }
            
            public void saved(String contents){
                if(!contents.equals("")){
                    JSONArray output = new JSONArray();
                    JSONArray tronicsOutput = new JSONArray();
                    int objs = 0;
                    HashMap<Wire, Integer[]> wireDetails = new HashMap<Wire, Integer[]>();
                    messageText = "SAVING... (TRONICS)";
                    for(Tronic tron: tronics){
                        JSONObject tronObj = new JSONObject();
                        tronObj.setString("type", tron.getClass().getSimpleName());
                        tronObj.setString("name", tron.toString());
                        tronObj.setInt("objIndex", objs);
                        tronObj.setInt("posX", tron.getX());
                        tronObj.setInt("posY", tron.getY());
                        if(tron instanceof Button){
                            tronObj.setInt("buttonType", ((Button)tron).getType());
                        }else if(tron instanceof Data){
                            tronObj.setString("dataContents", ((Data)tron).getData());
                        }else if(tron instanceof OperatorTronic){
                            tronObj.setInt("operatorType", ((OperatorTronic)tron).getType());
                        }else if(tron instanceof Monitor){
                            tronObj.setInt("monitorLineNumber", ((Monitor)tron).getTextLineNumber());
                            String[] text = ((Monitor)tron).getTextLines();
                            JSONArray textLines = new JSONArray();
                            for(int i = 0; i < text.length; i++){
                                textLines.setString(i, text[i]);
                            }
                            tronObj.setJSONArray("monitorLines", textLines);
                        }
                        for(int n = 0; n < tron.getNodes().length; n++){
                            for(int w = 0; w < tron.getNodes()[n].getNumWires(); w++){
                                Wire wire = tron.getNodes()[n].getWire(w);
                                if(!wireDetails.containsKey(wire)){
                                    wireDetails.put(wire, new Integer[] {objs, n});
                                }else if(wireDetails.containsKey(wire)){
                                    int t1Id = wireDetails.get(wire)[0];
                                    int t1node = wireDetails.get(wire)[1];
                                    wireDetails.put(wire, new Integer[] {t1Id, t1node, objs, n, wire.getWireColor()});
                                }
                            }
                        }
                        tronicsOutput.setJSONObject(objs, tronObj);
                        objs++;
                    }
                    messageText = "SAVING... (WIRES)";
                    JSONArray wiresOutput = new JSONArray();
                    int wires = 0;
                    for(Integer[] dets: wireDetails.values()){
                        if(dets.length == 5){
                            JSONArray thisSet = new JSONArray();
                            for(int i = 0; i < dets.length; i++){
                                thisSet.setInt(i, dets[i]);
                            }
                            wiresOutput.setJSONArray(wires, thisSet);
                            wires++;
                        }else{
                            println("Invalid wire array?");
                        }
                    }
                    output.setJSONArray(0, tronicsOutput);
                    output.setJSONArray(1, wiresOutput);
                    saveJSONArray(output, "/saves/" + contents + ".json");
                    messageText = "SAVED";
                    fileName = contents;
                    mode = 0;
                }else{
                    messageText = "SAVING CANCELED";
                    mode = 0;
                }
            }
        }).showWindow();
        
    }else if((keyCode == 79 || key == 'o') && ctrlDown && mode == 0){
        messageText = "LOADING...";
        mode = 3;
        menu.deselectAll();
        new SmallTextEntry(fileName, "Load", new SmallTextEntryEvent(){
            public void canceled(){
                messageText = "LOADING CANCELED.";
                mode = 0;
            }
            
            public void saved(String contents){
                if(!contents.equals("")){
                    JSONArray input = null;
                    try{
                        input = loadJSONArray("/saves/" + contents + ".json");
                    }catch(Exception e){
                        messageText = "FILE DOES NOT EXIST";
                        mode = 0;
                        return;
                    }
                    JSONArray tronicsInput = input.getJSONArray(0);
                    JSONArray wiresInput = input.getJSONArray(1);
                    HashMap<Integer, Tronic> tronicDetails = new HashMap<Integer, Tronic>();
                    tronicsId = 0;
                    messageText = "LOADING... (TRONICS)";
                    for(int i = 0; i < tronicsInput.size(); i++){
                        JSONObject tronObj = tronicsInput.getJSONObject(i);
                        Tronic newTronic = null;
                        if(tronObj.getString("type").equals("Button")){
                            newTronic = new Button(tronObj.getInt("buttonType"), tronObj.getInt("posX"), tronObj.getInt("posY"), tronObj.getString("name"));
                        }else if(tronObj.getString("type").equals("Data")){
                            newTronic = new Data(tronObj.getInt("posX"), tronObj.getInt("posY"), tronObj.getString("name"));
                            ((Data)newTronic).setData(tronObj.getString("dataContents"));
                        }else if(tronObj.getString("type").equals("OperatorTronic")){
                            newTronic = new OperatorTronic(tronObj.getInt("operatorType"), tronObj.getInt("posX"), tronObj.getInt("posY"), tronObj.getString("name"));
                        }else if(tronObj.getString("type").equals("Monitor")){
                            newTronic = new Monitor(tronObj.getInt("posX"), tronObj.getInt("posY"), tronObj.getString("name"));
                            JSONArray lines = tronObj.getJSONArray("monitorLines");
                            for(int x = 0; x < tronObj.getInt("monitorLineNumber"); x++){
                                ((Monitor)newTronic).processString(lines.getString(x));
                            }
                        }
                        tronics.add(newTronic);
                        tronicDetails.put(tronObj.getInt("objIndex"), newTronic);
                        tronicsId++;
                    }
                    messageText = "LOADING... (WIRES)";
                    for(int i = 0; i < wiresInput.size(); i++){
                        JSONArray thisWire = wiresInput.getJSONArray(i);
                        Tronic tron1 = tronicDetails.get(thisWire.getInt(0));
                        Tronic tron2 = tronicDetails.get(thisWire.getInt(2));
                        Wire newWire = new Wire(tron1.getNodes()[thisWire.getInt(1)],tron2.getNodes()[thisWire.getInt(3)], thisWire.getInt(4));
                        wires.add(newWire);
                        tron1.getNodes()[thisWire.getInt(1)].addWire(newWire);
                        tron2.getNodes()[thisWire.getInt(3)].addWire(newWire);
                    }
                    messageText = "LOADED";
                    mode = 0;
                }else{
                    messageText = "LOADING CANCELED";
                    mode = 0;
                }
            }
        }).showWindow();
    }else if(keyCode == SHIFT){
        shiftDown = true;
    }else if(keyCode == CONTROL){
        ctrlDown = true;
    }else if(keyCode == ALT){
        altDown = true;
    }
}

void keyReleased(){
    if(keyCode == SHIFT){
        shiftDown = false;
    }else if(keyCode == CONTROL){
        ctrlDown = false;
    }else if(keyCode == ALT){
        altDown = false;
    }
}
    

void mousePressed(){
    mouseTime = 0;
    if(mouseButton == LEFT && mode == 0){
        if(menu.getSelected().size() > 0){
            int mouseIndex = menu.containsPoint(mouseX + screenX, mouseY + screenY);
            MenuDisplay.MenuItem[] items = menu.getItems();
            if(!altDown && mouseIndex >= 0 && items.length > mouseIndex){
                String action = items[mouseIndex].getAction();
                if(action == "DESELECT"){
                    menu.deselectAll();
                    return;
                }else if(action == "MOVE"){
                    dragTronic = menu.getSelected().get(0);
                    return;
                }else if(action == "DELETE"){
                    for(Tronic tron: menu.getSelected()){
                        //tron.deleteTronic();
                        if(dataEntry.getTronic() == tron){
                            dataEntry.setTronic(null);
                        }
                        for(Node node: tron.getNodes()){
                            while(node.getNumWires() > 0){
                                wires.remove(node.getWire(0));
                                node.getWire(0).deleteWire();
                            }
                        }
                        tronics.remove(tron);
                    }
                    menu.deselectAll();
                }else if(action == "DECOUPLE"){
                    for(Wire wire: menu.getWires()){
                        wire.deleteWire();
                        wires.remove(wire);
                    }
                }else if(action == "DATAENTRY"){
                    if(menu.getSelected().get(0) instanceof Data){
                        dataEntry.setTronic((Data)menu.getSelected().get(0));
                        dataEntry.showWindow();
                    }
                }else if(action == "RENAME"){
                    String ref = "";
                    if(menu.getSelected().size() == 1){
                        ref = menu.getSelected().get(0).toString();
                    }
                    new SmallTextEntry(ref,new SmallTextEntryEvent(){
                        public void canceled(){
                            //sucks to suck
                            menu.deselectAll();
                        }
                        
                        public void saved(String contents){
                            if(!contents.equals("")){
                                for(Tronic tron: menu.getSelected()){
                                    tron.setName(contents);
                                    menu.deselectAll();
                                }
                            }
                        }
                    }).showWindow();
                    return;
                }
            }
        }
        for(Tronic tron: tronics){
            for(Node node: tron.getNodes()){
                if(node.containsPoint(mouseX + screenX, mouseY + screenY, tron.getX(), tron.getY())){
                    mode = 2;
                    wireStart = new MouseWire(node, node.getNodeColor());
                    return;
                }
            }
            if(tron.containsPoint(screenX + mouseX, screenY + mouseY)){
                if(ctrlDown){
                    if(!menu.contains(tron)){
                        menu.deselectAll();
                    }
                    dragTronic = tron;
                }else if(shiftDown){
                    menu.toggle(tron);
                }else{
                    menu.deselectAll();
                    menu.toggle(tron);
                }
                return;
            }
        }
        menu.deselectAll(); //deselect if they clicked nothing
    }else if(mode == 1){
        for(Tronic tron: tronics){
            if(tron instanceof Clickable){
                if(tron.containsPoint(screenX + mouseX, screenY + mouseY)){
                    ((Clickable) tron).clicked(mouseX, mouseY);
                }
            }else if(tron instanceof Data){
                if(tron.containsPoint(screenX + mouseX, screenY + mouseY)){
                    println("Data: " + ((Data) tron).getData());
                }
            }
        }
    }else if(mode == 2 && wireStart != null){
        //wire time...
        for(Tronic tron: tronics){
            for(Node node: tron.getNodes()){
                if(node.containsPoint(mouseX + screenX, mouseY + screenY, tron.getX(), tron.getY())){
                    //make a wire connecting two nodes
                    if(wireStart.canConnectTo(node)){
                        color wireColor = #FF0000;
                        if(wireStart.getFirstPoint().getType() == 3 || node.getType() == 3){
                            wireColor = #FF0000;
                        }else if(wireStart.getFirstPoint().getType() == 0 || node.getType() == 0){
                            wireColor = #0000FF;
                        }else if(wireStart.getFirstPoint().getType() == 1 || node.getType() == 1){
                            wireColor = #00FF00;
                        }
                        Wire newWire = new Wire(wireStart.getFirstPoint(), node, wireColor);
                        wires.add(newWire);
                        wireStart.getFirstPoint().addWire(newWire);
                        node.addWire(newWire);
                        menu.selectWires();
                    }
                    mode = 0;
                    return;
                }
            }
        }
        mode = 0;
    }
}

void mouseReleased(){
    if(dragTronic != null){
        menu.calculatePosition();
        dragTronic = null;
    }
}

void addEvent(QueuedEvent evt){
    events.add(new QueuedWrapper(evt));
}

void draw(){
    dt += (1.0/frameRate) % 2.5;
    background(#E5E5E5);
    if(mousePressed && mouseButton == RIGHT){
        screenX += pmouseX - mouseX;
        screenY += pmouseY - mouseY;
    }
    if(dragTronic != null){
        for(Tronic tron: menu.getSelected()){
            if(tron != dragTronic){
                int relX = tron.getX() - dragTronic.getX();
                int relY = tron.getY() - dragTronic.getY();
                tron.moveTronic((screenX + mouseX - dragTronic.getWidth() / 2) - (screenX + mouseX - dragTronic.getWidth() / 2) % 8 + relX, (screenY + mouseY - dragTronic.getHeight() / 2) - (screenY + mouseY - dragTronic.getHeight() / 2) % 8 + relY);
            }
        }
        dragTronic.moveTronic((screenX + mouseX - dragTronic.getWidth() / 2) - (screenX + mouseX - dragTronic.getWidth() / 2) % 8, (screenY + mouseY - dragTronic.getHeight() / 2) - (screenY + mouseY - dragTronic.getHeight() / 2) % 8);
    }
    menu.renderHighlights(dt, screenX, screenY);
    fill(#FF0000);
    strokeWeight(0);
    if(dataEntry.getTronic() != null){
        rect(dataEntry.getTronic().getX() - 2 - screenX, dataEntry.getTronic().getY() - 2 - screenY, dataEntry.getTronic().getWidth() + 4, dataEntry.getTronic().getHeight() + 4);
    }
    fill(#000000);
    stroke(#000000);
    strokeWeight(1);
    for(int x = -screenX % 16; x < width; x += 16){
        line(x,0,x,height);
    }
    for(int y = -screenY % 16; y < height; y += 16){
        line(0, y, width, y);
    }
    
    strokeWeight(6);
    for(Wire wire: wires){
        wire.render(screenX, screenY, (wire.getActivated() ? #FFFFFF : wire.getWireColor()));
    }
    if(mode == 2 && wireStart != null){
        wireStart.render(mouseX, mouseY, screenX, screenY);
    }
    for(int i = tronics.size() - 1; i >= 0; i--){
        tronics.get(i).renderTronic(screenX, screenY);
        tronics.get(i).renderNodes(screenX + mouseX, screenY + mouseY, screenX, screenY, (mode != 1));
    }
    
    if(mode == 0 && dragTronic == null && !altDown){
        menu.renderMenu(screenX, screenY, mouseX, mouseY);
    }
    
    for(int i = 0; i < events.size(); i++){
        if(events.get(i).tick(1.0 / frameRate)){
            events.remove(i);
            i--;
        }
    }
    if(pmouseX == mouseX && pmouseY == mouseY){
        if(mouseTime < .5){
            mouseTime += (1.0/frameRate);
        }
    }else{
        mouseTime = 0;
    }
    if(mouseTime > .5){
        for(Tronic tron: tronics){
            if(tron.containsPoint(mouseX + screenX, mouseY + screenY)){
                noStroke();
                fill(#FFFFFF, 200);
                rect(mouseX + 10, mouseY - 10, textWidth("Name: " + tron) + 4, 12);
                fill(#000000);
                text("Name: " + tron, mouseX + 13, mouseY);
                break;
            }
        }
    }
    
    stroke(#404040);
    strokeWeight(1);
    fill(#606060);
    rect(0,height - 16, width - 1, 16);
    fill(#FFFFFF);
    text("(" + screenX + ", " + screenY + ")", 4, height - 4); 
    text("MODE: " + MODES[mode] + "", 204, height - 4);
    text("TOTAL: " + tronics.size() + "", 404, height - 4);
    text(messageText, 604, height - 4);
}