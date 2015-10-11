public abstract class Tronic{
    int x;
    int y;
    final int WIDTH;
    final int HEIGHT;
    String name;
    
    public Tronic(int x, int y, int w, int h, String name){
        this.x = x;
        this.y = y;
        this.WIDTH = w;
        this.HEIGHT = h;
        this.name = name;
    }
    
    int getX(){
        return x;
    }
    
    int getY(){
        return y;
    }
    
    int getWidth(){
        return WIDTH;
    }
    
    int getHeight(){
        return HEIGHT;
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
    
    public String toString(){
        return name;
    }
    
    abstract void renderTronic(int screenX, int screenY);
    abstract void renderNodes(int mouseX, int mouseY, int screenX, int screenY, boolean highlight);
    abstract Node[] getNodes();
}