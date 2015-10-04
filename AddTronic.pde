class AddTronic implements Tronic, InFlow, OutFlow{
    int x;
    int y;
    PImage sprite;
    OutFlow lastTronic;
    InFlow nextTronic;
    final int WIDTH = 48;
    final int HEIGHT = 48;
    
    public AddTronic(int x, int y){
        this.x = x;
        this.y = y;
        sprite = loadImage("/assets/add.png");
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