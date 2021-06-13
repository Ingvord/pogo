//+======================================================================
// $Source:  $
//
// Project:   Tango
//
// Description:  Basic Dialog Class to display info
//
// $Author: pascal_verdier $
//
// Copyright (C) :      2004,2005,2006,2007,2008,2009,2009
//						European Synchrotron Radiation Facility
//                      BP 220, Grenoble 38043
//                      FRANCE
//
// This file is part of Tango.
//
// Tango is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// Tango is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
// 
// You should have received a copy of the GNU General Public License
// along with Tango.  If not, see <http://www.gnu.org/licenses/>.
//
// $Revision:  $
//
// $Log:  $
//
//-======================================================================

package org.tango.pogo.pogo_gui;

import fr.esrf.tangoatk.widget.util.ATKGraphicsUtils;
import org.tango.pogo.pogo_gui.tools.ParserTool;
import org.tango.pogo.pogo_gui.tools.PogoException;
import org.tango.pogo.pogo_gui.tools.Utils;

import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.MouseEvent;
import java.io.File;
import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;

/**
 *	JDialog Class to define enum attribute
 *
 *	@author  Pascal Verdier
 */

@SuppressWarnings("MagicConstant")
public class EnumDialog extends JDialog {

    private List<JTextField>   textFields = new ArrayList<>();
	private int returnValue = JOptionPane.OK_OPTION;
    private EnumPopupMenu   menu = new EnumPopupMenu();

    private static final int NB_LINES = 20;
	//===============================================================
	/**
	 *	Creates new form EnumDialog
	 */
	//===============================================================
	public EnumDialog(JDialog parent, String title, String[] enumLabels) {
		super(parent, true);
		initComponents();

        buildEnumPanel(enumLabels);
		titleLabel.setText(title);
		pack();
 		ATKGraphicsUtils.centerDialog(this);
	}
    //======================================================
    //======================================================
    private void buildEnumPanel(String[] enumLabels) {
	    //  Remove previous one if any
	    for (int i=0 ; i<centerPanel.getComponentCount() ; i++) {
	        centerPanel.remove(i);
        }
        textFields.clear();

	    //  Get nb lines to create
        int nbLines;
	    if (enumLabels!=null && enumLabels.length>NB_LINES)
	        nbLines = enumLabels.length+1;
	    else
	        nbLines = NB_LINES;

	    //  Then create lines (number/label)
        GridBagConstraints  gbc = new GridBagConstraints();
        gbc.fill = GridBagConstraints.HORIZONTAL;
        gbc.gridx = 0;
        gbc.gridy = 0;
        gbc.ipadx = 10;
        for (int i=0 ; i<nbLines ; i++) {
	    gbc.fill = GridBagConstraints.VERTICAL;
	    gbc.anchor = GridBagConstraints.LINE_START;
	    gbc.weightx = 0.;
            centerPanel.add(new JLabel("  " + i + "  "), gbc);

            JTextField  textField = new JTextField();
            textField.setColumns(40);
	    textField.setMinimumSize(new Dimension(120, 20));
            gbc.gridx++;
	    gbc.fill = GridBagConstraints.HORIZONTAL;
	    gbc.weightx = 0.8;
            centerPanel.add(textField, gbc);
            textFields.add(textField);
            //	Add Action listener
            textField.addMouseListener(new java.awt.event.MouseAdapter() {
                public void mouseClicked(java.awt.event.MouseEvent evt) {
                    treeMouseClicked(evt);    //	for menu,...
                }
            });
            gbc.gridx--;
            gbc.gridy++;
        }

        //  Display labels if any
        if (enumLabels!=null) {
            for (int i=0 ; i<textFields.size() && i<enumLabels.length ; i++) {
                textFields.get(i).setText(enumLabels[i].trim());
            }
        }
        pack();
    }
    //======================================================
    /**
     * Manage event on clicked mouse on clicked object.
     *
     * @param evt clicked mouse event
     */
    //======================================================
    private void treeMouseClicked(MouseEvent evt) {
        //  Check button clicked
        int mask = evt.getModifiers();
        if ((mask & MouseEvent.BUTTON3_MASK) == 0)
            return;

        //  Check source object
        Object object = evt.getSource();
        if (object instanceof JTextField) {
            JTextField  textField = (JTextField) object;
            menu.showMenu(evt, textField);
        }
    }

	//===============================================================
    /** This method is called from within the constructor to
     * initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is
     * always regenerated by the Form Editor.
     */
	//===============================================================
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        javax.swing.JPanel topPanel = new javax.swing.JPanel();
        titleLabel = new javax.swing.JLabel();
        centerPanel = new javax.swing.JPanel();
        javax.swing.JPanel bottomPanel = new javax.swing.JPanel();
        javax.swing.JButton fromFileButton = new javax.swing.JButton();
        javax.swing.JLabel jLabel2 = new javax.swing.JLabel();
        javax.swing.JButton okBtn = new javax.swing.JButton();
        javax.swing.JLabel jLabel1 = new javax.swing.JLabel();
        javax.swing.JButton cancelBtn = new javax.swing.JButton();
        javax.swing.JLabel jLabel3 = new javax.swing.JLabel();
        javax.swing.JButton helpButton = new javax.swing.JButton();

