class DataChain extends Tronic{
    Node dataNode;
    Node inNode;
    Node outNode;
    
    public DataChain(int x, int y, String name){
        super(x, y, 48, 48, name, loadImage("assets/fchain.png"));
        dataNode = new Node(this, 1, 21, 48, 0, 1, "Data");
        inNode = new Node(this, 5, -6, 21, -1, 0, "ChainIn");
        outNode = new Node(this, 6, 48, 21, 1, 0, "ChainOut");
    }
    
    public Node[] getNodes(){
        return new Node[]{dataNode, inNode, outNode};
    }
    
    public Node getDataNode(){
        return dataNode;
    }
    
    public Node getOtherNode(Node thisNode){
        if(thisNode == inNode){
            return outNode;
        }else{
            return inNode;
        }
    }
}