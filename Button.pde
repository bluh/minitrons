class Button extends Tronic implements Clickable{
    PImage sprite;
    boolean cooldown;
    
    Node outNode;
    
    public Button(int x, int y, String name){
        this(0, x, y, name);
    }
    
    public Button(int type, int x, int y, String name){
        super(x, y, 48, 48, name);
        switch(type){
            case 0:
                sprite = loadImage("assets/rbutton.png");
                break;
            case 1:
                sprite = loadImage("assets/gbutton.png");
                break;
            case 2:
                sprite = loadImage("assets/ybutton.png");
                break;
            case 3:
                sprite = loadImage("assets/bbutton.png");
                break;
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
        