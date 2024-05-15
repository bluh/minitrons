class Button extends Tronic implements Clickable{
    int type;
    boolean cooldown;
    char trigger;
    
    Node outNode;
    
    public Button(int x, int y, String name){
        this(0, x, y, name);
    }
    
    public Button(int type, int x, int y, String name){
        super(x, y, 48, 48, name);
        this.type = type;
        this.trigger = Integer.toString(type + 1).charAt(0);
        switch(type){
            case 0:
                setSprite(loadImage("assets/ybutton.png"));
                break;
            case 1:
                setSprite(loadImage("assets/bbutton.png"));
                break;
            case 2:
                setSprite(loadImage("assets/gbutton.png"));
                break;
            case 3:
                setSprite(loadImage("assets/rbutton.png"));
                break;
            case 4:
                setSprite(loadImage("assets/proxy.png"));
                break;
            default:
                setSprite(loadImage("assets/ybutton.png"));
                break;
        }
        cooldown = false;
        outNode = new Node(this, 3, 48, 21, 1, 0, "FlowOut");
    }
    
    public void clicked(int x, int y, float zoom){
        if(!cooldown){
            cooldown = true;
            sendFlow();
            if(type == 4){
                addCircle((int)(-screenX * zoom + (getX() + getWidth() * .5) * zoom),(int)(-screenY * zoom + (getY() + getHeight() * .5) * zoom), #000000, 100); 
            }
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

    public void setTrigger(char trig){
        this.trigger = Character.toUpperCase(trig);
        println("Set to " + trig);
    }

    public char getTrigger(){
        return this.trigger;
    }

    public void renderTronic(float dt){
        super.renderTronic(dt);
        push();
        
        fill(0, 150);
        textAlign(CENTER, CENTER);
        textSize(this.HEIGHT * 0.25);
        int x = (getX() - screenX);
        int y = (getY() - screenY);
        text(Character.toString(this.trigger), x, y, this.WIDTH, this.HEIGHT);
        
        pop();
    }
    
    public void mouseNearby(int x, int y, float zoom){
        if(type == 4 && mode == 1){
            clicked(x, y, zoom);
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
    
    public Node[] getNodes(){
        return new Node[]{outNode};
    }
}
