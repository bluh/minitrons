class ComparisonTronic extends Tronic implements InFlow{
    int type;
    InFlow nextTronic;
    
    Node inNode;
    Node aNode;
    Node bNode;
    Node trueNode;
    Node falseNode;
    
    public ComparisonTronic(int x, int y, String name){
        this(0, x, y, name);
    }
    
    public ComparisonTronic(int type, int x, int y, String name){
        super(x, y, 48, 48, name);
        this.type = type;
        switch(type){
            case 0:
                setSprite(loadImage("assets/ifequals.png"));
                break;
            case 1:
                setSprite(loadImage("assets/ifgt.png"));
                break;
            case 2:
                setSprite(loadImage("assets/ifcontains.png"));
                break;
            default:
                setSprite(loadImage("assets/ifequals.png"));
                break;
        }
        inNode = new Node(this, 2, -6, 21, -1, 0, "FlowIn");
        aNode = new Node(this, 1, 21, -6, 0, -1, "A");
        bNode = new Node(this, 1, 21, 48, 0, 1, "B");
        trueNode = new Node(this, 3, 48, 30, 1, 0, "IfTrue");
        falseNode = new Node(this, 3, 48, 12, 1, 0, "IfFalse");
    }
    
    public Node getFlow(FlowDetails flow){
        switch(type){
            case 0:
                if(flow.getData(aNode).equals(flow.getData(bNode))){
                    return trueNode;
                }else{
                    return falseNode;
                }
            case 1:
                String a,b;
                double numA, numB;
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
                if(numA > numB){
                    return trueNode;
                }else{
                    return falseNode;
                }
            case 2:
                if(flow.getData(aNode).contains(flow.getData(bNode))){
                    return trueNode;
                }else{
                    return falseNode;
                }
            default:
                return falseNode;
        }
    }
    
    public int getType(){
        return type;
    }
    
    public Node[] getNodes(){
        return new Node[]{inNode, aNode, bNode, trueNode, falseNode};
    }
}