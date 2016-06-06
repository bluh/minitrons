class FStart extends Tronic{
    PImage sprite;
    String data;
    
    Node outNode;
    Node chainNode;
    
    public FStart(int x, int y, String name){
        super(x, y, 48, 48, name);
        sprite = loadImage("assets/fstart.png");
        outNode = new Node(this, 3, 21, -6, 0, -1);
        chainNode = new Node(this, 6, -6, 21, -1, 0);
    }
    
    public void renderTronic(int screenX, int screenY){
        image(sprite, (getX() - screenX) * 2, (getY() - screenY) * 2);
    }
    
    public void renderNodes(int mouseX, int mouseY, int screenX, int screenY, float zoom, boolean highlight){
        outNode.render(mouseX, mouseY, screenX, screenY, getX(), getY(), zoom, highlight);
        chainNode.render(mouseX, mouseY, screenX, screenY, getX(), getY(), zoom, highlight);
    }
    
    public Node[] getNodes(){
        return new Node[]{outNode, chainNode};
    }
    
    public Node getOutNode(){
        return outNode;
    }
    
    public Node getChainNode(){
        return chainNode;
    }
}