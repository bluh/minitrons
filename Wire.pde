class Wire{
    Node firstNode;
    Tronic firstTronic;
    Node lastNode;
    Tronic lastTronic;
    color wireColor;
    boolean activated;
    InFlow activatedEnd;
    
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
    
    public void activateWire(Node start){
        if(getOtherNode(start).getParent() instanceof InFlow){
            activated = true;
            activatedEnd = (InFlow)getOtherNode(start).getParent();
            addEvent(new QueuedEvent(){
                public double getDelay(){
                    return 0.25;
                }
                public void invoke(){
                    if(activatedEnd != null){ //TODO: bug where two wires are activated at once
                        activatedEnd.getFlow();
                        activatedEnd = null;
                        activated = false;
                    }
                }
            });
        }
    }
    
    public boolean getActivated(){
        return activated;
    }
    
    public color getWireColor(){
        return wireColor;
    }
    
    public void deleteWire(){
        firstNode.deleteWire(this);
        lastNode.deleteWire(this);
    }
}