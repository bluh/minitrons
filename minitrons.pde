int screenX;
int screenY;
int mode;
int tronicsId;
int menuX;
int loggingSamps;
int multiStartX;
int multiStartY;
int multiEndX;
int multiEndY;
long loggingUS;
float dt;
float mouseTime;
float zoom;
String[] MODES;
String[] TRONICS;
PImage[] TRONICSIMG;
String VERSION;
String messageText;
String fileName;
String author;
PFont font8;
PFont font16;
ArrayList<Tronic> tronics;
ArrayList<Wire> wires;
ArrayList<QueuedWrapper> events;
ArrayList<Circle> circles;
ArrayList<FStart> functions;
ArrayList<Tronic> multiSelected;
Tronic dragTronic;
MouseWire wireStart;
MenuDisplay menu;
DataEntry dataEntry;
boolean showHint;
boolean showLoadWarnings;
boolean darkMode;
boolean displayDebug;
boolean multiSelect;
boolean shiftDown;
boolean ctrlDown;
boolean altDown;
boolean deleteDown;
boolean menuOpen;

void setup(){
    size(800,600);
    noSmooth();
    windowResizable(true);
    println("Loading fonts...");
    font16 = loadFont("neverfont16.vlw");
    textFont(font16,8);
    screenX = 0;
    screenY = 0;
    mode = 0;
    dt = 0;
    mouseTime = 0;
    tronicsId = 0;
    menuX = 16;
    zoom = 1;
    showHint = false;
    displayDebug = false;
    shiftDown = false;
    ctrlDown = false;
    altDown = false;
    menuOpen = false;
    deleteDown = false;
    MODES = new String[]{"EDIT", "COMPUTE", "WIRE", "FILE"};
    TRONICS = new String[]{
        "data", "fdat", "and", "add", "subtract", "multi", 
        "divide", "modulo", "distance", "ifelse", "ifgt", "random",
        "delay", "ybutton", "bbutton", "gbutton", "rbutton", "keyboard",
        "proxy", "monitor","fcall", "fstart", "fend", "fchain",
        "ifcontains", "indexof", "set", "time", "remove", "replace"
    };
    TRONICSIMG = new PImage[TRONICS.length];
    println("Loading tronic icons...");
    for(int i = 0; i < TRONICS.length;i++){
        TRONICSIMG[i] = loadImage("assets/icons/" + TRONICS[i] + ".png");
    }
    VERSION = "1.1";
    messageText = "NEW FILE";
    fileName = "";
    author="Default";
    showLoadWarnings = true;
    darkMode = false;
    println("Initializing objects...");
    tronics = new ArrayList<Tronic>();
    wires = new ArrayList<Wire>();
    events = new ArrayList<QueuedWrapper>();
    circles = new ArrayList<Circle>();
    functions = new ArrayList<FStart>();
    multiSelected = new ArrayList<Tronic>();
    menu = new MenuDisplay();
    dataEntry = new DataEntry();
    println("Loading config...");
    try{
        JSONObject configFile = loadJSONObject("config.json");
        showHint = configFile.getBoolean("showHint", showHint);
        println(showHint ? "CONFIG: Showing hints..." : "CONFIG: Hiding hints...");
        
        showLoadWarnings = configFile.getBoolean("showLoadWarnings", showLoadWarnings);
        println(showLoadWarnings ? "CONFIG: Showing loading warnings..." : "CONFIG: Hiding loading warnings...");
        
        author = configFile.getString("author", author);
        println("CONFIG: Author is \""+author+"\"");
        
        darkMode = configFile.getBoolean("darkMode", darkMode);
        println(darkMode ? "CONFIG: Dark mode on..." : "CONFIG: Dark mode off...");
    }catch(Exception e){
        println("Could not load config.txt! Resorting to default configuration...");
    }
    println("All loaded!");
}

