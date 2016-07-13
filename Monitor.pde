class Monitor extends Tronic implements InFlow{
    String[] text;
    int lines;
    Node inNode;
    Node outNode;
    Node dataNode;
    //N8: 17 rows
    //mt: 30 rows
    //N8: 30 columns
    //mt: 21 columns

    public Monitor(int x, int y, String name){
        super(x, y, 256, 224, name, loadImage("assets/monitor.png"));
        inNode = new Node(this, 2, 113, 218, -1, 0, "FlowIn");
        outNode = new Node(this, 3, 137, 218, 1, 0, "FlowOut");
        dataNode = new Node(this, 1, 125, 224, 0, 1, "DisplayData");
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
            while(tempBit.length() >= 31){
                text[lines] += tempBit.substring(0, 30);
                tempBit = tempBit.substring(30);
                addLine();
            }
            text[lines] += tempBit + " ";
            addLine();
        }
    }
        
    
    public Node getFlow(FlowDetails flow){
        String result = flow.getData(dataNode);
        if(result.length() > (30 * 21)){
            result = result.substring(result.length() - (21 * 21));
        }
        processString(result);
        return outNode;
    }
    
    public String[] getTextLines(){
        return text;
    }
    
    public int getTextLineNumber(){
        return lines;
    }
    
    public void renderTronic(int screenX, int screenY){
        super.renderTronic(screenX, screenY);
        fill(#FFFFFF);
        for(int i = 0; i < lines; i++){
            text(text[i], (9 + getX() - screenX) * 2, (12 + i * 10 + getY() - screenY) * 2);
        }
    }
    
    public Node[] getNodes(){
        return new Node[]{inNode, outNode, dataNode};
    }
}
   
   