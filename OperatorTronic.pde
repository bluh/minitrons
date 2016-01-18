class OperatorTronic extends Tronic implements InFlow{
    PImage sprite;
    int type;
    InFlow nextTronic;
    
    Node inNode;
    Node outNode;
    Node aNode;
    Node bNode;
    Node dataNode;
    
    public OperatorTronic(int x, int y, String name){
        this(0, x, y, name);
    }
    
    public OperatorTronic(int type, int x, int y, String name){
        super(x, y, 48, 48, name);
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
            case 4:
                sprite = loadImage("assets/and.png");
                break;
            case 5:
                sprite = loadImage("assets/random.png");
                break;
            case 6:
                sprite = loadImage("assets/modulo.png");
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
    
    public Node getFlow(FlowDetails flow){
        String a;
        double numA;
        String b;
        double numB;
        if(dataNode.getNumWires() > 0){
            a = flow.getData(aNode);
            if(a.equals("")){
                numA = 0;
            }else{
                try{
                    numA = Double.valueOf(a);
                }catch(NumberFormatException e){
                    numA = 0;
                }
            }
            b = flow.getData(bNode);
            if(b.equals("")){
                numB = 0;
            }else{
                try{
                    numB = Double.valueOf(b);
                }catch(NumberFormatException e){
                    numB = 0;
                }
            }
            String result;
            switch(type){
                case 0:
                    result = Double.toString(numA + numB);
                    break;
                case 1:
                    result = Double.toString(numA - numB);
                    break;
                case 2:
                    result = Double.toString(numA * numB);
                    break;
                case 3:
                    if(numB != 0){
                        result = Double.toString(numA / numB);
                    }else{
                        println("Attempted to divide by 0! Ending flow.");
                        return null;
                    }
                    break;
                case 4:
                    result = a + b;
                    break;
                case 5:
                    if(a.equals("") && b.equals("")){
                        result = Double.toString(random(1.0));
                    }else{
                        result = Double.toString(random((float) numA,(float)  numB));
                    }
                    break;
                case 6:
                    result = Double.toString(numA % numB);
                default:
                    result = a + b;
                    break;
            }
            flow.setData(dataNode, result);
        }
        return outNode;
    }
    
    public int getType(){
        return type;
    }
    
    public void renderTronic(int screenX, int screenY){
        image(sprite, getX() - screenX, getY() - screenY);
    }
    
    public void renderNodes(int mouseX, int mouseY, int screenX, int screenY, boolean highlight){
        inNode.render(mouseX, mouseY, screenX, screenY, getX(), getY(), highlight);
        outNode.render(mouseX, mouseY, screenX, screenY, getX(), getY(), highlight);
        aNode.render(mouseX, mouseY, screenX, screenY, getX(), getY(), highlight);
        bNode.render(mouseX, mouseY, screenX, screenY, getX(), getY(), highlight);
        dataNode.render(mouseX, mouseY, screenX, screenY, getX(), getY(), highlight);
    }
    
    public Node[] getNodes(){
        return new Node[]{inNode, outNode, aNode, bNode, dataNode};
    }
}