void keyPressed(){
    mouseTime = 0;
    if(keyCode == 36){ //home = 36
        displayDebug = !displayDebug;
        if(displayDebug){
            loggingUS = 0;
            loggingSamps = 0;
        }else{
            println("Log:");
            println("Number of samples: " + loggingSamps);
            println("Total time: " + loggingUS + "us");
            println("Total average us per frame: " + (loggingUS / loggingSamps));
        }
    }else if(keyCode == 82){ //r = 82
        screenX = 0;
        screenY = 0;
        zoom = 1.0;
    }else if(keyCode == 32){ //space = 32
        mode = (mode + 1) % 2;
        if(mode != 0){
            menuOpen = false;
        }
        menu.deselectAll();
    }else if(keyCode == 67){ //c = 67
        menu.deselectAll();
        tronics.clear();
        functions.clear();
        wires.clear();
    }else if(keyCode == 69 && mode == 0){ //e = 69
        menuOpen = !menuOpen;
    }else if(keyCode == 83 && ctrlDown && mode == 0){ //s = 83
        ctrlDown = false;
        messageText = "SAVING...";
        mode = 3;
        menu.deselectAll();
        new SmallTextEntry(fileName, new SmallTextEntryEvent(){
            public void canceled(){
                messageText = "SAVING CANCELED.";
                mode = 0;
            }
            
            public void saved(String contents){
                if(!contents.equals("")){
                    JSONObject output = new JSONObject();
                    JSONArray tronicsOutput = new JSONArray();
                    int objs = 0;
                    HashMap<Wire, Integer[]> wireDetails = new HashMap<Wire, Integer[]>();
                    messageText = "SAVING... (TRONICS)";
                    for(Tronic tron: tronics){
                        JSONObject tronObj = new JSONObject();
                        tronObj.setString("type", tron.getClass().getSimpleName());
                        tronObj.setString("name", tron.toString());
                        tronObj.setInt("objIndex", objs);
                        tronObj.setInt("posX", tron.getX());
                        tronObj.setInt("posY", tron.getY());
                        tronObj.setInt("rotation", tron.getRotation());
                        if(tron instanceof Button){
                            tronObj.setInt("buttonType", ((Button)tron).getType());
                        }else if(tron instanceof Data){
                            tronObj.setString("dataContents", ((Data)tron).getData());
                        }else if(tron instanceof OperatorTronic){
                            tronObj.setInt("operatorType", ((OperatorTronic)tron).getType());
                        }else if(tron instanceof Monitor){
                            tronObj.setInt("monitorLineNumber", ((Monitor)tron).getTextLineNumber());
                            String[] text = ((Monitor)tron).getTextLines();
                            JSONArray textLines = new JSONArray();
                            for(int i = 0; i < text.length; i++){
                                textLines.setString(i, text[i]);
                            }
                            tronObj.setJSONArray("monitorLines", textLines);
                        }else if(tron instanceof ComparisonTronic){
                            tronObj.setInt("comparisonType", ((ComparisonTronic)tron).getType());
                        }
                        for(int n = 0; n < tron.getNodes().length; n++){
                            for(int w = 0; w < tron.getNodes()[n].getNumWires(); w++){
                                Wire wire = tron.getNodes()[n].getWire(w);
                                if(!wireDetails.containsKey(wire)){
                                    wireDetails.put(wire, new Integer[] {objs, n});
                                }else if(wireDetails.containsKey(wire)){
                                    int t1Id = wireDetails.get(wire)[0];
                                    int t1node = wireDetails.get(wire)[1];
                                    wireDetails.put(wire, new Integer[] {t1Id, t1node, objs, n, wire.getWireColor()});
                                }
                            }
                        }
                        tronicsOutput.setJSONObject(objs, tronObj);
                        objs++;
                    }
                    messageText = "SAVING... (WIRES)";
                    JSONArray wiresOutput = new JSONArray();
                    int wires = 0;
                    for(Integer[] dets: wireDetails.values()){
                        if(dets.length == 5){
                            JSONArray thisSet = new JSONArray();
                            for(int i = 0; i < dets.length; i++){
                                thisSet.setInt(i, dets[i]);
                            }
                            wiresOutput.setJSONArray(wires, thisSet);
                            wires++;
                        }else{
                            println("Invalid wire array?");
                        }
                    }
                    output.setJSONArray("wires", wiresOutput);
                    output.setJSONArray("tronics", tronicsOutput);
                    output.setString("version",VERSION);
                    output.setString("author",author);
                    saveJSONObject(output, "data/saves/" + contents + ".json");
                    messageText = "SAVED";
                    fileName = contents;
                    mode = 0;
                }else{
                    messageText = "SAVING CANCELED";
                    mode = 0;
                }
            }
        }).showWindow();
    }else if(keyCode == 79 && ctrlDown && mode == 0){ //o = 79
        ctrlDown = false;
        messageText = "LOADING...";
        mode = 3;
        menu.deselectAll();
        new SmallTextEntry(fileName, "Load", new SmallTextEntryEvent(){
            public void canceled(){
                messageText = "LOADING CANCELED.";
                mode = 0;
            }
            
            public void saved(String contents){
                if(!contents.equals("")){
                    JSONObject input = null;
                    try{
                        input = loadJSONObject("data/saves/" + contents + ".json");
                    }catch(Exception e){
                        messageText = "FILE DOES NOT EXIST";
                        mode = 0;
                        return;
                    }
                    if(input.isNull("version") || !input.getString("version").equals(VERSION)){
                        messageText = "INCOMPATABLE SAVE";
                        mode = 0;
                        return;
                    }
                    JSONArray tronicsInput = input.getJSONArray("tronics");
                    JSONArray wiresInput = input.getJSONArray("wires");
                    HashMap<Integer, Tronic> tronicDetails = new HashMap<Integer, Tronic>();
                    tronicsId = 0;
                    messageText = "LOADING... (TRONICS)";
                    for(int i = 0; i < tronicsInput.size(); i++){
                        JSONObject tronObj = tronicsInput.getJSONObject(i);
                        String type = tronObj.getString("type");
                        Tronic newTronic = null;
                        switch(type){
                            case "Button":
                                newTronic = new Button(tronObj.getInt("buttonType"), tronObj.getInt("posX"), tronObj.getInt("posY"), tronObj.getString("name"));
                                break;
                            case "Data":
                                newTronic = new Data(tronObj.getInt("posX"), tronObj.getInt("posY"), tronObj.getString("name"));
                                ((Data)newTronic).setData(tronObj.getString("dataContents"));
                                break;
                            case "OperatorTronic":
                                newTronic = new OperatorTronic(tronObj.getInt("operatorType"), tronObj.getInt("posX"), tronObj.getInt("posY"), tronObj.getString("name"));
                                break;
                            case "Monitor":
                                newTronic = new Monitor(tronObj.getInt("posX"), tronObj.getInt("posY"), tronObj.getString("name"));
                                JSONArray lines = tronObj.getJSONArray("monitorLines");
                                for(int x = 0; x < tronObj.getInt("monitorLineNumber"); x++){
                                    ((Monitor)newTronic).processString(lines.getString(x));
                                }
                                break;
                            case "Keyboard":
                                newTronic = new Keyboard(tronObj.getInt("posX"), tronObj.getInt("posY"), tronObj.getString("name"));
                                break;
                            case "FDat":
                                newTronic = new FDat(tronObj.getInt("posX"), tronObj.getInt("posY"), tronObj.getString("name"));
                                break;
                            case "ComparisonTronic":
                                newTronic = new ComparisonTronic(tronObj.getInt("comparisonType"), tronObj.getInt("posX"), tronObj.getInt("posY"), tronObj.getString("name"));
                                break;
                            case "Delay":
                                newTronic = new Delay(tronObj.getInt("posX"), tronObj.getInt("posY"), tronObj.getString("name"));
                                break;
                            case "DataChain":
                                newTronic = new DataChain(tronObj.getInt("posX"), tronObj.getInt("posY"), tronObj.getString("name"));
                                break;
                            case "Function":
                                newTronic = new Function(tronObj.getInt("posX"), tronObj.getInt("posY"), tronObj.getString("name"));
                                break;
                            case "FStart":
                                newTronic = new FStart(tronObj.getInt("posX"), tronObj.getInt("posY"), tronObj.getString("name"));
                                functions.add((FStart)newTronic);
                                break;
                            case "FEnd":
                                newTronic = new FEnd(tronObj.getInt("posX"), tronObj.getInt("posY"), tronObj.getString("name"));
                                break;
                            default:
                                println("Invalid tronic!");
                                return;
                        }
                        newTronic.setRotation(tronObj.getInt("rotation"));
                        tronics.add(newTronic);
                        tronicDetails.put(tronObj.getInt("objIndex"), newTronic);
                        tronicsId++;
                    }
                    messageText = "LOADING... (WIRES)";
                    for(int i = 0; i < wiresInput.size(); i++){
                        JSONArray thisWire = wiresInput.getJSONArray(i);
                        Tronic tron1 = tronicDetails.get(thisWire.getInt(0));
                        Tronic tron2 = tronicDetails.get(thisWire.getInt(2));
                        Wire newWire = new Wire(tron1.getNodes()[thisWire.getInt(1)],tron2.getNodes()[thisWire.getInt(3)], thisWire.getInt(4));
                        wires.add(newWire);
                        tron1.getNodes()[thisWire.getInt(1)].addWire(newWire);
                        tron2.getNodes()[thisWire.getInt(3)].addWire(newWire);
                    }
                    messageText = "LOADED";
                    fileName = contents;
                    mode = 0;
                }else{
                    messageText = "LOADING CANCELED";
                    mode = 0;
                }
            }
        }).showWindow();
    }else if(ctrlDown && keyCode == 73 && mode == 0){
        ctrlDown = false;
        messageText = "IMPORTING...";
        mode = 3;
        menu.deselectAll();
        new SmallTextEntry("","Import", new SmallTextEntryEvent(){
            public void canceled(){
                messageText = "IMPORTING CANCELED";
                mode = 0;
            }
            
            public void saved(String contents){
                (new Importer()).importN8(contents);
            }
        }).showWindow();
    }else if(keyCode == SHIFT){
        shiftDown = true;
    }else if(keyCode == CONTROL){
        ctrlDown = true;
    }else if(keyCode == ALT){
        altDown = true;
    }else if(keyCode == DELETE){
        deleteDown = true;
    }else if(mode == 1){
        char trigger = Character.toUpperCase(key);
        println("Using " + trigger);
        if((key == '1' || key == '2' || key == '3' || key == '4')){
            int type = Character.getNumericValue(key) - 1;
            color circleColor;
            switch(type){
                case 0:
                default:
                    circleColor = #FFD919;
                    break;
                case 1:
                    circleColor = #088DFF;
                    break;
                case 2:
                    circleColor = #08FF19;
                    break;
                case 3:
                    circleColor = #FB0302;
                    break;
            }
            circles.add(new Circle(circleColor, mouseX, mouseY));
        }
        for(Tronic tron: tronics){
            if(tron instanceof Button && ((Button)tron).getTrigger() == trigger && sqrt(pow((tron.getX() + tron.getWidth()/2) - (mouseX/zoom + screenX), 2) + pow((tron.getY() + tron.getHeight()/2) - (mouseY/zoom + screenY), 2)) <= 150){
                ((Clickable)tron).clicked(mouseX, mouseY, zoom);
            }
        }
    }
}

