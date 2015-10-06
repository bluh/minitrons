class Button extends Tronic implements Clickable{
    PImage sprite;
    boolean cooldown;
    
    Node outNode;
    
    public Button(int x, int y){
        this(0, x, y);
    }
    
    public Button(int type, int x, int y){
        super(x, y, 48, 48);
        switch(type){
            case 0:
                sprite = loadImage("assets/rbutton.png");
                break; //TODO: add more buttons
            default:
                sprite = loadImage("assets/rbutton.png");
                break;
        }
        cooldown = false;
        outNode = new Node(this, 3, 48, 21, 1, 0);
    }
    
    public void clicked(int x, int y){
        if(!cooldown){
            cooldown = true;
            sendFlow();
            addEvent(new QueuedEvent(){
                public double getDelay(){
                    return 1.0;
                }
                public void invoke(){
                    cooldown = false;
                }
            });
        }
    }
    
    public void sendFlow(){
        println("Sending flow.");
        if(outNode.getNumWires() > 0){
            outNode.getWire(0).activateWire(outNode);
        }
    }
    
    public void renderTronic(int screenX, int screenY){
        image(sprite, getX() - screenX, getY() - screenY);
    }
    
    public void renderNodes(int mouseX, int mouseY, int screenX, int screenY, boolean highlight){
        outNode.render(mouseX, mouseY, screenX, screenY, getX(), getY(), highlight);
    }
    
    public Node[] getNodes(){
        return new Node[]{outNode};
    }
}
        