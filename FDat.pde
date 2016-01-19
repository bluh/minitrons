class FDat extends Tronic{
    PImage sprite;
    String data;
    
    Node dataNode;
    
    public FDat(int x, int y, String name){
        super(x, y, 48, 48, name);
        sprite = loadImage("assets/fdat.png");
        dataNode = new Node(this, 4, 48, 21, 1, 0);
    }
    
    public void renderTronic(int screenX, int screenY){
        image(sprite, (getX() - screenX) * 2, (getY() - screenY) * 2);
    }
    
    public void renderNodes(int mouseX, int mouseY, int screenX, int screenY, float zoom, boolean highlight){
        dataNode.render(mouseX, mouseY, screenX, screenY, getX(), getY(), zoom, highlight);
    }
    
    public Node[] getNodes(){
        return new Node[]{dataNode};
    }
}