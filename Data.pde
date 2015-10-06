class Data implements Tronic{
    int x;
    int y;
    PImage sprite;
    String data;
    final int WIDTH = 48;
    final int HEIGHT = 48;
    
    Node dataNode;
    
    public Data(int x, int y){
        this.x = x;
        this.y = y;
        sprite = loadImage("assets/data.png");
        dataNode = new Node(this, 4, 48, 21, 1, 0);
    }
    
    public void renderTronic(int screenX, int screenY){
        image(sprite, x - screenX, y - screenY);
    }
    
    public void renderNodes(int mouseX, int mouseY, int screenX, int screenY, boolean highlight){
        dataNode.render(mouseX, mouseY, screenX, screenY, x, y, highlight);
    }
    
    public void setData(String data){
        this.data = data;
    }
    
    public String getData(){
        return data;
    }
    
    public Node[] getNodes(){
        return new Node[]{dataNode};
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
    
    public void deleteTronic(){
        for(Node node: getNodes()){
            for(int i = 0; i < node.getNumWires(); i++){
                node.getWire(i).deleteWire();
            }
        }
    }
}