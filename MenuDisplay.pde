class MenuDisplay{
    int x;
    int y;
    ArrayList<Tronic> tronics;
    ArrayList<Wire> wires;
    MenuItem[] items;
    
    final int OFFSET = 16;
    final int WIDTH = 100;
    final int HEIGHT = 16;
    
    public MenuDisplay(){
        x = 0;
        y = 0;
        tronics = new ArrayList<Tronic>();
        wires = new ArrayList<Wire>();
        items = new MenuItem[0];
    }
    
    public void calculatePosition(){
        if(tronics.size() == 0){
            return;
        }
        x = 0;
        y = 0;
        for(Tronic tron: tronics){
            x += tron.getX() + tron.getWidth() / 2;
            y += tron.getY() + tron.getHeight() / 2;
        }
        x /= tronics.size();
        y /= tronics.size();
    }
    
    public void selectWires(){
        wires.clear();
        for(Tronic tron: tronics){
            for(Node node: tron.getNodes()){
                for(int i = 0; i < node.getNumWires(); i++){
                    if(!wires.contains(node.getWire(i)) && tronics.contains(node.getWire(i).getOtherNode(node).getParent())){
                        wires.add(node.getWire(i));
                    }
                }
            }
        }
    }
    
    public void selectMenuItems(){
        if(tronics.size() == 0){
            items = new MenuItem[0];
        }else if(tronics.size() == 1){
            items = new MenuItem[]{
                new MenuItem(0, "  -    Deselect", #FF0000, "DESELECT"),
                new MenuItem(1, "  ↑    Pick Up", #0000FF, "MOVE"),
                new MenuItem(2, "  X    Delete", color(255, 0 ,76), "DELETE")
            };
        }else if(tronics.size() > 1){
            items = new MenuItem[]{
                new MenuItem(0, "  -    Deselect", #FF0000, "DESELECT"),
                new MenuItem(1, "  ↑    Pick Up", #0000FF, "MOVE"),
                new MenuItem(2, "  X    Delete", color(255, 0 ,76), "DELETE"),
                new MenuItem(3, "  #    Decouple", #00FF00, "DECOUPLE")
            };
        }   
    }
    
    public void select(Tronic tron){
        if(!tronics.contains(tron)){
            tronics.add(tron);
        }
        selectWires();
        calculatePosition();
        selectMenuItems();
    }
    
    public void deselect(Tronic tron){
        if(tronics.contains(tron)){
            tronics.remove(tron);
        }
        selectWires();
        calculatePosition();
        selectMenuItems();
    }
    
    public void toggle(Tronic tron){
        if(tronics.contains(tron)){
            tronics.remove(tron);
        }else{
            tronics.add(tron);
        }
        selectWires();
        calculatePosition();
        selectMenuItems();
    }
    
    public boolean contains(Tronic tron){
        return tronics.contains(tron);
    }
    
    public void deselectAll(){
        tronics.clear();
        wires.clear();
    }
    
    public ArrayList<Tronic> getSelected(){
        return tronics;
    }
    
    public ArrayList<Wire> getWires(){
        return wires;
    }
    
    public MenuItem[] getItems(){
        return items;
    }
    
    public int containsPoint(int x, int y){
        if(x > this.x + OFFSET && x < this.x + OFFSET + WIDTH && y > this.y + OFFSET){
            return (y - (this.y + OFFSET)) / 17;
        }
        return -1;
    }
    
    public void renderHighlights(float dt, int screenX, int screenY){
        if(tronics.size() > 0){
            noStroke();
            fill(color(255, (int) (sin(TWO_PI * dt / 2.5) * 15) + 215, (int) (sin(TWO_PI * dt / 2.5) * 60) + 80));
            for(Tronic tron: tronics){
                rect(tron.getX() - 6 - screenX, tron.getY() - 6 - screenY, tron.getWidth() + 12, tron.getHeight() + 12);
            }
            strokeWeight(12);
            for(Wire wire: wires){
                wire.render(screenX, screenY, color(255, (int) (sin(TWO_PI * dt / 2.5) * 15) + 215, (int) (sin(TWO_PI * dt / 2.5) * 60) + 80));
            }
        }
    }
    
    public void renderMenu(int screenX, int screenY, int mouseX, int mouseY){
        if(tronics.size() > 0){
            strokeWeight(1);
            int mousePoint = containsPoint(mouseX + screenX, mouseY + screenY);
            for(MenuItem item: items){
                item.render(x, y, screenX, screenY, mousePoint);
            }
        }
    }
    
    class MenuItem{
        int index;
        String title;
        color itemColor;
        String action;
        
        public MenuItem(int index, String title, color itemColor, String action){
            this.index = index;
            this.title = title;
            this.itemColor = itemColor;
            this.action = action;
        }
        
        public void render(int menuX, int menuY, int screenX, int screenY, int mouseIndex){
            if(mouseIndex == index){
                fill(itemColor);
            }else{
                fill(color(40,40,40,160));
            }
            stroke(itemColor);
            rect(menuX + OFFSET - screenX, menuY + OFFSET + (17 * index) - screenY, WIDTH, HEIGHT);
            fill(#FFFFFF);
            text(title, menuX + OFFSET - screenX, y + OFFSET + (17 * index) + 12 - screenY);
        }
        
        public String getAction(){
            return action;
        }
        
    }
}