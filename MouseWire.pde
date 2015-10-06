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
        int type1 = firstPoint.getType();
        int type2 = nextPoint.getType();
        println("Starting at: " + type1 + " node (" + firstPoint.getNumWires());
        println("Next at: " + type2 + " node (" + nextPoint.getNumWires());
        if(type1 == 3 && type2 == 2){ //flowout -> flowin
            return firstPoint.getNumWires() == 0;
        }else if(type1 == 2 && type2 == 3){ //flowin -> flowout
            return nextPoint.getNumWires() == 0;
        }else if(type1 == 0 && type2 == 4){ //dataout -> data
            for(int i = 0; i < firstPoint.getNumWires(); i++){
                if(firstPoint.getWire(i).getOtherNode(firstPoint) == nextPoint){
                    return false; //maybe... not so infinite
                }
            }
            return true; //infinite wires!!!!!!!!!! :-)
        }else if(type1 == 4 && type2 == 0){ //data -> dataout
            for(int i = 0; i < nextPoint.getNumWires(); i++){
                if(nextPoint.getWire(i).getOtherNode(nextPoint) == firstPoint){
                    return false;
                }
            }
            return true;
        }else if(type1 == 1 && type2 == 4){ //datain -> data
            return firstPoint.getNumWires() == 0;
        }else if(type1 == 4 && type2 == 1){ //data -> datain
            return nextPoint.getNumWires() == 0;
        }
        return false; //yeah!!! FUCK 'EM!!!
    }
    
    public Node getFirstPoint(){
        return firstPoint;
    }
}