int screenX;
int screenY;
int mode;
float dt;
String[] MODES;
ArrayList<Tronic> tronics;
ArrayList<Wire> wires;
ArrayList<QueuedWrapper> events;
Tronic dragTronic;
MouseWire wireStart;
MenuDisplay menu;
DataEntry dataEntry;
boolean shiftDown;
boolean ctrlDown;

void setup(){
    size(800,600,P2D);
    surface.setResizable(true);
    println("Loaded.");
    screenX = 0;
    screenY = 0;
    mode = 0;
    dt = 0;
    shiftDown = false;
    ctrlDown = false;
    MODES = new String[]{"EDIT", "COMPUTE", "WIRE"};
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
    if(key == 'r'){
        screenX = 0;
        screenY = 0;
    }else if(key == ' '){
        mode = (mode + 1) % 2;
        menu.deselectAll();
    }else if(key == 'q'){
        Button newTronic = new Button((int)random(0,4), screenX + mouseX - 24, screenY + mouseY - 24);
        tronics.add(newTronic);
    }else if(key == 'e'){
        OperatorTronic newTronic = new OperatorTronic((int)random(0,4), screenX + mouseX - 24, screenY + mouseY - 24);
        tronics.add(newTronic);
    }else if(key == 'z'){
        Data newTronic = new Data(screenX + mouseX - 24, screenY + mouseY - 24);
        newTronic.setData(Float.toString(random(1,3)));
        tronics.add(newTronic);
    }else if(keyCode == SHIFT){
        shiftDown = true;
    }else if(keyCode == CONTROL){
        ctrlDown = true;
    }
}

void keyReleased(){
    if(keyCode == SHIFT){
        shiftDown = false;
    }else if(keyCode == CONTROL){
        ctrlDown = false;
    }
}
    

void mousePressed(){
    if(mouseButton == LEFT && mode == 0){
        if(menu.getSelected().size() > 0){
            int mouseIndex = menu.containsPoint(mouseX + screenX, mouseY + screenY);
            MenuDisplay.MenuItem[] items = menu.getItems();
            if(mouseIndex >= 0 && items.length > mouseIndex){
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
            if(screenX + mouseX < (tron.getX() + tron.getWidth()) && screenX + mouseX > tron.getX() && screenY + mouseY < (tron.getY() + tron.getHeight()) && screenY + mouseY > tron.getY()){
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
                if(screenX + mouseX < (tron.getX() + tron.getWidth()) && screenX + mouseX > tron.getX() && screenY + mouseY < (tron.getY() + tron.getHeight()) && screenY + mouseY > tron.getY()){
                    ((Clickable) tron).clicked(mouseX, mouseY);
                }
            }else if(tron instanceof Data){
                if(screenX + mouseX < (tron.getX() + tron.getWidth()) && screenX + mouseX > tron.getX() && screenY + mouseY < (tron.getY() + tron.getHeight()) && screenY + mouseY > tron.getY()){
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
                tron.moveTronic((screenX + mouseX - 24) - (screenX + mouseX - 24) % 8 + relX, (screenY + mouseY - 24) - (screenY + mouseY - 24) % 8 + relY);
            }
        }
        dragTronic.moveTronic((screenX + mouseX - 24) - (screenX + mouseX - 24) % 8, (screenY + mouseY - 24) - (screenY + mouseY - 24) % 8);
    }
    menu.renderHighlights(dt, screenX, screenY);
    fill(#FF0000);
    strokeWeight(0);
    if(dataEntry.getTronic() != null){
        rect(dataEntry.getTronic().getX() - 2, dataEntry.getTronic().getY() - 2, dataEntry.getTronic().getWidth() + 4, dataEntry.getTronic().getHeight() + 4);
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
    
    if(mode == 0 && dragTronic == null){
        menu.renderMenu(screenX, screenY, mouseX, mouseY);
    }
    
    for(int i = 0; i < events.size(); i++){
        if(events.get(i).tick(1.0 / frameRate)){
            events.remove(i);
            i--;
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
}