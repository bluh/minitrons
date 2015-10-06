class Node{
    int x;
    int y;
    int dirX;
    int dirY;
    color nodeColor;
    final int WIDTH = 6;
    final int HEIGHT = 6;
    int type;
    Tronic parent;
    ArrayList<Wire> wires;
    //0: Data out
    //1: Data in
    //2: Flow in
    //3: Flow out
    
    public Node(Tronic parent, int x, int y, int dirX, int dirY){
        this(parent, 0, x, y, dirX, dirY);
    }
    
    public Node(Tronic parent, int type, int x, int y, int dirX, int dirY){
        this.parent = parent;
        this.type = type;
        this.x = x;
        this.y = y;
        this.dirX = dirX;
        this.dirY = dirY;
        switch(type){
            case 0:
                nodeColor = color(18, 14, 253);
                break;
            case 1:
                nodeColor = color(67, 251, 29);
                break;
            case 2:
                nodeColor = color(251, 251, 30);
                break;
            case 3:
                nodeColor = color(179, 1, 1);
                break;
            case 4:
                nodeColor = color(72, 215, 254);
                break;
            default:
                nodeColor = #000000;
                break;
        }
        wires = new ArrayList<Wire>();
    }
    
    public boolean containsPoint(int x, int y, int tronicX, int tronicY){
        return x >= this.x + tronicX - 5 && x <= this.x + WIDTH + tronicX + 5 && y >= this.y + tronicY - 5 && y <= this.y + HEIGHT + tronicY + 5;
    }
    
    public void render(int mouseX, int mouseY, int screenX, int screenY, int tronicX, int tronicY, boolean highlight){
        if(highlight && containsPoint(mouseX, mouseY, tronicX, tronicY)){
            fill(#D0D0D0);
        }else{
            fill(nodeColor);
        }
        //rect(tronicX + x,tronicY + y,tronicX + x + WIDTH, tronicY + y + HEIGHT);
        noStroke();
        rect(-screenX + tronicX + x,-screenY + tronicY + y, WIDTH, HEIGHT);
    }
    
    public Tronic getParent(){
        return parent;
    }
    
    public int getX(){
        return x;
    }
    
    public int getY(){
        return y;
    }
    
    public int getDirX(){
        return dirX;
    }
    
    public int getDirY(){
        return dirY;
    }
    
    public color getNodeColor(){
        return nodeColor;
    }
    
    public int getType(){
        return type;
    }
    
    public void addWire(Wire wire){
        wires.add(wire);
    }
    
    public Wire getWire(int index){
        return wires.get(index);
    }
    
    public void deleteWire(Wire wire){
        wires.remove(wire);
    }
    
    public int getNumWires(){
        return wires.size();
    }
}