void keyReleased(){
    if(keyCode == SHIFT){
        shiftDown = false;
    }else if(keyCode == CONTROL){
        ctrlDown = false;
    }else if(keyCode == ALT){
        altDown = false;
    }else if(keyCode == DELETE){
        deleteDown = false;
    }
}
    

void mousePressed(){
    mouseTime = 0;
    if(menuOpen && mouseX < 200){
        int index = (mouseY / 32) * 6 + (mouseX / 32);
        if(index < TRONICS.length){
            String tronic = TRONICS[index];
            Tronic newTronic;
            tronicsId++;
            switch(tronic){
                case "data":
                    newTronic = new Data(screenX + mouseX - 24, screenY + mouseY - 24,"Data"+tronicsId);
                    break;
                case "fdat":
                    newTronic = new FDat(screenX + mouseX - 24, screenY + mouseY - 24,"FDat"+tronicsId);
                    break;
                case "ifelse":
                    newTronic = new ComparisonTronic(0, screenX + mouseX - 24, screenY + mouseY - 24,"IfElse"+tronicsId);
                    break;
                case "ifgt":
                    newTronic = new ComparisonTronic(1, screenX + mouseX - 24, screenY + mouseY - 24,"IfGT"+tronicsId);
                    break;
                case "ifcontains":
                    newTronic = new ComparisonTronic(2, screenX + mouseX - 24, screenY + mouseY - 24,"IfContains"+tronicsId);
                    break;
                case "and":
                    newTronic = new OperatorTronic(4, screenX + mouseX - 24, screenY + mouseY - 24,"And"+tronicsId);
                    break;
                case "add":
                    newTronic = new OperatorTronic(0, screenX + mouseX - 24, screenY + mouseY - 24,"Add"+tronicsId);
                    break;
                case "subtract":
                    newTronic = new OperatorTronic(1, screenX + mouseX - 24, screenY + mouseY - 24,"Sub"+tronicsId);
                    break;
                case "multi":
                    newTronic = new OperatorTronic(2, screenX + mouseX - 24, screenY + mouseY - 24,"Multi"+tronicsId);
                    break;
                case "divide":
                    newTronic = new OperatorTronic(3, screenX + mouseX - 24, screenY + mouseY - 24,"Div"+tronicsId);
                    break;
                case "random":
                    newTronic = new OperatorTronic(5, screenX + mouseX - 24, screenY + mouseY - 24,"Random"+tronicsId);
                    break;
                case "modulo":
                    newTronic = new OperatorTronic(6, screenX + mouseX - 24, screenY + mouseY - 24,"Modulo"+tronicsId);
                    break;
                case "distance":
                    newTronic = new OperatorTronic(7, screenX + mouseX - 24, screenY + mouseY - 24,"Distance"+tronicsId);
                    break;
                case "ybutton":
                    newTronic = new Button(0, screenX + mouseX - 24, screenY + mouseY - 24,"Button"+tronicsId);
                    break;
                case "bbutton":
                    newTronic = new Button(1, screenX + mouseX - 24, screenY + mouseY - 24,"Button"+tronicsId);
                    break;
                case "gbutton":
                    newTronic = new Button(2, screenX + mouseX - 24, screenY + mouseY - 24,"Button"+tronicsId);
                    break;
                case "rbutton":
                    newTronic = new Button(3, screenX + mouseX - 24, screenY + mouseY - 24,"Button"+tronicsId);
                    break;
                case "proxy":
                    newTronic = new Button(4, screenX + mouseX - 24, screenY + mouseY - 24,"Proxy"+tronicsId);
                    break;
                case "keyboard":
                    newTronic = new Keyboard(screenX + mouseX - 48, screenY + mouseY - 24, "Keboard"+tronicsId);
                    break;
                case "monitor":
                    newTronic = new Monitor(screenX + mouseX - 128, screenY + mouseY - 112,"Monitor"+tronicsId);
                    break;
                case "delay":
                    newTronic = new Delay(screenX + mouseX - 24, screenY + mouseY - 24,"Delay"+tronicsId);
                    break;
                case "fchain":
                    newTronic = new DataChain(screenX + mouseX - 24, screenY + mouseY - 24,"FChain"+tronicsId);
                    break;
                case "fcall":
                    newTronic = new Function(screenX + mouseX - 24, screenY + mouseY - 24,"FCall"+tronicsId);
                    break;
                case "fstart":
                    newTronic = new FStart(screenX + mouseX - 24, screenY + mouseY - 24,"FStart"+tronicsId);
                    functions.add((FStart)newTronic);
                    break;
                case "fend":
                    newTronic = new FEnd(screenX + mouseX - 24, screenY + mouseY - 24,"FEnd"+tronicsId);
                    break;
                case "indexof":
                    newTronic = new OperatorTronic(8, screenX + mouseX - 24, screenY + mouseY - 24,"IndexOf"+tronicsId);
                    break;
                case "set":
                    newTronic = new OperatorTronic(9, screenX + mouseX - 24, screenY + mouseY - 24,"Set"+tronicsId);
                    break;
                case "time":
                    newTronic = new TimeTronic(screenX + mouseX - 24, screenY + mouseY - 24,"Time"+tronicsId);
                    break;
                case "remove":
                    newTronic = new OperatorTronic(10, screenX + mouseX - 24, screenY + mouseY - 24,"Remove"+tronicsId);
                    break;
                case "replace":
                    newTronic = new OperatorTronic(11, screenX + mouseX - 24, screenY + mouseY - 24,"Replace"+tronicsId);
                    break;
                default:
                    newTronic = new Data(screenX + mouseX - 24, screenY + mouseY - 24,"Data"+tronicsId);
                    break;
            }
            menu.deselectAll();
            dragTronic = newTronic;
            menuOpen = false;
            tronics.add(newTronic);
            return;
        }
    }
    if(mouseButton == LEFT && mode == 0){
        if(menu.getSelected().size() > 0){
            int mouseIndex = menu.containsMouse();
            MenuDisplay.MenuItem[] items = menu.getItems();
            if(!altDown && mouseIndex >= 0 && items.length > mouseIndex){
                String action = items[mouseIndex].getAction();
                if(action == "DESELECT"){
                    menu.deselectAll();
                    return;
                }else if(action == "MOVE"){
                    dragTronic = menu.getSelected().get(0);
                    return;
                }else if(action == "DELETE"){
                    for(Tronic tron: menu.getSelected()){
                        if(dataEntry.getTronic() == tron){
                            dataEntry.setTronic(null);
                        }
                        for(Node node: tron.getNodes()){
                            while(node.getNumWires() > 0){
                                wires.remove(node.getWire(0));
                                node.getWire(0).deleteWire();
                            }
                        }
                        if(tron instanceof FStart){
                            functions.remove((FStart)tron);
                        }
                        tronics.remove(tron);
                    }
                    menu.deselectAll();
                }else if(action == "DECOUPLE"){
                    for(Wire wire: menu.getWires()){
                        wire.deleteWire();
                        wires.remove(wire);
                    }
                }else if(action == "DATAENTRY"){
                    if(menu.getSelected().get(0) instanceof Data || menu.getSelected().get(0) instanceof Button){
                        dataEntry.setTronic(menu.getSelected().get(0));
                        dataEntry.showWindow();
                    }
                }else if(action == "RENAME"){
                    String ref = "";
                    if(menu.getSelected().size() == 1){
                        ref = menu.getSelected().get(0).toString();
                    }
                    new SmallTextEntry(ref,new SmallTextEntryEvent(){
                        public void canceled(){
                            //sucks to suck
                            menu.deselectAll();
                        }
                        
                        public void saved(String contents){
                            if(!contents.equals("")){
                                for(Tronic tron: menu.getSelected()){
                                    tron.setName(contents);
                                }
                                menu.deselectAll();
                            }
                        }
                    }).showWindow();
                    return;
                }
            }
        }
        for(Tronic tron: tronics){
            for(Node node: tron.getNodes()){
                if(node.containsPoint(screenX + (int)(mouseX / zoom), screenY + (int)(mouseY / zoom), tron.getX(), tron.getY())){
                    mode = 2;
                    wireStart = new MouseWire(node, node.getNodeColor());
                    return;
                }
            }
            if(tron.containsPoint(screenX + (int)(mouseX / zoom), screenY + (int)(mouseY / zoom))){
                if(ctrlDown){
                    if(!menu.contains(tron)){
                        menu.deselectAll();
                    }
                    dragTronic = tron;
                }else if(shiftDown){
                    menu.toggle(tron);
                }else if(altDown){
                    tron.rotateTronic();
                }else{
                    menu.deselectAll();
                    menu.toggle(tron);
                }
                return;
            }
        }
        if(shiftDown){
            if(!ctrlDown){
                menu.deselectAll();
            }
            multiSelect = true;
            multiStartX = mouseX;
            multiStartY = mouseY;
            multiEndX = multiStartX;
            multiEndY = multiStartY;
        }else{
            menu.deselectAll(); //deselect if they clicked nothing
        }
    }else if(mode == 1){
        for(Tronic tron: tronics){
            if(tron instanceof Clickable){
                if(tron.containsPoint(screenX + (int)(mouseX / zoom), screenY + (int)(mouseY / zoom))){
                    ((Clickable) tron).clicked(mouseX, mouseY, zoom);
                }
            }else if(tron instanceof Data){
                if(tron.containsPoint(screenX + (int)(mouseX / zoom), screenY + (int)(mouseY / zoom))){
                    println("Data: " + ((Data) tron).getData());
                }
            }
        }
    }else if(mode == 2 && wireStart != null){
        //wire time...
        for(Tronic tron: tronics){
            for(Node node: tron.getNodes()){
                if(node.containsPoint(screenX + (int)(mouseX / zoom), screenY + (int)(mouseY / zoom), tron.getX(), tron.getY())){
                    //make a wire connecting two nodes
                    if(wireStart.canConnectTo(node)){
                        color wireColor = #FF0000;
                        if(wireStart.getFirstPoint().getType() == 3 || node.getType() == 3){
                            wireColor = #FF0000;
                        }else if(wireStart.getFirstPoint().getType() == 0 || node.getType() == 0){
                            wireColor = #0000FF;
                        }else if(wireStart.getFirstPoint().getType() == 1 || node.getType() == 1){
                            wireColor = #00FF00;
                        }else if(wireStart.getFirstPoint().getType() == 5 || wireStart.getFirstPoint().getType() == 6){
                            wireColor = #00FF00;
                        }
                        Wire newWire = new Wire(wireStart.getFirstPoint(), node, wireColor);
                        wires.add(newWire);
                        wireStart.getFirstPoint().addWire(newWire);
                        node.addWire(newWire);
                        menu.selectWires();
                    }
                    mode = 0;
                    return;
                }
            }
        }
        mode = 0;
    }
}

