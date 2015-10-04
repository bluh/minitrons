int screenX;
int screenY;

void setup(){
    size(800,600,P2D);
    surface.setResizable(true);
    print("Loaded.");
    screenX = 0;
    screenY = 0;
}

void keyPressed(){
    if(key == ' '){
        screenX = 0;
        screenY = 0;
    }
}

void draw(){
    background(#FFFFFF);
    if(mousePressed && mouseButton == RIGHT){
        screenX += pmouseX - mouseX;
        screenY += pmouseY - mouseY;
    }
    fill(#000000);
    stroke(#000000);
    for(int x = -screenX % 15; x < width; x += 16){
        line(x,0,x,height);
    }
    for(int y = -screenY % 15; y < height; y += 16){
        line(0, y, width, y);
    }
    stroke(#404040);
    fill(#606060);
    rect(0,height - 16, width - 1, height);
    fill(#FFFFFF);
    text("(" + screenX + ", " + screenY + ")", 4, height - 4); 
}