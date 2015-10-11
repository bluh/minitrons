class Monitor extends Tronic implements InFlow{
    String[] text;
    int lines;
    PImage sprite;
    Node inNode;
    Node outNode;
    Node dataNode;
    //N8: 17 rows
    //mt: 21 rows
    //N8: 30 columns
    //mt: 21 columns

    public Monitor(int x, int y, String name){
        super(x, y, 256, 224, name);
        sprite = loadImage("assets/monitor.png");
        inNode = new Node(this, 2, 113, 218, -1, 0);
        outNode = new Node(this, 3, 137, 218, 1, 0);
        dataNode = new Node(this, 1, 125, 224, 0, 1);
        text = new String[22];
        for(int i = 0; i < text.length; i++){
            text[i] = "";
        }
        lines = 0;
    }
    
    public void addLine(){
        lines++;
        if(lines >= text.length){
            for(int i = 1; i < text.length; i++){
                text[i - 1] = text[i];
            }
            lines = text.length - 1;
            text[lines] = "";
        }
    }
    
    public void processString(String input){
        for(String bit: input.split("\n|(/n)")){
            String tempBit = new String(bit);
            while(tempBit.length() > 31){
                text[lines] += tempBit.substring(0, 30);
                tempBit = tempBit.substring(30);
                addLine();
            }
            text[lines] += tempBit + " ";
            addLine();
        }
    }
        
    
    public void getFlow(){
        String result = "";
        if(dataNode.getNumWires() > 0){
            Tronic endTronic = dataNode.getWire(0).getOtherNode(dataNode).getParent();
            if(endTronic instanceof Data){ //UH SHOULD BE???
                result = ((Data) endTronic).getData();
            }
        }
        processString(result);
        if(outNode.getNumWires() > 0){
            outNode.getWire(0).activateWire(outNode);
        }
    }
    
    public String[] getTextLines(){
        return text;
    }
    
    public int getTextLineNumber(){
        return lines;
    }
    
    public void renderTronic(int screenX, int screenY){
        image(sprite, getX() - screenX, getY() - screenY);
        fill(#FFFFFF);
        for(int i = 0; i < lines; i++){
            text(text[i], 8 + getX() - screenX, 12 + i * 10 + getY() - screenY);
        }
    }
    
    public void renderNodes(int mouseX, int mouseY, int screenX, int screenY, boolean highlight){
        inNode.render(mouseX, mouseY, screenX, screenY, getX(), getY(), highlight);
        outNode.render(mouseX, mouseY, screenX, screenY, getX(), getY(), highlight);
        dataNode.render(mouseX, mouseY, screenX, screenY, getX(), getY(), highlight);
    }
    
    public Node[] getNodes(){
        return new Node[]{inNode, outNode, dataNode};
    }
}
   
   