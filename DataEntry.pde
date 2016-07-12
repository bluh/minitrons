import javax.swing.*;

class DataEntry extends JFrame{
    Data tronic;
    JTextArea textArea;
    JPopupMenu popup;
    java.awt.Font psn;
    
    public DataEntry(){
        super("Data Entry");
        setAlwaysOnTop(true);
        try {
            psn = (java.awt.Font.createFont(java.awt.Font.TRUETYPE_FONT, new java.io.File(dataPath("neverfont.ttf")))).deriveFont(8f);
        } catch (Exception e) {
            psn = new java.awt.Font("Consolas", java.awt.Font.PLAIN, 12);
            e.printStackTrace();
        };
        try{
            UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
        }catch(Exception e){
            //whatever jeez....
        };
        textArea = new JTextArea();
        textArea.setFont(psn);
        textArea.setEditable(true);
        textArea.setEnabled(true);
        textArea.setBackground(java.awt.Color.BLACK);
        textArea.setForeground(java.awt.Color.GREEN);
        textArea.setCaretColor(java.awt.Color.GREEN);
        
        popup = new JPopupMenu();
        JMenuItem cutItem = new JMenuItem("Cut");
        cutItem.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent e) {
                textArea.cut();
            }
        });
        JMenuItem copyItem = new JMenuItem("Copy");
        copyItem.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent e) {
                textArea.copy();
            }
        });
        JMenuItem pasteItem = new JMenuItem("Paste");
        pasteItem.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent e) {
                textArea.paste();
            }
        });
        JMenuItem selectItem = new JMenuItem("Select All");
        selectItem.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent e) {
                textArea.selectAll();
            }
        });
        popup.add(cutItem);
        popup.add(copyItem);
        popup.add(pasteItem);
        popup.addSeparator();
        popup.add(selectItem);
        
        textArea.addMouseListener(new java.awt.event.MouseListener() {
            public void mouseReleased(java.awt.event.MouseEvent arg0) {
                if(arg0.isPopupTrigger()){
                    popup.show(textArea, arg0.getX(), arg0.getY());
                }
            }
            public void mousePressed(java.awt.event.MouseEvent arg0) {}
            public void mouseExited(java.awt.event.MouseEvent arg0) {}
            public void mouseEntered(java.awt.event.MouseEvent arg0) {}
            public void mouseClicked(java.awt.event.MouseEvent arg0) {}
        });
        JScrollPane scrollPane = new JScrollPane(textArea);
        scrollPane.setHorizontalScrollBarPolicy(ScrollPaneConstants.HORIZONTAL_SCROLLBAR_AS_NEEDED);
        scrollPane.setVerticalScrollBarPolicy(ScrollPaneConstants.VERTICAL_SCROLLBAR_ALWAYS);
        JButton getData = new JButton("Get Data");
        JButton setData = new JButton("Set Data");
        JButton clearData = new JButton("Clear");
        JCheckBox onTop = new JCheckBox("Always on Top?", true);
        onTop.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent e) {
                if(((JCheckBox)e.getSource()).isSelected() == true){
                    setAlwaysOnTop(true);
                }else{
                    setAlwaysOnTop(false);
                }
            }
        });
        
        getData.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent e) {
                if(tronic != null){
                    textArea.setText(tronic.getData());
                }
            }
        });
        setData.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent e) {
                if(tronic != null){
                    tronic.setData(textArea.getText());
                }
            }
        });
        clearData.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent e) {
                textArea.setText("");
            }
        });
        
        GroupLayout layout = new GroupLayout(getContentPane());
        layout.setHorizontalGroup(
            layout.createParallelGroup()
            .addGroup(layout.createSequentialGroup()
                .addComponent(getData, 100, 100, 100)
                .addComponent(setData, 100, 100, 100)
                .addComponent(clearData, 100, 100, 100)
                .addComponent(onTop, 100, 100, 100)
                )
            .addComponent(scrollPane)
        );
        layout.setVerticalGroup(
            layout.createSequentialGroup()
            .addGroup(layout.createParallelGroup()
                .addComponent(getData, 20, 20, 20)
                .addComponent(setData, 20, 20, 20)
                .addComponent(clearData, 20, 20, 20)
                .addComponent(onTop, 20, 20, 20)
            )
            .addComponent(scrollPane)
        );
        getContentPane().setLayout(layout);
        
        pack();
        setSize(500, 600);
    }
    
    public void showWindow(){
        setVisible(true);
        toFront();
        textArea.requestFocusInWindow();
    }
    
    public void setTronic(Data tronic){
        this.tronic = tronic;
        if(tronic != null){
            setTitle("Data Entry: " + tronic);
        }else{
            setTitle("Data Entry: Disconnected");
        }
    }
    
    public Data getTronic(){
        return tronic;
    }
}