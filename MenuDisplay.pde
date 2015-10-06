class MenuDisplay{
    ArrayList<Tronic> tronics;
    ArrayList<Wire> wires;
    
    public MenuDisplay(){
        tronics = new ArrayList<Tronic>();
        wires = new ArrayList<Wire>();
    }
    
    public void selectWires(){
        wires.clear();
        for(Tronic tron: tronics){
            println("getting nodes of " + tron);
            for(Node node: tron.getNodes()){
                println("getting wires of " + node);
                for(int i = 0; i < node.getNumWires(); i++){
                    println("analyzing " + node.getWire(i));
                    if(!wires.contains(node.getWire(i)) && tronics.contains(node.getWire(i).getOtherNode(node).getParent())){
                        println("Fits!");
                        wires.add(node.getWire(i));
                    }
                }
            }
        }
    }
    
    public void select(Tronic tron){
        if(!tronics.contains(tron)){
            tronics.add(tron);
        }
        selectWires();
    }
    
    public void toggle(Tronic tron){
        if(tronics.contains(tron)){
            tronics.remove(tron);
        }else{
            tronics.add(tron);
        }
        selectWires();
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
    
    public void render(float dt, int screenX, int screenY){
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
}