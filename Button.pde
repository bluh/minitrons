class Button extends Tronic implements Clickable{
    int type;
    PImage sprite;
    boolean cooldown;
    
    Node outNode;
    
    public Button(int x, int y, String name){
        this(0, x, y, name);
    }
    
    public Button(int type, int x, int y, String name){
        super(x, y, 48, 48, name);
        this.type = type;
        switch(type){
            case 0:
                sprite = loadImage("assets/ybutton.png");
                break;
            case 1:
                sprite = loadImage("assets/bbutton.png");
                break;
            case 2:
                sprite = loadImage("assets/gbutton.png");
                break;
            case 3:
                sprite = loadImage("assets/rbutton.png");
                break;
            default:
                sprite = loadImage("assets/ybutton.png");
                break;
        }
        cooldown = false;
        outNode = new Node(this, 3, 48, 21, 1, 0);
    }
    
    public void clicked(int x, int y, float zoom){
        if(!cooldown){
            cooldown = true;
            sendFlow();
            addEvent(new QueuedEvent(){
                public double getDelay(){
                    return 0.5;
                }
                public void invoke(){
                    cooldown = false;
                }
            });
        }
    }
    
    public void sendFlow(){
        if(isEnabled()){
            startFlow(outNode, this, new FlowDetails());
        }
    }
    
    
    public int getType(){
        return type;
    }
    public void renderTronic(int screenX, int screenY){
        image(sprite, (getX() - screenX) * 2, (getY() - screenY) * 2);
    }
    
    public void renderNodes(int mouseX, int mouseY, int screenX, int screenY, float zoom, boolean highlight){
        outNode.render(mouseX, mouseY, screenX, screenY, getX(), getY(), zoom, highlight);
    }
    
    public Node[] getNodes(){
        return new Node[]{outNode};
    }
}
        