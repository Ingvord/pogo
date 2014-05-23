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
import org.tango.pogo.pogo_gui.tools.PogoException;
import org.tango.pogo.pogo_gui.tools.Utils;

import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.MouseEvent;
import java.util.ArrayList;


//===============================================================
/**
 *	JDialog Class to define enum attribute
 *
 *	@author  Pascal Verdier
 */
//===============================================================


public class EnumDialog extends JDialog {

    private ArrayList<JTextField>   textFields = new ArrayList<JTextField>();
	private int returnValue = JOptionPane.OK_OPTION;
    private EnumPopupMenu   menu = new EnumPopupMenu();

    private static final int nbLines = 20;
	//===============================================================
	/**
	 *	Creates new form EnumDialog
	 */
	//===============================================================
	public EnumDialog(JDialog parent, String title,String[] enumLabels) {
		super(parent, true);
		initComponents();

        GridBagConstraints  gbc = new GridBagConstraints();
        gbc.fill = GridBagConstraints.HORIZONTAL;
        for (int i=0 ; i<nbLines ; i++) {
            gbc.gridx = 0;
            gbc.gridy = i;
            centerPanel.add(new JLabel("  " + i + "  "), gbc);

            JTextField  textField = new JTextField();
            textField.setColumns(20);
            gbc.gridx = 1;
            centerPanel.add(textField, gbc);
            textFields.add(textField);
            //	Add Action listener
            textField.addMouseListener(new java.awt.event.MouseAdapter() {
                public void mouseClicked(java.awt.event.MouseEvent evt) {
                    treeMouseClicked(evt);    //	for menu,...
                }
            });
        }

        if (enumLabels!=null) {
            for (int i=0 ; i<textFields.size() && i<enumLabels.length ; i++) {
                textFields.get(i).setText(enumLabels[i].trim());
            }
        }

		titleLabel.setText(title);
		pack();
 		ATKGraphicsUtils.centerDialog(this);
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
        javax.swing.JButton resetBtn = new javax.swing.JButton();
        javax.swing.JLabel jLabel1 = new javax.swing.JLabel();
        javax.swing.JButton okBtn = new javax.swing.JButton();
        javax.swing.JButton cancelBtn = new javax.swing.JButton();

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

        resetBtn.setText("Reset");
        resetBtn.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                resetBtnActionPerformed(evt);
            }
        });
        bottomPanel.add(resetBtn);

        jLabel1.setText("              ");
        bottomPanel.add(jLabel1);

        okBtn.setText("OK");
        okBtn.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                okBtnActionPerformed(evt);
            }
        });
        bottomPanel.add(okBtn);

        cancelBtn.setText("Cancel");
        cancelBtn.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                cancelBtnActionPerformed(evt);
            }
        });
        bottomPanel.add(cancelBtn);

        getContentPane().add(bottomPanel, java.awt.BorderLayout.SOUTH);

        pack();
    }// </editor-fold>//GEN-END:initComponents

	//===============================================================
	//===============================================================
    @SuppressWarnings("UnusedParameters")
	private void okBtnActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_okBtnActionPerformed
        String[]    labels = getEnumLabels();
        for (String label : labels) {
            try {
                Utils.checkNameSyntax(label, "enumeration", false);
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
    private void resetBtnActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_resetBtnActionPerformed
        // TODO add your handling code here:
        for (JTextField textField : textFields) {
            textField.setText("");
        }
    }//GEN-LAST:event_resetBtnActionPerformed

	//===============================================================
	//===============================================================
    public String[] getEnumLabels() {
        ArrayList<String>   list = new ArrayList<String>();
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
    static private final int OFFSET     = 2;

    static private String[] menuLabels = {
            "Insert row",
            "Remove row",
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
                if (menuLabel == null)
                    add(new Separator());
                else {
                    JMenuItem btn = new JMenuItem(menuLabel);
                    btn.addActionListener(new ActionListener() {
                        public void actionPerformed(ActionEvent evt) {
                            menuActionPerformed(evt);
                        }
                    });
                    add(btn);
                }
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
            }
        }
    }
}