void mouseWheel(MouseEvent evt){
    float oldZoom = zoom;
    zoom = max(min(2.0, zoom * abs(pow(2.0,-evt.getCount()))),0.5);
    if(zoom != oldZoom){
        screenX = (int) (mouseX - (width / 2) / zoom);
        screenY = (int) (mouseY - (height / 2) / zoom);
    }
}

void mouseReleased(){
    if(dragTronic != null){
        menu.calculatePosition();
        dragTronic = null;
    }
    if(multiSelect){
        multiSelect = false;
        multiStartX = (int) (screenX + multiStartX/zoom);
        multiStartY = (int) (screenY + multiStartY/zoom);
        multiEndX = (int) (screenX + multiEndX/zoom);
        multiEndY = (int) (screenY + multiEndY/zoom);
        for(Tronic tron: tronics){
            if(tron.getX() > min(multiStartX,multiEndX)
            && tron.getX() + tron.getWidth() < max(multiStartX,multiEndX)
            && tron.getY() > min(multiStartY,multiEndY)
            && tron.getY() + tron.getHeight() < max(multiStartY,multiEndY)){
                menu.toggle(tron);
            }
        }
    }
}

void mouseDragged(MouseEvent evt){
    if(evt.getButton() == LEFT && multiSelect){
        multiEndX = mouseX;
        multiEndY = mouseY;
    }
}

