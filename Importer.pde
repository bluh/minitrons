import java.awt.Dimension;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import javax.swing.*;

class Importer{
    
    HashMap<Integer, Tronic> localTronics;
    ArrayList<String> warnings;
    
    String[] key = {
        "tmover", "tspeaker", "tradiotransmiter", "tcoinvend", "rradioreciver", "rtarget", "troter", "tAnimate",
        "Linfo", "Lgive", "LEgive", "Lgofish", "tHurt", "tAnimateGet", "tNPCProject", "rminitarget",
        "LDeLudus", "LInLudus", "fDataCall"
    };
    String[] val = {
        "Mover", "Speaker", "Radio Transmitter", "Coin Vendor", "Radio Receiver", "Target", "Rotor", "Animate",
        "Ludus Info", "Ludus Give", "Ludus Engineer Give", "Ludus Go Fish", "Ludus Hurt", "Animate Get", "Ludus NPC", "Mini Target",
        "Ludus DeLudus", "Ludus InLudus", "Function Data Call"
    };
    
    public Importer(){
        this.localTronics = new HashMap<Integer, Tronic>();
        this.warnings = new ArrayList<String>();
    }
    
    public void importN8(String file){
        println("importing... " + file);
        int state = 0;
        String[] lines = loadStrings("data/n8saves/" + file + ".ncd");
        String tempLine = "";
        for(String line: lines){
            if(state == 0){
                if(line.equals("tronics")){
                    state = 1;
                }
            }else if(state == 1){
                if(line.equals("attach")){
                    state = 2;
                }else{
                    if(!line.substring(line.length() - 1).equals(":")){
                        tempLine = tempLine + line;
                    }else{
                        String properties[] = (tempLine + line).split(":", 7);
                        tempLine = "";
                        int id = Integer.parseInt(properties[0]);
                        String type = properties[1];
                        String name = properties[2];
                        String bigData = properties[5];
                        char splitter = (char)0x0008;
                        String data = "";
                        for(String split: bigData.split(Character.toString(splitter))){
                            data+= split + ":";
                        }
                        data = data.substring(0, data.length() - 1);
                        String[] location = properties[3].split(",");
                        int x = (int)(Double.parseDouble(location[0]) * 2.5) + width/2;
                        int y = (int)(Double.parseDouble(location[2]) * 2.5) + height/2;
                        if(Double.parseDouble(location[1]) < 1999){
                            Tronic newTronic = null;
                            switch(type){
                                case "cdata":
                                    newTronic = new Data(x, y, name);
                                    ((Data)newTronic).setData(data);
                                    break;
                                case "cfdat":
                                    newTronic = new FDat(x, y, name);
                                    break;
                                case "cifequal":
                                    newTronic = new ComparisonTronic(0, x, y, name);
                                    break;
                                case "cifgreat":
                                    newTronic = new ComparisonTronic(1, x, y, name);
                                    break;
                                case "cIfContains":
                                    newTronic = new ComparisonTronic(2, x, y, name);
                                    break;
                                case "cand":
                                    newTronic = new OperatorTronic(4, x, y, name);
                                    break;
                                case "cplus":
                                    newTronic = new OperatorTronic(0, x, y, name);
                                    break;
                                case "cminus":
                                    newTronic = new OperatorTronic(1, x, y, name);
                                    break;
                                case "cmulti":
                                    newTronic = new OperatorTronic(2, x, y, name);
                                    break;
                                case "cdiv":
                                case "cdivide":
                                    newTronic = new OperatorTronic(3, x, y, name);
                                    break;
                                case "crandom":
                                    newTronic = new OperatorTronic(5, x, y, name);
                                    break;
                                case "cModulos":
                                    newTronic = new OperatorTronic(6, x, y, name);
                                    break;
                                case "cdistance":
                                    newTronic = new OperatorTronic(7, x, y, name);
                                    break;
                                case "ryellowswitch":
                                    newTronic = new Button(0, x, y, name);
                                    break;
                                case "rblueswitch":
                                    newTronic = new Button(1, x, y, name);
                                    break;
                                case "rgreenswitch":
                                    newTronic = new Button(2, x, y, name);
                                    break;
                                case "rswitch":
                                    newTronic = new Button(3, x, y, name);
                                    break;
                                case "rproximity":
                                    newTronic = new Button(4, x, y, name);
                                    break;
                                case "rmicrophone":
                                    warnings.add("REPLACE - A Microphone tronic named " + name + " was replaced with a Keyboard at location (" + x + ", " + y + ")");
                                case "rkeyboard":
                                    newTronic = new Keyboard(x, y, name);
                                    break;
                                case "tspeaker":
                                    warnings.add("REPLACE - A Speaker tronic named " + name + " was replaced with a Monitor at location (" + x + ", " + y + ")");
                                case "tdisplay":
                                    newTronic = new Monitor(x, y, name);
                                    for(String monitorLine: data.split("\t")){
                                        ((Monitor)newTronic).processString(monitorLine);
                                    }
                                    break;
                                case "cdelay":
                                    newTronic = new Delay(x, y, name);
                                    break;
                                case "fChain":
                                    newTronic = new DataChain(x, y, name);
                                    break;
                                case "fCall":
                                    newTronic = new Function(x, y, name);
                                    break;
                                case "LfStart":
                                    warnings.add("REPLACE - A Ludus Function Start tronic named " + name + " was replaced with a Function Start at location (" + x + ", " + y + ")");
                                case "fStart":
                                    newTronic = new FStart(x, y, name);
                                    functions.add((FStart)newTronic);
                                    break;
                                case "fEnd":
                                    newTronic = new FEnd(x, y, name);
                                    break;
                                case "cGet": //no.
                                    newTronic = new OperatorTronic(8, x, y, name);
                                    break;
                                case "cSet":
                                    newTronic = new OperatorTronic(9, x, y, name);
                                    break;
                                case "cTime":
                                    newTronic = new TimeTronic(x, y, name);
                                    break;
                                case "cRemove":
                                    newTronic = new OperatorTronic(10, x, y, name);
                                    break;
                                case "cReplace":
                                    newTronic = new OperatorTronic(11, x, y, name);
                                    break;
                                default:
                                    warnings.add("REMOVE - A " + getName(type) + " tronic named " + name + " at location (" + x + ", " + y + ") was not placed. ID: " + id + ".");
                                    break;
                            }
                            if(newTronic != null){
                                localTronics.put(id, newTronic);
                                tronics.add(newTronic);
                            }
                        }else{
                            warnings.add("REMOVE - A tronic named " + name + " had a Y position of above 1990 and was removed. ID: " + id + ".");
                        }
                    }
                }
            }else if(state == 2){
                if(line.equals("wire")){
                    state = 3;
                }
            }else if(state == 3){
                String[] properties = line.split(",");
                int id1 = Integer.parseInt(properties[0]);
                int nid1 = Integer.parseInt(properties[1]);
                int id2 = Integer.parseInt(properties[2]);
                int nid2 = Integer.parseInt(properties[3]);
                if(localTronics.containsKey(id1) && localTronics.containsKey(id2)){
                    Node node1 = getNodeFromTronic(localTronics.get(id1), nid1);
                    Node node2 = getNodeFromTronic(localTronics.get(id2), nid2);
                    if(node1 != null && node2 != null){
                        color wireColor = #FF0000;
                        if(node1.getType() == 3 || node2.getType() == 3){
                            wireColor = #FF0000;
                        }else if(node1.getType() == 0 || node2.getType() == 0){
                            wireColor = #0000FF;
                        }else if(node1.getType() == 1 || node2.getType() == 1){
                            wireColor = #00FF00;
                        }else if(node1.getType() == 5 || node1.getType() == 6){
                            wireColor = #00FF00;
                        }
                        Wire newWire = new Wire(node1, node2, wireColor);
                        wires.add(newWire);
                        node1.addWire(newWire);
                        node2.addWire(newWire);
                    }else{
                        warnings.add("WIRE ERROR - A wire tried to exist between NodeID " + nid1 + " on a " + localTronics.get(id1).getClass().getSimpleName() + ((node1 == null) ? " (NULL) " : " ") + "and NodeID " + nid2 + " on a " + localTronics.get(id2).getClass().getSimpleName() + ((node2 == null) ? " (NULL)." : "."));
                    }
                }else{
                    warnings.add("WIRE ERROR - A wire tried to exist between two nonexistant tronics with ids: " + id1 + (localTronics.containsKey(id1) ? " and " : " (NULL) and ") + id2 + (localTronics.containsKey(id2) ? "." : " (NULL)."));
                }
            }
        }
        if(warnings.size() > 0){
            showWarning();
        }
        mode = 0;
        messageText = "IMPORTED.";
    }
    
