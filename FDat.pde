class FDat extends Tronic{
    String data;
    
    Node dataNode;
    
    public FDat(int x, int y, String name){
        super(x, y, 48, 48, name, loadImage("assets/fdat.png"));
        dataNode = new Node(this, 4, 48, 21, 1, 0, "Flow Data");
    }
    
    public Node[] getNodes(){
        return new Node[]{dataNode};
    }
}