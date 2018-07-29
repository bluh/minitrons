class Wire{
    Node firstNode;
    Tronic firstTronic;
    Node lastNode;
    Tronic lastTronic;
    color wireColor;
    int pending;
    
    public Wire(Node firstNode, Node lastNode, color wireColor){
        this.firstNode = firstNode;
        this.firstTronic = firstNode.getParent();
        this.lastNode = lastNode;
        this.lastTronic = lastNode.getParent();
        this.wireColor = wireColor;
    }
    
    public void render(int screenX, int screenY){
        render(screenX, screenY, wireColor);
    }
    
    public void render(int screenX, int screenY, color thisColor){
        stroke(thisColor);
        strokeCap(SQUARE);
        noFill();
        int tronicX1 = firstTronic.getX() - screenX;
        int tronicY1 = firstTronic.getY() - screenY;
        int pointX1 = firstNode.getX() + 3;
        int pointY1 = firstNode.getY() + 3;
        int tronicX2 = lastTronic.getX() - screenX;
        int tronicY2 = lastTronic.getY() - screenY;
        int pointX2 = lastNode.getX() + 3;
        int pointY2 = lastNode.getY() + 3;
        int distance = (int) sqrt(pow((tronicX1 + pointX1) - (tronicX2 + pointX2),2) + pow((tronicY1 + pointY1) - (tronicY2 + pointY2),2)) / 2;
        int dirX1 = firstNode.getDirX() * distance;
        int dirY1 = firstNode.getDirY() * distance;
        int dirX2 = lastNode.getDirX() * distance;
        int dirY2 = lastNode.getDirY() * distance;
        bezier(tronicX1 + pointX1, tronicY1 + pointY1, tronicX1 + pointX1 + dirX1, tronicY1 + pointY1 + dirY1, tronicX2 + pointX2 + dirX2, tronicY2 + pointY2 + dirY2, tronicX2 + pointX2, tronicY2 + pointY2);
    }
    
    public Node getOtherNode(Node thisNode){
        if(thisNode.equals(firstNode)){
            return lastNode;
        }else if(thisNode.equals(lastNode)){
            return firstNode;
        }
        return null;
    }
    
    public void addPending(){
        pending++;
    }
    
    public void subPending(){
        pending--;
    }
    
    public boolean getActivated(){
        return pending > 0;
    }
    
    public color getWireColor(){
        return wireColor;
    }
    
    public void deleteWire(){
        firstNode.deleteWire(this);
        lastNode.deleteWire(this);
    }
}

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
        }else if((type1 == 5 && type2 == 6) || (type1 == 6 && type2 == 5)){ //chainin -> chainout || chainout -> chainin
            return firstPoint.getNumWires() == 0 && nextPoint.getNumWires() == 0;
        }
        return false; //yeah!!! FUCK 'EM!!!
    }
    
    public Node getFirstPoint(){
        return firstPoint;
    }
}
