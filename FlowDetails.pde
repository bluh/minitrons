public class FlowDetails{
    ArrayList<HashMap<FDat, String>> fdats;
    ArrayList<Function> programStack;
    int stackIndex;
    boolean ludus;
    
    public FlowDetails(){
        fdats = new ArrayList<HashMap<FDat, String>>();
        programStack = new ArrayList<Function>();
        stackIndex = 0;
        ludus = false;

        fdats.add(new HashMap<FDat, String>());
    }
    
    public String getData(Node dataNode, int onIndex){
        if(dataNode.getNumWires() > 0){
            Tronic dataTronic = dataNode.getWire(0).getOtherNode(dataNode).getParent();
            if(dataTronic instanceof Data){
                return ((Data)dataTronic).getData();
            }else if(dataTronic instanceof FDat){
                HashMap<FDat, String> currentFdatMap = fdats.get(onIndex);
                if(currentFdatMap.containsKey((FDat)dataTronic)){
                    return currentFdatMap.get((FDat)dataTronic);
                }
            }
        }
        return "";
    }

    public String getData(Node dataNode) {
        return getData(dataNode, stackIndex);
    }
    
    public void setData(Node dataNode, String data, int onIndex){
        if(dataNode.getNumWires() > 0){
            for(int i = 0; i < dataNode.getNumWires(); i++){
                Tronic dataTronic = dataNode.getWire(i).getOtherNode(dataNode).getParent();
                if(dataTronic instanceof Data){
                    ((Data)dataTronic).setData(data);
                }else if(dataTronic instanceof FDat){
                    HashMap<FDat, String> currentFdatMap = fdats.get(onIndex);
                    currentFdatMap.put((FDat)dataTronic, data);
                }
            }
        }
    }

    public void printStack() {
        for(int i = 0; i < fdats.size(); i++){
            HashMap<FDat, String> currentFdatMap = fdats.get(i);
            println(i + ":");
            for(java.util.Map.Entry map : currentFdatMap.entrySet()) {
                println("\t" + map.getKey() + ": " + map.getValue());
            }
        }
    }

    public void setData(Node dataNode, String data) {
        setData(dataNode, data, stackIndex);
    }
    
    public boolean isLudus(){
        return ludus;
    }
    
    public void setLudus(boolean v){
        ludus = v;
    }
    
    public int addFunction(Function tron){
        programStack.add(tron);
        stackIndex++;

        fdats.add(new HashMap<FDat, String>());

        return stackIndex;
    }

    public Function peekFunction() {
        if(programStack.size() == 0){
            return null;
        }

        return programStack.get(peekStackIndex());
    }
    
    public Function popFunction() {
        if(programStack.size() == 0){
            return null;
        }
        fdats.remove(stackIndex);
        stackIndex--;
        return programStack.remove(programStack.size() - 1);
    }

    public int getStackIndex() {
        return stackIndex;
    }

    public int peekStackIndex() {
        return stackIndex - 1;
    }


}