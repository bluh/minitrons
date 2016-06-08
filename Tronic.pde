public abstract class Tronic{
    PImage sprite;
    int x;
    int y;
    final int WIDTH;
    final int HEIGHT;
    String name;
    boolean enabled;
    
    public Tronic(int x, int y, int w, int h, String name){
        this(x, y, w, h, name, null);
    }
    
    public Tronic(int x, int y, int w, int h, String name, PImage sprite){
        this.sprite = sprite;
        this.x = x;
        this.y = y;
        this.WIDTH = w;
        this.HEIGHT = h;
        this.name = name;
        this.enabled = true;
    }
    
    void setSprite(PImage sprite){
        this.sprite = sprite;
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
        return px >= x && px <= x + WIDTH && py >= y && py <= y + HEIGHT;
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
    
    public void renderTronic(int screenX, int screenY){
        image(sprite, (getX() - screenX) * 2, (getY() - screenY) * 2);
    }
    
    public void renderNodes(int mouseX, int mouseY, int screenX, int screenY, float zoom, boolean highlight){
        for(Node node: getNodes()){
            node.render(mouseX, mouseY, screenX, screenY, getX(), getY(), zoom, highlight);
        }
    }
    abstract Node[] getNodes();
}