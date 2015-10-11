import java.awt.Dimension;
import java.awt.event.*;

import javax.swing.*;

class SmallTextEntry extends JFrame{
    JTextField textArea;
    JPopupMenu popup;
    java.awt.Font psn;
    SmallTextEntryEvent textEvent;
    
    public SmallTextEntry(String def, SmallTextEntryEvent event){
        super();
        this.textEvent = event;
        setAlwaysOnTop(true);
        setResizable(false);
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
        textArea = new JTextField(def);
        textArea.setFont(psn);
        textArea.setEditable(true);
        textArea.setEnabled(true);
        textArea.setBackground(java.awt.Color.BLACK);
        textArea.setForeground(java.awt.Color.GREEN);
        textArea.setCaretColor(java.awt.Color.GREEN);
        
        popup = new JPopupMenu();
        JMenuItem cutItem = new JMenuItem("Cut");
        cutItem.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                textArea.cut();
            }
        });
        JMenuItem copyItem = new JMenuItem("Copy");
        copyItem.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                textArea.copy();
            }
        });
        JMenuItem pasteItem = new JMenuItem("Paste");
        pasteItem.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                textArea.paste();
            }
        });
        JMenuItem selectItem = new JMenuItem("Select All");
        selectItem.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                textArea.selectAll();
            }
        });
        popup.add(cutItem);
        popup.add(copyItem);
        popup.add(pasteItem);
        popup.addSeparator();
        popup.add(selectItem);
        
        textArea.addMouseListener(new MouseListener() {
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
        JButton cancelData = new JButton("Cancel");
        JButton saveData = new JButton("Save");
        JButton clearData = new JButton("Clear");
        
        cancelData.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                textEvent.canceled();
                setVisible(false);
                dispose();
            }
        });
        saveData.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                textEvent.saved(textArea.getText());
                setVisible(false);
                dispose();
            }
        });
        clearData.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                textArea.setText("");
            }
        });
        
        GroupLayout layout = new GroupLayout(getContentPane());
        layout.setHorizontalGroup(
            layout.createParallelGroup()
            .addGroup(layout.createSequentialGroup()
                .addComponent(cancelData)
                .addComponent(saveData)
                .addComponent(clearData)
                )
            .addComponent(textArea)
        );
        layout.setVerticalGroup(
            layout.createSequentialGroup()
            .addGroup(layout.createParallelGroup()
                .addComponent(cancelData)
                .addComponent(saveData)
                .addComponent(clearData)
            )
            .addComponent(textArea)
        );
        getContentPane().setLayout(layout);
        
        pack();
        setMaximumSize(new Dimension(300, 20));
    }
    
    public void showWindow(){
        setVisible(true);
        toFront();
        textArea.grabFocus();
    }
}