        addWindowListener(new java.awt.event.WindowAdapter() {
            public void windowClosing(java.awt.event.WindowEvent evt) {
                closeDialog(evt);
            }
        });

        titleLabel.setFont(new java.awt.Font("Dialog", 1, 18)); // NOI18N
        titleLabel.setText("Dialog Title");
        topPanel.add(titleLabel);

        getContentPane().add(topPanel, java.awt.BorderLayout.NORTH);

        centerPanel.setLayout(new java.awt.GridBagLayout());
        getContentPane().add(centerPanel, java.awt.BorderLayout.CENTER);

        fromFileButton.setText("From File");
        fromFileButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                fromFileButtonActionPerformed(evt);
            }
        });
        bottomPanel.add(fromFileButton);

        jLabel2.setText("              ");
        bottomPanel.add(jLabel2);

        okBtn.setText("OK");
        okBtn.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                okBtnActionPerformed(evt);
            }
        });
        bottomPanel.add(okBtn);

        jLabel1.setText("              ");
        bottomPanel.add(jLabel1);

        cancelBtn.setText("Cancel");
        cancelBtn.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                cancelBtnActionPerformed(evt);
            }
        });
        bottomPanel.add(cancelBtn);

        jLabel3.setText("              ");
        bottomPanel.add(jLabel3);

        helpButton.setText("Help");
        helpButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                helpButtonActionPerformed(evt);
            }
        });
        bottomPanel.add(helpButton);

        getContentPane().add(bottomPanel, java.awt.BorderLayout.SOUTH);

        pack();
    }// </editor-fold>//GEN-END:initComponents

    //===============================================================
    //===============================================================
    private static final char[] authorizedChars = { ' ', '*', '/', '+', '-', '.', '=', '%', '>', '<', '_' };
    private boolean isAuthorized(char c) {
        for (char c1 : authorizedChars) {
            if (c1==c)
                return true;
        }
        return false;
    }
    //===============================================================
    //===============================================================
    public void checkNameSyntax(String label) throws PogoException {
        if (label==null || label.isEmpty())
            throw new PogoException("Enumeration (" + label + ") not valid !");

        //	check if one word
        StringTokenizer stk = new StringTokenizer(label);
        List<String> words = new ArrayList<>();
        while (stk.hasMoreTokens())
            words.add(stk.nextToken());
        StringBuilder sb = new StringBuilder();
        for (String word : words)
            sb.append(word);
        label = sb.toString();

        //	Check for special char
        for (int i = 0; i < label.length(); i++) {
            char c = label.charAt(i);
            if ((c < '0' || (c > '9' && c < 'A') || (c > 'Z' && c < 'a') || c > 'z'))
                if (!isAuthorized(c))
                    throw new PogoException("Syntax error in enumeration: Do not use '" + c + "' char.");
        }
    }
	//===============================================================
	//===============================================================
    @SuppressWarnings("UnusedParameters")
	private void okBtnActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_okBtnActionPerformed
        String[]    labels = getEnumLabels();
        for (String label : labels) {
            try {
                checkNameSyntax(label);
            } catch (PogoException e) {
                e.popup(this);
                return;
            }
        }

		returnValue = JOptionPane.OK_OPTION;
		doClose();
	}//GEN-LAST:event_okBtnActionPerformed

	//===============================================================
	//===============================================================
	@SuppressWarnings("UnusedParameters")
    private void cancelBtnActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_cancelBtnActionPerformed
		returnValue = JOptionPane.CANCEL_OPTION;
		doClose();
	}//GEN-LAST:event_cancelBtnActionPerformed

	//===============================================================
	//===============================================================
    @SuppressWarnings("UnusedParameters")
	private void closeDialog(java.awt.event.WindowEvent evt) {//GEN-FIRST:event_closeDialog
		returnValue = JOptionPane.CANCEL_OPTION;
		doClose();
	}//GEN-LAST:event_closeDialog

    //===============================================================
    //===============================================================
    @SuppressWarnings("UnusedParameters")
    private void fromFileButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_fromFileButtonActionPerformed
        // TODO add your handling code here:
        JFileChooser fileChooser = new JFileChooser(".");
        if (fileChooser.showOpenDialog(this)==JFileChooser.APPROVE_OPTION) {
            File file = fileChooser.getSelectedFile();
            if (file.isFile()) {
                try {
                    List<String> lines = ParserTool.readFileLines(file.toString(), false);
                    for (String line : lines)
                        checkNameSyntax(line);
                    buildEnumPanel(lines.toArray(new String[0]));

                }catch (PogoException e) {
                    e.popup(this);
                }
            }
        }
    }//GEN-LAST:event_fromFileButtonActionPerformed
    //===============================================================
    //===============================================================
    @SuppressWarnings("UnusedParameters")
    private void helpButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_helpButtonActionPerformed
        displayHelp();
    }//GEN-LAST:event_helpButtonActionPerformed
	//===============================================================
	//===============================================================
    private void displayHelp() {
        StringBuilder sb = new StringBuilder();
        sb.append("Authorized char to define an enum:\n");
        sb.append("  - letters\n").append("  - digits\n");
        for (char c : authorizedChars)
            sb.append("  - '").append(c).append("'\n");
        JOptionPane.showMessageDialog(this, sb.toString());
    }
	//===============================================================
	//===============================================================
    private void resetFields() {
        for (JTextField textField : textFields) {
            textField.setText("");
        }
    }
	//===============================================================
	//===============================================================
    public String[] getEnumLabels() {
        List<String>   list = new ArrayList<>();
        for (JTextField textField : textFields) {
            String  text = textField.getText().trim();
            if (!text.isEmpty())
                list.add(text);
        }
        String[]    labels = new String[list.size()];
        for (int i=0 ; i<list.size() ; i++)
            labels[i] = list.get(i);
        return labels;
    }
	//===============================================================
	/**
	 *	Closes the dialog
	 */
	//===============================================================
	private void doClose() {
        setVisible(false);
		dispose();
	}
	//===============================================================
	//===============================================================
    public static String label2enum(String label) {
        return Utils.strReplace(label.toUpperCase(), " ", "_");
    }
	//===============================================================
	//===============================================================
    public static String enum2toolTip(String[] enumLabels) {
        StringBuilder   sb = new StringBuilder("enum {\n");
        for (String label : enumLabels) {
            sb.append("\t").append(label2enum(label)).append(",\n");
        }
        sb.append("}");

        return Utils.buildToolTip(sb.toString());
    }
	//===============================================================
	//===============================================================
	public int showDialog() {
		setVisible(true);
		return returnValue;
	}
    //===============================================================
    //===============================================================
    private int getSelectedTextIndex(JTextField selectedField) {
        for (int i=0 ; i<textFields.size() ; i++) {
            //  Search selected
            if (textFields.get(i)==selectedField) {
                return i;
            }
        }
        return 0;
    }
    //===============================================================
    //===============================================================
    private void insertRow(JTextField selectedField) {
        String previous = "";
        //  Search selected
        int index = getSelectedTextIndex(selectedField);
        //  Then swap to the end
        for (int i=index ; i<textFields.size() ; i++) {
            String  tmp = textFields.get(i).getText();
            textFields.get(i).setText(previous);
            previous = tmp;
        }
    }
    //===============================================================
    //===============================================================
    private void removeRow(JTextField selectedField) {
        //  Search selected
        int index = getSelectedTextIndex(selectedField);
        //  Then swap to the end
        for (int i=index ; i<textFields.size()-1 ; i++) {
            textFields.get(i).setText(textFields.get(i+1).getText());
        }
        textFields.get(textFields.size()-1).setText("");
    }
    //===============================================================
    //===============================================================

	//===============================================================
    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JPanel centerPanel;
    private javax.swing.JLabel titleLabel;
    // End of variables declaration//GEN-END:variables
	//===============================================================




    //==============================================================================
    //==============================================================================
    static private final int INSERT_ROW = 0;
    static private final int REMOVE_ROW = 1;
    static private final int RESET      = 2;
    static private final int HELP       = 3;
    static private final int OFFSET     = 2;

    static private String[] menuLabels = {
            "Insert row",
            "Remove row",
            "Reset all rows",
            "Help on syntax",
    };

    private class EnumPopupMenu extends JPopupMenu {
        private JTextField  textField;
        private JLabel      title;
        //======================================================
        private EnumPopupMenu() {
            title = new JLabel();
            title.setFont(new java.awt.Font("Dialog", Font.BOLD, 16));
            add(title);
            add(new JPopupMenu.Separator());
            for (String menuLabel : menuLabels) {
                JMenuItem btn = new JMenuItem(menuLabel);
                btn.addActionListener(this::menuActionPerformed);
                add(btn);
            }
        }
        //======================================================
        public void showMenu(MouseEvent evt, JTextField textField) {
            this.textField = textField;
            String  label;
            if (textField.getText().isEmpty())
                label = "index "+getSelectedTextIndex(textField);
            else
                label = textField.getText();
            title.setText(label);

            show(textField, evt.getX(), evt.getY());
        }
        //======================================================
        private void menuActionPerformed(ActionEvent evt) {
            //	Check component source
            Object obj = evt.getSource();
            int itemIndex = 0;
            for (int i=0 ; i<menuLabels.length ; i++)
                if (getComponent(OFFSET+i) == obj)
                    itemIndex = i;

            switch (itemIndex) {
                case INSERT_ROW:
                    insertRow(textField);
                    break;
                case REMOVE_ROW:
                    removeRow(textField);
                    break;
                case RESET:
                    resetFields();
                    break;
                case HELP:
                    displayHelp();
                    break;
            }
        }
    }
}
