public abstract class Tronic{
    int x;
    int y;
    final int WIDTH;
    final int HEIGHT;
    String name;
    boolean enabled;
    
    public Tronic(int x, int y, int w, int h, String name){
        this.x = x;
        this.y = y;
        this.WIDTH = w;
        this.HEIGHT = h;
        this.name = name;
        this.enabled = true;
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
    
    public boolean containsPoint(int px, int py){
        return px > x && px < x + WIDTH && py > y && py < y + HEIGHT;
    }
    
    public void setEnabled(){
        enabled = true;
    }
    
    public void setDisabled(){
        enabled = false;
    }
    
    public boolean isEnabled(){
        return enabled;
    }
    
    public String toString(){
        return name;
    }
    
    public void setName(String name){
        this.name = name;
    }
    
    abstract void renderTronic(int screenX, int screenY);
    abstract void renderNodes(int mouseX, int mouseY, int screenX, int screenY, boolean highlight);
    abstract Node[] getNodes();
}