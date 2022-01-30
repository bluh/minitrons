class Function extends Tronic implements InFlow{
    Node inNode;
    Node outNode;
    Node chainInNode;
    Node chainOutNode;
    
    public Function(int x, int y, String name){
        super(x, y, 48, 48, name, loadImage("assets/fcall.png"));
        inNode = new Node(this, 2, 21, 48, 0, 1, "FlowIn");
        outNode = new Node(this, 3, 21, -6, 0, -1, "FlowOut");
        chainInNode = new Node(this, 5, -6, 21, -1, 0, "ChainIn");
        chainOutNode = new Node(this, 6, 48, 21, 1, 0, "ChainOut");
    }
    
    public Node getFlow(FlowDetails details){
        String name = getName();
        FStart funct = findFunction(name);
        if(funct == null){
            return outNode;
        }else{
            int currentStackIndex = details.getStackIndex();
            int nextStackIndex = details.addFunction(this);
            Node thisNode = chainInNode;
            Node corrNode = funct.getChainNode();
            while(thisNode != null && thisNode.getNumWires() > 0 && corrNode != null && corrNode.getNumWires() > 0){
                thisNode = thisNode.getWire(0).getOtherNode(thisNode);
                Tronic thisTron = thisNode.getParent();
                corrNode = corrNode.getWire(0).getOtherNode(corrNode);
                Tronic corrTron = corrNode.getParent();
                if(thisTron instanceof DataChain && corrTron instanceof DataChain){
                    details.setData(((DataChain)corrTron).getDataNode(), details.getData(((DataChain)thisTron).getDataNode(), currentStackIndex), nextStackIndex);
                    thisNode = ((DataChain)thisTron).getOtherNode(thisNode);
                    corrNode = ((DataChain)corrTron).getOtherNode(corrNode);
                }else{
                    thisNode = null;
                    corrTron = null;
                }
            }
            return funct.getOutNode();
        }
    }
    
    public Node[] getNodes(){
        return new Node[]{inNode, outNode, chainInNode, chainOutNode};
    }
    
    public Node getOutNode(){
        return outNode;
    }
    
    public Node getChainNode(){
        return chainOutNode;
    }

    public String toString() {
        return "FCall [" + name + "]";
    }
}