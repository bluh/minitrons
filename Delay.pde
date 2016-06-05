class Delay extends Tronic implements InFlow{
    PImage sprite;
    double delay;
    
    Node inNode;
    Node dataNode;
    Node outNode;
    
    public double getDelay(){
        return delay;
    }
    
    public Delay(int x, int y, String name){
        super(x, y, 48, 48, name);
        sprite = loadImage("assets/delay.png");
        inNode = new Node(this, 2, 21, 48, 0, 1);
        dataNode = new Node(this, 1, -6, 21, -1, 0);
        outNode = new Node(this, 3,  21, -6, 0, -1);
        delay = 0.25;
    }
    
    public Node getFlow(FlowDetails flow){
        String in = flow.getData(dataNode);
        if(in.equals("")){
            this.delay = 0.25;
        }else{
            try{
                this.delay = Math.max(Double.valueOf(in), 0.25);
                if(Double.valueOf(in) == 0){
                    flow.setLudus(true);
                }
            }catch(NumberFormatException e){
                this.delay = 0.25;
            }
        }
        return outNode;
    }
    
    public void renderTronic(int screenX, int screenY){
        image(sprite, (getX() - screenX) * 2, (getY() - screenY) * 2);
    }
    
    public void renderNodes(int mouseX, int mouseY, int screenX, int screenY, float zoom, boolean highlight){
        inNode.render(mouseX, mouseY, screenX, screenY, getX(), getY(), zoom, highlight);
        dataNode.render(mouseX, mouseY, screenX, screenY, getX(), getY(), zoom, highlight);
        outNode.render(mouseX, mouseY, screenX, screenY, getX(), getY(), zoom, highlight);
    }
    
    public Node[] getNodes(){
        return new Node[]{inNode, dataNode, outNode};
    }
}