    String getName(String n8Name){
        for(int i = 0; i < key.length; i++){
            if(key[i].equals(n8Name)){
                return val[i];
            }
        }
        return "NULL";
    }
    
    Node getNodeFromTronic(Tronic tron, int id){
        /*
        0: FlowIn,
        1: FlowOutA,
        2: FlowOutB,
        3: DataInA,
        4: DataInB,
        5: DataOutA,
        6: DataOutB,
        7: DataBlock,
        8: ChainIn,
        9: ChainOut,
        */
        int nodeId = -1;
        if((tron instanceof Data || tron instanceof FDat) && id == 7){
            nodeId = 0;
        }else if(tron instanceof OperatorTronic){
            if(id == 0){
                nodeId = 0;
            }else if(id == 1){
                nodeId = 1;
            }else if(id == 3){
                nodeId = 2;
            }else if(id == 4){
                nodeId = 3;
            }else if(id == 5){
                nodeId = 4;
            }
        }else if(tron instanceof ComparisonTronic){
            if(id == 0){
                nodeId = 0;
            }else if(id == 3){
                nodeId = 1;
            }else if(id == 4){
                nodeId = 2;
            }else if(id == 1){
                nodeId = 3;
            }else if(id == 2){
                nodeId = 4;
            }
        }else if(tron instanceof Monitor){
            if(id == 0){
                nodeId = 0;
            }else if(id == 1){
                nodeId = 1;
            }else if(id == 3){
                nodeId = 2;
            }
        }else if(tron instanceof Keyboard){
            if(id == 1){
                nodeId = 0;
            }else if(id == 5){
                nodeId = 1;
            }
        }else if(tron instanceof Button && id == 1){
            nodeId = 0;
        }else if(tron instanceof FStart){
            if(id == 1){
                nodeId = 0;
            }else if(id == 8){
                nodeId = 1;
            }
        }else if(tron instanceof Function){
            if(id == 0){
                nodeId = 0;
            }else if(id == 1){
                nodeId = 1;
            }else if(id == 8){
                nodeId = 2;
            }else if(id == 9){
                nodeId = 3;
            }
        }else if(tron instanceof FEnd){
            if(id == 0){
                nodeId = 0;
            }else if(id == 9){
                nodeId = 1;
            }
        }else if(tron instanceof DataChain){
            if(id == 3){
                nodeId = 0;
            }else if(id == 9){
                nodeId = 1;
            }else if(id == 8){
                nodeId = 2;
            }
        }else if(tron instanceof TimeTronic){
            if(id == 0){
                nodeId = 0;
            }else if(id == 3){
                nodeId = 1;
            }else if(id == 5){
                nodeId = 2;
            }else if(id == 1){
                nodeId = 3;
            }
        }else if(tron instanceof Delay){
            if(id == 0){
                nodeId = 0;
            }else if(id == 3){
                nodeId = 1;
            }else if(id == 1){
                nodeId = 2;
            }
        }
        if(nodeId >= 0){
            return tron.getNodes()[nodeId];
        }
        return null;
    }
    
