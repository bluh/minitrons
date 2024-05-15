public abstract class Tronic{
    PImage sprite;
    int x;
    int y;
    int rotation;
    final int WIDTH;
    final int HEIGHT;
    String name;
    boolean enabled;
    boolean highlighted;
    
    public Tronic(int x, int y, int w, int h, String name){
        this(x, y, w, h, name, null);
    }
    
    public Tronic(int x, int y, int w, int h, String name, PImage sprite){
        this.sprite = sprite;
        this.x = x;
        this.y = y;
        this.rotation = 0;
        this.WIDTH = w;
        this.HEIGHT = h;
        this.name = name;
        this.enabled = true;
        this.highlighted = false;
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
    
    int getRotation(){
        return rotation;
    }
    
    void setRotation(int rot){
        rotation = rot;
    }
    
    void rotateTronic(){
        rotation = (rotation + 1) % 4;
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
    
    public void setHighlight(boolean h){
        highlighted = h;
    }
    
    public boolean containsPoint(int px, int py){
        int thisX1, thisY1, thisX2, thisY2;
        switch(rotation){
            case 0:
            default:
                thisX1 = x;
                thisY1 = y;
                thisX2 = x + WIDTH;
                thisY2 = y + HEIGHT;
                break;
            case 1:
                thisX1 = x + WIDTH - HEIGHT;
                thisY1 = y;
                thisX2 = x + WIDTH;
                thisY2 = y + WIDTH;
                break;
            case 2:
                thisX1 = x;
                thisY1 = y;
                thisX2 = x + WIDTH;
                thisY2 = y + HEIGHT;
                break;
            case 3:
                thisX1 = x;
                thisY1 = y - WIDTH + HEIGHT;
                thisX2 = x + HEIGHT;
                thisY2 = y + HEIGHT;
                break;
        }
        return px >= thisX1 && px <= thisX2 && py >= thisY1 && py <= thisY2;
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

    public String getName() {
        return name;
    }
    
    public void setName(String name){
        this.name = name;
    }
    
    public void renderTronic(float dt){
        int x = (getX() - screenX) * 2;
        int y = (getY() - screenY) * 2;
        rotate(rotation * (PI / 2.0));
        if(highlighted){
            noStroke();
            fill(color(255, (int) (sin(TWO_PI * dt / 2.5) * 15) + 215, (int) (sin(TWO_PI * dt / 2.5) * 60) + 80), 155);
            int menuX = x/2 - 6;
            int menuY = y/2 - 6;
            switch(rotation){
                case 0:
                    rect(menuX, menuY, WIDTH + 12, HEIGHT+ 12);
                    break;
                case 1:
                    rect(menuY, -menuX - (WIDTH - HEIGHT), WIDTH + 12, -(HEIGHT + 12));
                    break;
                case 2:
                    rect(-menuX, -menuY, -(WIDTH + 12), -(HEIGHT + 12));
                    break;
                case 3:
                    rect(-menuY + (WIDTH - HEIGHT), menuX, -(WIDTH + 12), HEIGHT + 12);
                    break;
            }
        }
        scale(.5);
        switch(rotation){
            case 0:
                image(sprite, x, y);
                break;
            case 1:
                image(sprite, y, -x - WIDTH * 2);
                break;
            case 2:
                image(sprite, -x - WIDTH * 2, -y - HEIGHT * 2 + 1);
                break;
            case 3:
                image(sprite, -y - HEIGHT * 2, x);
                break;
        }
        //reverse transformations
        scale(2);
        rotate(rotation * (PI / -2.0));
    }
    
    public void renderNodes(){
        for(Node node: getNodes()){
            node.render(getX(), getY(),(mode != 1));
        }
    }
    abstract Node[] getNodes();
}

interface InFlow{
    public Node getFlow(FlowDetails flow);
}

interface Clickable{
    void clicked(int x, int y, float zoom);
    void mouseNearby(int x, int y, float zoom);
}
