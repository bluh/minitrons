class FStart extends Tronic{
    String data;
    
    Node outNode;
    Node chainNode;
    
    public FStart(int x, int y, String name){
        super(x, y, 48, 48, name, loadImage("assets/fstart.png"));
        outNode = new Node(this, 3, 21, -6, 0, -1, "FlowOut");
        chainNode = new Node(this, 6, -6, 21, -1, 0, "ChainOut");
    }
    
    public Node[] getNodes(){
        return new Node[]{outNode, chainNode};
    }
    
    public Node getOutNode(){
        return outNode;
    }
    
    public Node getChainNode(){
        return chainNode;
    }
}
