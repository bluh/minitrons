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
        clearScreen();
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
    
    public void clearScreen(){
        for(int i = 0; i < text.length; i++){
            text[i] = "";
        }
        lines = 0;
    }
    
    public void processString(String input){
        for(String longBit: input.split("\n|(/n)")){
            if(longBit.indexOf("/c") > -1){
                longBit = longBit.substring(longBit.indexOf("/c") + 2);
                clearScreen();
            }
            for(String bit: longBit.split("\\s")){
                while(bit.length() >= 31){
                    text[lines] += bit.substring(0, 30);
                    bit = bit.substring(30);
                    addLine();
                }
                if(text[lines].length() + bit.length() > 30){
                    addLine();
                }
                text[lines] += bit + " ";
            }
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
        int x = (getX() - screenX) * 2;
        int y = (getY() - screenY) * 2;
        int thisX = x;
        int thisY = y;
        rotate(rotation * (PI / 2.0));
        switch(rotation){
            case 0:
                thisX = x;
                thisY = y;
                break;
            case 1:
                thisX = y;
                thisY = -x - WIDTH * 2;
                break;
            case 2:
                thisX = -x - WIDTH * 2;
                thisY = -y - HEIGHT * 2 + 1;
                break;
            case 3:
                thisX = -y - HEIGHT * 2;
                thisY = x;
                break;
        }
        for(int i = 0; i < lines; i++){
            text(text[i], 18 + thisX, 24 + i * 20 + thisY);
        }
        rotate(rotation * (PI / -2.0));
    }
    
    public Node[] getNodes(){
        return new Node[]{inNode, outNode, dataNode};
    }
}
   
   