void addCircle(int x, int y, color circleColor, int size){
    circles.add(new Circle(circleColor, x, y, size));
}

FStart findFunction(String name){
    for(FStart tron: functions){
        if(tron.getName().equals(name)){
            return tron;
        }
    }
    return null;
}

void addEvent(QueuedEvent evt){
    events.add(new QueuedWrapper(evt));
}

void startFlow(Node outNode, Tronic startingTronic, FlowDetails flow){
    if(outNode.getNumWires() > 0){
        startingTronic.setDisabled();
        Wire nextWire = outNode.getWire(0);
        nextWire.addPending();
        addEvent((new QueuedEvent(){
            Node thisNode;
            Wire thisWire;
            Tronic startingTronic;
            FlowDetails thisDetails;
            double waitTime;
            
            public QueuedEvent setNextDetails(Node thisNode, Wire thisWire, Tronic startingTronic, FlowDetails thisDetails){
                this.thisNode = thisNode;
                this.thisWire = thisWire;
                this.startingTronic = startingTronic;
                this.thisDetails = thisDetails;
                this.waitTime = (thisNode.getParent() instanceof Delay ? ((Delay) thisNode.getParent()).getDelay() : (thisDetails.isLudus() ? 0 : 0.05));
                return this;
            }
            
            public double getDelay(){
                return waitTime;
            }
            
            public void invoke(){
                thisWire.subPending();
                Tronic nextTronic = thisWire.getOtherNode(thisNode).getParent();
                Node nextNode;
                if(nextTronic instanceof InFlow){
                    nextNode = ((InFlow) nextTronic).getFlow(thisDetails);
                    if(nextNode != null && !deleteDown){
                        println("Sending flow: " + nextNode.getParent() + " S: " + startingTronic);
                        startFlow(nextNode, startingTronic, thisDetails);
                    }else{
                        println("Ending flow");
                        startingTronic.setEnabled();
                    }
                }else{
                    println("Ending flow");
                    startingTronic.setEnabled();
                }
            }
        }).setNextDetails(outNode, nextWire, startingTronic, flow));
    }else{
        println("Ending flow");
        startingTronic.setEnabled();
    }
}

