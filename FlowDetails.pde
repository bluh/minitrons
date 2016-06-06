public class FlowDetails{
    HashMap<FDat, String> fdats;
    ArrayList<Function> programStack;
    boolean ludus;
    
    public FlowDetails(){
        fdats = new HashMap<FDat, String>();
        programStack = new ArrayList<Function>();
        ludus = false;
    }
    
    public String getData(Node dataNode){
        if(dataNode.getNumWires() > 0){
            Tronic dataTronic = dataNode.getWire(0).getOtherNode(dataNode).getParent();
            if(dataTronic instanceof Data){
                return ((Data)dataTronic).getData();
            }else if(dataTronic instanceof FDat){
                if(fdats.containsKey((FDat)dataTronic)){
                    return fdats.get((FDat)dataTronic);
                }
            }
        }
        return "";
    }
    
    public void setData(Node dataNode, String data){
        if(dataNode.getNumWires() > 0){
            for(int i = 0; i < dataNode.getNumWires(); i++){
                Tronic dataTronic = dataNode.getWire(i).getOtherNode(dataNode).getParent();
                if(dataTronic instanceof Data){
                    ((Data)dataTronic).setData(data);
                }else if(dataTronic instanceof FDat){
                    fdats.put((FDat)dataTronic, data);
                }
            }
        }
    }
    
    public boolean isLudus(){
        return ludus;
    }
    
    public void setLudus(boolean v){
        ludus = v;
    }
    
    public void addFunction(Function tron){
        programStack.add(tron);
    }
    
    public Function popFunction(){
        if(programStack.size() == 0){
            return null;
        }
        return programStack.remove(programStack.size() - 1);
    }
}