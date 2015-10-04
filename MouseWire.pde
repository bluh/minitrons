class MouseWire{
    Node firstPoint;
    Tronic firstTronic;
    color wireColor;
    
    public MouseWire(Node firstPoint, color wireColor){
        this.firstPoint = firstPoint;
        this.firstTronic = firstPoint.getParent();
        this.wireColor = wireColor;
    }
    
    public void render(int mouseX, int mouseY, int screenX, int screenY){
        stroke(wireColor);
        strokeWeight(6);
        strokeCap(SQUARE);
        noFill();
        int tronicX = firstTronic.getX() - screenX;
        int tronicY = firstTronic.getY() - screenY;
        int pointX = firstPoint.getX() + 3;
        int pointY = firstPoint.getY() + 3;
        int distance = (int) sqrt(pow((tronicX + pointX) - mouseX,2) + pow((tronicY + pointY) - mouseY,2)) / 2; 
        int dirX = firstPoint.getDirX() * distance;
        int dirY = firstPoint.getDirY() * distance;
        bezier(tronicX + pointX, tronicY + pointY, tronicX + pointX + dirX, tronicY + pointY + dirY, mouseX - dirX + 3, mouseY - dirY + 3, mouseX + 3, mouseY + 3);
    }
    
    public boolean canConnectTo(Node nextPoint){
        return true; //yeah!!! FUCK 'EM!!!
    }
    
    public Node getFirstPoint(){
        return firstPoint;
    }
}