void draw(){
    long start_time = System.nanoTime()/1000;
    dt += (1.0/frameRate) % 2.5;
    background(darkMode ? #202020 : #E5E5E5);
    
    //Move screenX & screenY
    if(mousePressed && mouseButton == RIGHT){
        screenX += (pmouseX - mouseX) / zoom;
        screenY += (pmouseY - mouseY) / zoom;
    }
    
    //Update dragTronic
    if(dragTronic != null){
        for(Tronic tron: menu.getSelected()){
            if(tron != dragTronic){
                int relX = tron.getX() - dragTronic.getX();
                int relY = tron.getY() - dragTronic.getY();
                tron.moveTronic((int)((screenX + (mouseX) / zoom - dragTronic.getWidth() / 2) - (screenX + (mouseX) / zoom - dragTronic.getWidth() / 2) % 8) + relX, (int)((screenY + (mouseY) / zoom - dragTronic.getHeight() / 2) - (screenY + (mouseY) / zoom - dragTronic.getHeight() / 2) % 8) + relY);
            }
        }
        dragTronic.moveTronic((int)((screenX + (mouseX) / zoom - dragTronic.getWidth() / 2) - (screenX + (mouseX) / zoom - dragTronic.getWidth() / 2) % 8), (int)((screenY + (mouseY) / zoom - dragTronic.getHeight() / 2) - (screenY + (mouseY) / zoom - dragTronic.getHeight() / 2) % 8));
    }
    long drag_time = System.nanoTime()/1000;
    
    //Draw dataEntry highlight
    fill(#FF0000);
    strokeWeight(0);
    if(dataEntry.getTronic() != null){
        pushMatrix();
        scale(zoom);
        rect(dataEntry.getTronic().getX() - 2 - screenX, dataEntry.getTronic().getY() - 2 - screenY, dataEntry.getTronic().getWidth() + 4, dataEntry.getTronic().getHeight() + 4);
        popMatrix();
    }
    
    //Draw background
    fill(#000000);
    stroke(darkMode ? #C0C0C0 : #000000);
    strokeWeight(1);
    for(int x = (int) ((-screenX % 16) * zoom); x < width; x += (16 * zoom)){
        line(x,0,x,height);
    }
    for(int y = (int) ((-screenY % 16) * zoom); y < height; y += (16 * zoom)){
        line(0, y, width, y);
    }
    long bg_time = System.nanoTime()/1000;
    
    //Rendering on-screen elements requires a scale
    scale(zoom);
    
    //Render circles
    for(int c = 0; c < circles.size(); c++){
        if(!circles.get(c).render()){
            circles.remove(c);
            c--;
        }
    }
    long circle_time = System.nanoTime()/1000;
    
    //Render wires
    strokeWeight(6);
    try{
        for(Wire wire: wires){
            wire.render();
        }
    }catch(java.util.ConcurrentModificationException e){
        //hiccups when loading/importing
        println("ConcurrentModificationException on wire render.");
    }
    
    //Render mouseWire
    if(mode == 2 && wireStart != null){
        wireStart.render();
    }
    long wire_time = System.nanoTime()/1000;
    
    //Render tronics
    for(int i = tronics.size() - 1; i >= 0; i--){
        tronics.get(i).renderTronic(dt);
        if(tronics.get(i) instanceof Clickable
            && sqrt(pow((screenX + mouseX / zoom) - (tronics.get(i).getX() + tronics.get(i).getWidth() * .5),2) + pow((screenY + mouseY / zoom) - (tronics.get(i).getY() + tronics.get(i).getHeight() * .5),2)) < 50){
            ((Clickable)tronics.get(i)).mouseNearby(mouseX, mouseY, zoom);
        }
        tronics.get(i).renderNodes();
    }
    long trons_time = System.nanoTime()/1000;
    
    //Rendering UI elements requires a reversal of scale
    scale(1/zoom);
    
    //Render multiSelect
    if(multiSelect){
        strokeWeight(2);
        stroke(color(255, (int) (sin(TWO_PI * dt / 2.5) * 15) + 215, (int) (sin(TWO_PI * dt / 2.5) * 60) + 80));
        fill(#606060, 175);
        rect(multiStartX, multiStartY, multiEndX-multiStartX,multiEndY-multiStartY);
    }
    
    //Render menu
    if(mode == 0 && dragTronic == null && !altDown){
        menu.renderMenu();
    }
    long menu_time = System.nanoTime()/1000;
    
    //Handle events
    for(int i = 0; i < events.size(); i++){
        if(events.get(i).tick(1.0 / frameRate)){
            events.remove(i);
            i--;
        }
    }
    long event_time = System.nanoTime()/1000;
    
    //Handle mouse events
    if(pmouseX == mouseX && pmouseY == mouseY){
        if(mouseTime < .5){
            mouseTime += (1.0/frameRate);
        }
    }else{
        mouseTime = 0;
    }
    if(mouseTime > .5 && mode != 3){
        boolean stop = false;
        for(Tronic tron: tronics){
            for(Node node: tron.getNodes()){
                if(!stop && node.containsPoint(screenX + (int)(mouseX / zoom), screenY + (int)(mouseY / zoom), tron.getX(), tron.getY())){
                    noStroke();
                    fill(#FFFFFF, 200);
                    rect(mouseX + 10, mouseY - 10, textWidth("Node: " + node.getName()) + 4, 12);
                    fill(#000000);
                    text("Node: " + node.getName(), mouseX + 13, mouseY);
                    stop = true;
                    break;
                }
            }
            if(!stop && tron.containsPoint(screenX + (int)(mouseX / zoom), screenY + (int)(mouseY / zoom))){
                noStroke();
                fill(#FFFFFF, 200);
                rect(mouseX + 10, mouseY - 10, textWidth("Name: " + tron) + 4, 12);
                fill(#000000);
                text("Name: " + tron, mouseX + 13, mouseY);
                break;
            }
        }
        if(mode == 1 && showHint){
            int charWidth = (int) textWidth("1") + 3;
            pushMatrix();
            noStroke();
            fill(#FFD919);
            rect(charWidth * -2 + mouseX, mouseY + 32, charWidth, charWidth);
            fill(#088DFF);
            rect(charWidth * -1 + mouseX + 1, mouseY + 32, charWidth, charWidth);
            fill(#08FF19);
            rect(mouseX + 2, mouseY + 32, charWidth, charWidth);
            fill(#FB0302);
            rect(charWidth + mouseX + 3, mouseY + 32, charWidth, charWidth);
            fill(#FFFFFF);
            text("1",charWidth * -2 + mouseX + 2, mouseY + charWidth + 30); 
            text("2",charWidth * -1 + mouseX + 3, mouseY + charWidth + 30); 
            text("3",mouseX + 4, mouseY + charWidth + 30); 
            text("4",charWidth + mouseX + 5, mouseY + charWidth + 30); 
            popMatrix();
        }else if(mode == 0 && showHint){
            pushMatrix();
            noStroke();
            fill(#FFFFFF, 200);
            int charWidth = (int) textWidth("Ctrl + S: Save File");
            rect(mouseX + 10, mouseY + 10, charWidth + 4, 64);
            fill(#000000);
            text("E: Open Menu\nSpace: Change Mode\nC: Clear Screen\nR: Reset Camera\nCtrl + O: Open File\nCtrl + S: Save File", mouseX + 13, mouseY + 20);
            popMatrix();
        }
    }
    long mouse_time = System.nanoTime()/1000;
    
    //Set style to draw UI
    stroke(#404040);
    strokeWeight(1);
    
    //Draw Tronic Menu
    fill(#606060);
    rect(0,height - 16, width - 1, 16);
    if(menuOpen){
        menuX = min(menuX + 20, 200);
    }else{
        menuX = max(menuX - 20, 8);
    }
    rect(0, 0, menuX, height - 16);
    for(int i = 0; i < TRONICS.length; i++){
        if(TRONICSIMG[i] != null){
            image(TRONICSIMG[i], (-188 + menuX) + (i % 6) * 32, 16 + 32 * (i / 6));
        }
    }
    fill(#FFFFFF);
    text((menuOpen ? "<\n<\n<" : ">\n>\n>"),-8 + menuX,height / 2 - 16);
    
    //Draw status bars
    text("(" + screenX + ", " + screenY + ")", 4, height - 4); 
    text("MODE: " + MODES[mode] + "", 204, height - 4);
    text("TOTAL: " + tronics.size() + "", 404, height - 4);
    text(messageText, 604, height - 4);
    fill(#000000);
    text(VERSION, width - textWidth(VERSION) - 4, 12);
    long ui_time = System.nanoTime()/1000;
    
    //Calculate render times
    long total_time = ui_time - start_time;
    if(displayDebug){
        ui_time = ui_time - mouse_time;
        mouse_time = mouse_time - event_time;
        event_time = event_time - menu_time;
        menu_time = menu_time - trons_time;
        trons_time = trons_time - wire_time;
        wire_time = wire_time - circle_time;
        circle_time = circle_time - bg_time;
        bg_time = bg_time - drag_time;
        drag_time = drag_time - start_time;
        
        //Draw render stats
        fill(#606060,200);
        rect(width - 362, 20, 300, 102);
        fill(#FFFFFF);
        text("Drag Time:        "+drag_time+" us ("+floor((drag_time*100.0)/total_time)+"%)",width - 360, 30);
        text("Background Time:  "+bg_time+" us ("+floor((bg_time*100.0)/total_time)+"%)",width - 360, 40);
        text("Cirlce Time:      "+circle_time+" us ("+floor((circle_time*100.0)/total_time)+"%)",width - 360, 50);
        text("Wire Time:        "+wire_time+" us ("+floor((wire_time*100.0)/total_time)+"%)",width - 360, 60);
        text("Tronics Time      "+trons_time+" us ("+floor((trons_time*100.0)/total_time)+"%)",width - 360, 70);
        text("Menu Time         "+menu_time+" us ("+floor((menu_time*100.0)/total_time)+"%)",width - 360, 80);
        text("Event Time:       "+wire_time+" us ("+floor((event_time*100.0)/total_time)+"%)",width - 360, 90);
        text("Mouse Time:       "+mouse_time+" us ("+floor((mouse_time*100.0)/total_time)+"%)",width - 360, 100);
        text("UI Time:          "+ui_time+" us ("+floor((ui_time*100.0)/total_time)+"%)",width - 360, 110);
        text("Total Time:       "+total_time+" us ("+floor(1.0 / total_time * 1000000)+")",width - 360, 120);
        loggingSamps++;
        loggingUS+=total_time;
    }
    
}
