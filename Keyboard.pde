class Keyboard extends Tronic implements Clickable{
    PImage sprite;
    String memory;
    Node outNode;
    Node dataNode;
    SmallTextEntry ste;
    
    public Keyboard(int x, int y, String name){
        super(x, y, 96, 48, name);
        sprite = loadImage("assets/keyboard.png");
        outNode = new Node(this, 3, 54, -6, 0, -1);
        dataNode = new Node(this, 0, 70, -6, 0 ,-1);
        memory = "";
    }
    
    public void clicked(int x, int y){
        if(ste == null){
            ste = new SmallTextEntry(memory, "Send", new SmallTextEntryEvent(){
                public void canceled(){
                    //etc
                }
                public void saved(String contents){
                    for(int i = 0; i < dataNode.getNumWires(); i++){
                        Tronic otherTron = dataNode.getWire(i).getOtherNode(dataNode).getParent();
                        if(otherTron instanceof Data){
                            ((Data) otherTron).setData(contents);
                        }
                    }
                    memory = contents;
                    if(outNode.getNumWires() > 0){
                        Tronic otherTron = outNode.getWire(0).getOtherNode(outNode).getParent();
                        if(otherTron instanceof InFlow){
                            ((InFlow) otherTron).getFlow();
                        }
                    }
                }
            });
        }
        ste.showWindow();
    }
    
    public void renderTronic(int screenX, int screenY){
        image(sprite, getX() - screenX, getY() - screenY);
    }
    
    public void renderNodes(int mouseX, int mouseY, int screenX, int screenY, boolean highlight){
        outNode.render(mouseX, mouseY, screenX, screenY, getX(), getY(), highlight);
        dataNode.render(mouseX, mouseY, screenX, screenY, getX(), getY(), highlight);
    }
    
    public Node[] getNodes(){
        return new Node[]{outNode, dataNode};
    }
}