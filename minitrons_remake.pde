int screenX;
int screenY;
int mode;
ArrayList<Tronic> tronics;
Tronic dragTronic;

void setup(){
    size(800,600,P2D);
    surface.setResizable(true);
    println("Loaded.");
    screenX = 0;
    screenY = 0;
    mode = 0;
    tronics = new ArrayList<Tronic>();
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
                println("Clicked: " + tron);
                dragTronic = tron;
                return; //only get the first
            }
        }
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
    for(int x = -screenX % 15; x < width; x += 16){
        line(x,0,x,height);
    }
    for(int y = -screenY % 15; y < height; y += 16){
        line(0, y, width, y);
    }
    
    for(Tronic tron: tronics){
        tron.renderTronic(screenX, screenY);
    }
    
    stroke(#404040);
    fill(#606060);
    rect(0,height - 16, width - 1, height);
    fill(#FFFFFF);
    text("(" + screenX + ", " + screenY + ")", 4, height - 4); 
    text("MODE: " + ((mode == 0) ? "EDIT" : "COMPUTE") + "", 204, height - 4);
    text("TOTAL: " + tronics.size() + "", 404, height - 4);
}