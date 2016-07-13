class OperatorTronic extends Tronic implements InFlow{
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
        String a,b,result;
        switch(type){
            case 0:
                setSprite(loadImage("assets/add.png"));
                a = "A";
                b = "B";
                result = "A+B";
                break;
            case 1:
                setSprite(loadImage("assets/subtract.png"));
                a = "A";
                b = "B";
                result = "A-B";
                break;
            case 2:
                setSprite(loadImage("assets/multi.png"));
                a = "A";
                b = "B";
                result = "A*B";
                break;
            case 3:
                setSprite(loadImage("assets/divide.png"));
                a = "A";
                b = "B";
                result = "A/B";
                break;
            case 4:
                setSprite(loadImage("assets/and.png"));
                a = "A";
                b = "B";
                result = "A&B";
                break;
            case 5:
                setSprite(loadImage("assets/random.png"));
                a = "A";
                b = "B";
                result = "Rand(A,B)";
                break;
            case 6:
                setSprite(loadImage("assets/modulo.png"));
                a = "A";
                b = "B";
                result = "A%B";
                break;
            case 7:
                setSprite(loadImage("assets/indexof.png"));
                a = "A";
                b = "B";
                result = "A[B]";
                break;
            default:
                setSprite(loadImage("assets/add.png"));
                a = "A";
                b = "B";
                result = "A+B";
                break;
        }
        inNode = new Node(this, 2, -6, 21, -1, 0, "FlowIn");
        outNode = new Node(this, 3, 48, 21, 1, 0, "FlowOut");
        aNode = new Node(this, 1, 12, -6, 0, -1, a);
        bNode = new Node(this, 1, 30, -6, 0, -1, b);
        dataNode = new Node(this, 0, 21, 48, 0, 1, result);
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
                    break;
                case 7:
                    if(a.indexOf("|") > -1){
                        String[] array = a.split("|");
                        if((int)numB > array.length){
                            result = "";
                        }else{
                            result = array[(int)numB];
                        }
                    }else{
                        if((int) numB > a.length() || (int) numB < 0){
                            result = "";
                        }else{
                            result = a.substring((int) numB, (int) numB + 1);
                        }
                    }
                    break;
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
        image(sprite, (getX() - screenX) * 2, (getY() - screenY) * 2);
    }
    
    public Node[] getNodes(){
        return new Node[]{inNode, outNode, aNode, bNode, dataNode};
    }
}