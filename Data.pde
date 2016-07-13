class Data extends Tronic{
    String data;
    
    Node dataNode;
    
    public Data(int x, int y, String name){
        super(x, y, 48, 48, name, loadImage("assets/data.png"));
        data = "";
        dataNode = new Node(this, 4, 48, 21, 1, 0, "Data");
    }
    
    public void setData(String data){
        this.data = data;
    }
    
    public String getData(){
        return data;
    }
    
    public Node[] getNodes(){
        return new Node[]{dataNode};
    }
}