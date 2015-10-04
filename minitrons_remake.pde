int screenX;
int screenY;
int mode;
String[] MODES;
ArrayList<Tronic> tronics;
ArrayList<Wire> wires;
Tronic dragTronic;
MouseWire wireStart;

void setup(){
    size(800,600,P2D);
    surface.setResizable(true);
    println("Loaded.");
    screenX = 0;
    screenY = 0;
    mode = 0;
    MODES = new String[]{"EDIT", "COMPUTE", "WIRE"};
    tronics = new ArrayList<Tronic>();
    wires = new ArrayList<Wire>();
}

void keyPressed(){
    if(key == 'r'){
        screenX = 0;
        screenY = 0;
    }else if(key == ' '){
        mode = (mode + 1) % 2;
    }else if(key == 'q'){
        Button newTronic = new Button(screenX + mouseX - 24, screenY + mouseY - 24);
        tronics.add(newTronic);
    }else if(key == 'e'){
        AddTronic newTronic = new AddTronic(screenX + mouseX - 24, screenY + mouseY - 24);
        tronics.add(newTronic);
    }
}

void mousePressed(){
    if(mode == 1){
        for(Tronic tron: tronics){
            if(tron instanceof Clickable){
                if(screenX + mouseX < (tron.getX() + tron.getWidth()) && screenX + mouseX > tron.getX() && screenY + mouseY < (tron.getY() + tron.getHeight()) && screenY + mouseY > tron.getY()){
                    ((Clickable)tron).clicked(mouseX, mouseY);
                }
            }
        }
    }else if(mode == 0){
        for(Tronic tron: tronics){
            if(screenX + mouseX < (tron.getX() + tron.getWidth()) && screenX + mouseX > tron.getX() && screenY + mouseY < (tron.getY() + tron.getHeight()) && screenY + mouseY > tron.getY()){
                //println("Clicked: " + tron);
                dragTronic = tron;
                return; //only get the first
            }
            for(Node node: tron.getNodes()){
                if(node.containsPoint(mouseX + screenX, mouseY + screenY, tron.getX(), tron.getY())){
                    println("Got node on " + tron + " : " + node);
                    mode = 2;
                    wireStart = new MouseWire(node, #000000);
                    return;
                }
            }
        }
    }else if(mode == 2 && wireStart != null){
        //wire time...
        for(Tronic tron: tronics){
            for(Node node: tron.getNodes()){
                if(node.containsPoint(mouseX + screenX, mouseY + screenY, tron.getX(), tron.getY())){
                    //make a wire connecting two nodes
                    println("Connecting to: " + node);
                    if(wireStart.canConnectTo(node)){
                        println("Compatable!");
                        Wire newWire = new Wire(wireStart.getFirstPoint(), node, #00FF00);
                        wires.add(newWire);
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
        dragTronic.moveTronic(screenX + mouseX - 24, screenY + mouseY - 24);
        dragTronic = null;
    }
}

void draw(){
    background(#FFFFFF);
    if(mousePressed && mouseButton == RIGHT){
        screenX += pmouseX - mouseX;
        screenY += pmouseY - mouseY;
    }
    if(dragTronic != null){
        dragTronic.moveTronic(screenX + mouseX - 24, screenY + mouseY - 24);
    }
    fill(#000000);
    stroke(#000000);
    strokeWeight(1);
    for(int x = -screenX % 15; x < width; x += 16){
        line(x,0,x,height);
    }
    for(int y = -screenY % 15; y < height; y += 16){
        line(0, y, width, y);
    }
    
    for(Tronic tron: tronics){
        tron.renderTronic(screenX, screenY);
        tron.renderNodes(screenX + mouseX, screenY + mouseY, screenX, screenY, (mode != 1));
    }
    for(Wire wire: wires){
        wire.render(screenX, screenY);
    }
    if(mode == 2 && wireStart != null){
        wireStart.render(mouseX, mouseY, screenX, screenY);
    }
        
    
    stroke(#404040);
    fill(#606060);
    rect(0,height - 16, width - 1, 16);
    fill(#FFFFFF);
    text("(" + screenX + ", " + screenY + ")", 4, height - 4); 
    text("MODE: " + MODES[mode] + "", 204, height - 4);
    text("TOTAL: " + tronics.size() + "", 404, height - 4);
}