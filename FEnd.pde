class FEnd extends Tronic implements InFlow{
    String data;
    
    Node inNode;
    Node chainNode;
    
    public FEnd(int x, int y, String name){
        super(x, y, 48, 48, name, loadImage("assets/fend.png"));
        inNode = new Node(this, 2, 21, 48, 0, 1, "InNode");
        chainNode = new Node(this, 5, 48, 21, 1, 0, "ChainIn");
    }
    
    public Node getFlow(FlowDetails details){
        Function next = details.popFunction();
        if(next == null){
            return null;
        }
        Node thisNode = chainNode;
        Node corrNode = next.getChainNode();
        while(thisNode != null && thisNode.getNumWires() > 0 && corrNode != null && corrNode.getNumWires() > 0){
            thisNode = thisNode.getWire(0).getOtherNode(thisNode);
            Tronic thisTron = thisNode.getParent();
            corrNode = corrNode.getWire(0).getOtherNode(corrNode);
            Tronic corrTron = corrNode.getParent();
            if(thisTron instanceof DataChain && corrTron instanceof DataChain){
                details.setData(((DataChain)corrTron).getDataNode(),details.getData(((DataChain)thisTron).getDataNode()));
                thisNode = ((DataChain)thisTron).getOtherNode(thisNode);
                corrNode = ((DataChain)corrTron).getOtherNode(corrNode);
            }else{
                thisNode = null;
                corrTron = null;
            }
        }
        return next.getOutNode();
    }
    
    public Node[] getNodes(){
        return new Node[]{inNode, chainNode};
    }
    
    
}