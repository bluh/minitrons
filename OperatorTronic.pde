class OperatorTronic implements Tronic, InFlow{
    int x;
    int y;
    PImage sprite;
    int type;
    InFlow nextTronic;
    final int WIDTH = 48;
    final int HEIGHT = 48;
    
    Node inNode;
    Node outNode;
    Node aNode;
    Node bNode;
    Node dataNode;
    
    public OperatorTronic(int x, int y){
        this(0, x, y);
    }
    
    public OperatorTronic(int type, int x, int y){
        this.x = x;
        this.y = y;
        this.type = type;
        switch(type){
            case 0:
                sprite = loadImage("assets/add.png");
                break;
            case 1:
                sprite = loadImage("assets/subtract.png");
                break;
            case 2:
                sprite = loadImage("assets/multi.png");
                break;
            case 3:
                sprite = loadImage("assets/divide.png");
                break;
            default:
                sprite = loadImage("assets/add.png");
                break;
        }
        inNode = new Node(this, 2, -6, 21, -1, 0);
        outNode = new Node(this, 3, 48, 21, 1, 0);
        aNode = new Node(this, 1, 12, -6, 0, -1);
        bNode = new Node(this, 1, 30, -6, 0, -1);
        dataNode = new Node(this, 0, 21, 48, 0, 1);
    }
    
    public void getFlow(){
        println("Got flow.");
        double a;
        double b;
        if(dataNode.getNumWires() > 0){
            if(aNode.getNumWires() == 0){
                a = 0;
            }else{
                Tronic endNode = aNode.getWire(0).getOtherNode(aNode).getParent();
                if(endNode instanceof Data){
                    try{
                        a = Double.valueOf(((Data) endNode).getData());
                    }catch(NumberFormatException e){
                        println("Data was not able to convert from A to int");
                        a = 0;
                    }
                }else{
                    a = 0;
                }
            }
            if(bNode.getNumWires() == 0){
                b = 0;
            }else{
                Tronic endNode = bNode.getWire(0).getOtherNode(bNode).getParent();
                if(endNode instanceof Data){
                    try{
                        b = Double.valueOf(((Data) endNode).getData());
                    }catch(NumberFormatException e){
                        println("Data was not able to convert from B to int");
                        b = 0;
                    }
                }else{
                    b = 0;
                }
            }
            double result;
            switch(type){
                case 0:
                    result = a + b;
                    break;
                case 1:
                    result = a - b;
                    break;
                case 2:
                    result = a * b;
                    break;
                case 3:
                    if(b != 0){
                        result = a / b;
                    }else{
                        println("Attempted to divide by 0! Ending flow.");
                        return;
                    }
                    break;
                default:
                    result = a + b;
            }
            Tronic endNode = dataNode.getWire(0).getOtherNode(dataNode).getParent();
            if(endNode instanceof Data){
                ((Data)endNode).setData(String.valueOf(result));
            }
        }
        sendFlow();
    }
    
    public void sendFlow(){
        println("Sending flow.");
        if(outNode.getNumWires() > 0){
            outNode.getWire(0).activateWire(outNode);
        }
    }
    
    public void renderTronic(int screenX, int screenY){
        image(sprite, x - screenX, y - screenY);
    }
    
    public void renderNodes(int mouseX, int mouseY, int screenX, int screenY, boolean highlight){
        inNode.render(mouseX, mouseY, screenX, screenY, x, y, highlight);
        outNode.render(mouseX, mouseY, screenX, screenY, x, y, highlight);
        aNode.render(mouseX, mouseY, screenX, screenY, x, y, highlight);
        bNode.render(mouseX, mouseY, screenX, screenY, x, y, highlight);
        dataNode.render(mouseX, mouseY, screenX, screenY, x, y, highlight);
    }
    
    public Node[] getNodes(){
        return new Node[]{inNode, outNode, aNode, bNode, dataNode};
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