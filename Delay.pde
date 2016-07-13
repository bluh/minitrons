class Delay extends Tronic implements InFlow{
    double delay;
    
    Node inNode;
    Node dataNode;
    Node outNode;
    
    public double getDelay(){
        return delay;
    }
    
    public Delay(int x, int y, String name){
        super(x, y, 48, 48, name, loadImage("assets/delay.png"));
        inNode = new Node(this, 2, 21, 48, 0, 1, "FlowIn");
        dataNode = new Node(this, 1, -6, 21, -1, 0, "DelayAmount");
        outNode = new Node(this, 3,  21, -6, 0, -1, "FlowOut");
        delay = 0.25;
    }
    
    public Node getFlow(FlowDetails flow){
        String in = flow.getData(dataNode);
        if(in.equals("")){
            this.delay = 0.25;
        }else{
            try{
                this.delay = Math.max(Double.valueOf(in), (flow.isLudus() ? 0.0 : 0.25));
                if(Double.valueOf(in) == 0){
                    println("Adding Ludus Flow...");
                    flow.setLudus(true);
                }
            }catch(NumberFormatException e){
                this.delay = 0.25;
            }
        }
        return outNode;
    }
    
    public Node[] getNodes(){
        return new Node[]{inNode, dataNode, outNode};
    }
}