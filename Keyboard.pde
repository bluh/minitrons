class Keyboard extends Tronic implements Clickable{
    PImage sprite;
    String memory;
    Node outNode;
    Node dataNode;
    SmallTextEntry ste;
    
    public Keyboard(int x, int y, String name){
        super(x, y, 96, 48, name);
        sprite = loadImage("assets/keyboard.png");
        outNode = new Node(this, 3, 54, -6, 0, -1);
        dataNode = new Node(this, 0, 70, -6, 0 ,-1);
        memory = "";
    }
    
    public void clicked(int x, int y){
        if(ste == null){
            ste = new SmallTextEntry(memory, "Send", (new SmallTextEntryEvent(){
                Tronic thisTronic;
                
                public SmallTextEntryEvent setTronic(Tronic thisTronic){
                    this.thisTronic = thisTronic;
                    return this;
                }
                
                public void canceled(){
                    ste = null;
                }
                public void saved(String contents){
                    if(isEnabled()){
                        FlowDetails newFlow = new FlowDetails();
                        newFlow.setData(dataNode, contents);
                        startFlow(outNode, thisTronic, newFlow);
                    }
                    ste = null;
                }
            }).setTronic(this));
        }
        ste.showWindow();
    }
    
    public void renderTronic(int screenX, int screenY){
        image(sprite, getX() - screenX, getY() - screenY);
    }
    
    public void renderNodes(int mouseX, int mouseY, int screenX, int screenY, boolean highlight){
        outNode.render(mouseX, mouseY, screenX, screenY, getX(), getY(), highlight);
        dataNode.render(mouseX, mouseY, screenX, screenY, getX(), getY(), highlight);
    }
    
    public Node[] getNodes(){
        return new Node[]{outNode, dataNode};
    }
}