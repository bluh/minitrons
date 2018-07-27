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
                setSprite(loadImage("assets/distance.png"));
                a = "A";
                b = "B";
                result = "||B-A||";
                break;
            case 8:
                setSprite(loadImage("assets/indexof.png"));
                a = "Array";
                b = "Index";
                result = "Array[Index]";
                break;
            case 9:
                setSprite(loadImage("assets/set.png"));
                a = "Index";
                b = "Value";
                result = "Array";
                break;
            case 10:
                setSprite(loadImage("assets/remove.png"));
                a = "Array";
                b = "Index";
                result = "Modified Array";
                break;
            case 11:
                setSprite(loadImage("assets/replace.png"));
                a = "String";
                b = "Value";
                result = "Array";
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
                    if(b.equals("")){
                        result = a;
                    }else{
                        result = Double.toString(numA + numB);
                    }
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
                    if(b.indexOf("v") == 0){
                        String[] bVals = b.split(",");
                        if(bVals.length == 3){
                            try{
                                double bX = Double.valueOf(bVals[0].substring(1));
                                double bY = Double.valueOf(bVals[1]);
                                double bZ = Double.valueOf(bVals[2]);
                                double aX = 0.0;
                                double aY = 0.0; //default values for a, in case the input is blank or invalid
                                double aZ = 0.0;
                                if(a.indexOf("v") == 0){
                                    String[] aVals = a.split(",");
                                    if(aVals.length == 3){
                                        try{
                                            aX = Double.valueOf(aVals[0].substring(1));
                                            aY = Double.valueOf(aVals[1]);
                                            aZ = Double.valueOf(aVals[2]);
                                        }catch(Exception e){
                                            //invalid, keep the 0,0,0
                                        }
                                    }
                                }
                                //ok now find the distance...
                                result = Double.toString(Math.sqrt(
                                    Math.pow(bX - aX,2) + 
                                    Math.pow(bY - aY,2) + 
                                    Math.pow(bZ - aZ,2)
                                ));
                            }catch(Exception e){
                                result = "";
                            }
                        }else{
                            result = "";
                        }
                    }else{
                        result = "";
                    }
                    break;
                case 8:
                    if(a.indexOf("|") > -1){
                        String[] array = a.split("\\|");
                        int localIndex = 0;
                        result = "";
                        for(String value: array){
                            String[] valueSplit = value.split(":",2);
                            if(valueSplit.length > 1){
                                if(b.equals(valueSplit[0])){
                                    result = valueSplit[1];
                                    break;
                                }
                            }else{
                                localIndex++;
                                if(localIndex == (int) numB){
                                    result = value;
                                    break;
                                }
                            }
                        }
                    }else{
                        if((int) numB >= a.length() || (int) numB < 0){
                            result = "";
                        }else{
                            result = a.substring((int) numB, (int) numB + 1);
                        }
                    }
                    break;
                case 9:
                case 11:
                    String array = flow.getData(dataNode);
                    if(array.indexOf("|") > -1){ //the procedure for arrays for both Set and Replace are the same
                        int localIndex = 0;
                        result = "";
                        for(String value: array.split("\\|")){
                            String[] valueSplit = value.split(":",2);
                            if(valueSplit.length > 1){
                                if(a.equals(valueSplit[0])){
                                    result+= valueSplit[0] + ":" + b + "|";
                                }else{
                                    result+= value + "|";
                                }
                                println(result);
                            }else{
                                localIndex++;
                                if(localIndex == (int) numA){
                                    result+= b + "|";
                                }else{
                                    result+= value + "|";
                                }
                            }
                        }
                        result = result.substring(0,result.length() - 1);
                    }else{
                        if(type == 11){ //Replace code
                            if(!a.equals("") && array.indexOf(a) > -1){
                                result = array.substring(0, array.indexOf(a)) + b + array.substring(array.indexOf(a) + a.length());
                            }else{
                                result = array;
                            }
                        }else{ //Set code
                            if(numA > 0 && numA <= array.length()){
                                result = array.substring(0, (int)numA - 1) + b + array.substring((int)numA);
                            }else{
                                result = array;
                            }
                        }
                    }
                    break;
                case 10:
                    if(a.indexOf("|") > -1){
                        int localIndex = 0;
                        result = "";
                        for(String value: a.split("\\|")){
                            String[] valueSplit = value.split(":",2);
                            if(valueSplit.length > 1){
                                if(!b.equals(valueSplit[0])){
                                    result+= value + "|";
                                }
                                println(result);
                            }else{
                                localIndex++;
                                if(localIndex != (int) numB){
                                    result+= value + "|";
                                }
                            }
                        }
                        result = result.substring(0,result.length() - 1);
                    }else{
                        if(!a.equals("") && a.indexOf(b) > -1){
                            result = a.substring(0, a.indexOf(b)) + a.substring(a.indexOf(b) + b.length());
                        }else{
                            result = a;
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
    
    public Node[] getNodes(){
        return new Node[]{inNode, outNode, aNode, bNode, dataNode};
    }
}
