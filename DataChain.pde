class DataChain extends Tronic{
    PImage sprite;
    Node dataNode;
    Node inNode;
    Node outNode;
    
    public DataChain(int x, int y, String name){
        super(x, y, 48, 48, name);
        sprite = loadImage("assets/fchain.png");
        dataNode = new Node(this, 1, 21, 48, 0, 1);
        inNode = new Node(this, 5, -6, 21, -1, 0);;
        outNode = new Node(this, 6, 48, 21, 1, 0);
    }
    
    public void renderTronic(int screenX, int screenY){
        image(sprite, (getX() - screenX) * 2, (getY() - screenY) * 2);
    }
    
    public void renderNodes(int mouseX, int mouseY, int screenX, int screenY, float zoom, boolean highlight){
        dataNode.render(mouseX, mouseY, screenX, screenY, getX(), getY(), zoom, highlight);
        inNode.render(mouseX, mouseY, screenX, screenY, getX(), getY(), zoom, highlight);
        outNode.render(mouseX, mouseY, screenX, screenY, getX(), getY(), zoom, highlight);
    }
    
    public Node[] getNodes(){
        return new Node[]{dataNode, inNode, outNode};
    }
    
    public Node getDataNode(){
        return dataNode;
    }
    
    public Node getOtherNode(Node thisNode){
        if(thisNode == inNode){
            return outNode;
        }else{
            return inNode;
        }
    }
}