    void showWarning(){
        JDialog jd = new JDialog();
        jd.setTitle("Importing Warning");
        JLabel message = new JLabel("<html>Some tronics in this N8 save are not compatable with minitrons, and have not been loaded. The files that have been skipped are:</html>");
        JPanel errorContainer = new JPanel();
        BoxLayout errorLayout = new BoxLayout(errorContainer, BoxLayout.Y_AXIS);
        errorContainer.setLayout(errorLayout);
        errorContainer.setEnabled(true);
        JTextPane lab = new JTextPane();
        lab.setEditable(false);
        for(String warn: warnings){
            lab.setText(lab.getText() + warn + "\n");
        }
        errorContainer.add(lab);
        JScrollPane errors = new JScrollPane(errorContainer);
        errors.setVerticalScrollBarPolicy(ScrollPaneConstants.VERTICAL_SCROLLBAR_ALWAYS);
        JButton confirm = new JButton("Confirm");
        confirm.addActionListener(new ActionListener() {
            JDialog thisJd;
            
            public ActionListener init(JDialog thisJd){
                this.thisJd = thisJd;
                return this;
            }
            
            public void actionPerformed(ActionEvent e) {
                thisJd.dispose();
            }
        }.init(jd));
        GroupLayout layout = new GroupLayout(jd.getContentPane());
        layout.setVerticalGroup(
            layout.createSequentialGroup()
            .addGap(4, 10, 10)
            .addGroup(
                layout.createParallelGroup()
                .addComponent(message, 50, 50, 50)
            )
            .addGap(4, 10, 10)
            .addComponent(errors, 100, 150, 150)
            .addGap(4, 10, 10)
            .addComponent(confirm)
        );
        layout.setHorizontalGroup(
            layout.createSequentialGroup()
            .addGap(4,15,15)
            .addGroup(
                layout.createParallelGroup()
                .addGroup(
                    layout.createSequentialGroup()
                    .addGap(10,15,15)
                    .addComponent(message)
                )
                .addGroup(
                    layout.createSequentialGroup()
                    .addGap(10,10,10)
                    .addComponent(errors, 550, 550, 550)
                )
                .addGroup(
                    layout.createSequentialGroup()
                    .addGap(40,40,40)
                    .addComponent(confirm)
                )
            )
        );
        jd.setPreferredSize(new Dimension(600, 300));
        jd.setResizable(false);
        jd.getContentPane().setLayout(layout);
        jd.pack();
        jd.setVisible(true);
        jd.setDefaultCloseOperation(WindowConstants.DISPOSE_ON_CLOSE);
    }
    
}