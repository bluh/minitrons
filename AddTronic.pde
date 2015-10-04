class AddTronic implements Tronic, InFlow, OutFlow{
    int x;
    int y;
    PImage sprite;
    InFlow nextTronic;
    final int WIDTH = 48;
    final int HEIGHT = 48;
    
    Node inNode;
    Node outNode;
    Node aNode;
    Node bNode;
    Node dataNode;
    
    public AddTronic(int x, int y){
        this.x = x;
        this.y = y;
        sprite = loadImage("/assets/add.png");
        inNode = new Node(this, 2, -6, 21, -1, 0);
        outNode = new Node(this, 3, 48, 21, 1, 0);
        aNode = new Node(this, 1, 12, -6, 0, -1);
        bNode = new Node(this, 1, 30, -6, 0, -1);
        dataNode = new Node(this, 0, 21, 48, 0, 1);
    }
    
    public void getFlow(){
        println("Got flow.");
        //it would do stuff with data
        sendFlow();
    }
    
    public void sendFlow(){
        println("Sending flow.");
        if(nextTronic != null){
            nextTronic.getFlow();
        }
    }
    
    public void renderTronic(int screenX, int screenY){
        image(sprite, x - screenX, y - screenY);
    }
    
    public void renderNodes(int mouseX, int mouseY, int screenX, int screenY, boolean highlight){
        inNode.render(mouseX, mouseY, screenX, screenY, x, y, highlight);
        outNode.render(mouseX, mouseY, screenX, screenY, x, y, highlight);
        aNode.render(mouseX, mouseY, screenX, screenY, x, y, highlight);
        bNode.render(mouseX, mouseY, screenX, screenY, x, y, highlight);
        dataNode.render(mouseX, mouseY, screenX, screenY, x, y, highlight);
    }
    
    public Node[] getNodes(){
        return new Node[]{inNode, outNode, aNode, bNode, dataNode};
    }
    
    public int getX(){
        return this.x;
    }
    
    public int getY(){
        return this.y;
    }
    
    public int getWidth(){
        return this.WIDTH;
    }
    
    public int getHeight(){
        return this.HEIGHT;
    }
    
    public void moveTronic(int x, int y){
        this.x = x;
        this.y = y;
    }
}