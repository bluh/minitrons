class TimeTronic extends Tronic implements InFlow{    
    Node inNode;
    Node dataNode;
    Node outputNode;
    Node outNode;
    
    //DAY|HOUR|MINUTE
    //YEAR|MONTH|DAY OF WEEK|HOUR|MINUTE|SECOND
    
    public TimeTronic(int x, int y, String name){
        super(x, y, 48, 48, name, loadImage("assets/time.png"));
        inNode = new Node(this, 2, 21, 48, 0, 1, "FlowIn");
        dataNode = new Node(this, 1, -6, 21, -1, 0, "Option");
        outputNode = new Node(this, 0, 48, 21, 1, 0, "Output");
        outNode = new Node(this, 3,  21, -6, 0, -1, "FlowOut");
    }
    
    public Node getFlow(FlowDetails flow){
        String option = flow.getData(dataNode);
        String result;
        if(option.equals("real")){
            java.util.Calendar c = java.util.Calendar.getInstance();
            result = year() + "|" + month() + "|" + c.get(java.util.Calendar.DAY_OF_WEEK) + "|" + hour() + "|" + minute() + "|" + second();
        }else{
            result = "SOMEDAY|" + (int)((dt / 30) % 24) + "|" + (int)((dt * 2) % 60);
        }
        flow.setData(outputNode, result);
        return outNode;
    }
    
    public Node[] getNodes(){
        return new Node[]{inNode, dataNode, outputNode, outNode};
    }
}