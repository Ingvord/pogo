//+======================================================================
//
// Project:   Tango
//
// Description:  java source code to popup a simple JTable..
//
// $Author: verdier $
//
// Copyright (C) :      2004,2005,2006,2007,2008,2009,2009,2010,2011,2012,2013,2014
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
// $Revision: $
// $Date:  $
//
// $HeadURL: $
//
//-======================================================================

package org.tango.pogo.pogo_gui.tools;

import fr.esrf.tangoatk.widget.util.ATKGraphicsUtils;

import javax.swing.*;
import javax.swing.table.AbstractTableModel;
import javax.swing.table.TableColumn;
import java.awt.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Enumeration;


//===============================================================
/**
 * Class Description:
 * Dialog Class to display generic data in a JTable inside a JDialog.
 */
//===============================================================


public class PopupTable extends JDialog {

    /**
     * Names of the columns in the table
     */
    private static String[] col_names;

    /**
     * An array of String array for data to be displayed
     */
    private List<List<String>> data;


    private JLabel titleLabel;

    //===============================================================
    /**
     * Creates new form PopupTable
     *
     * @param    parent   parent component.
     * @param    title    Window title.
     * @param    col      columns title.
     * @param    v        vector of String vectors.
     */
    //===============================================================
    @SuppressWarnings("UnusedDeclaration")
    public PopupTable(JDialog parent, String title, String[] col, List<List<String>> v) {
        super(parent, false);
        buildObject(title, col, v);
    }
    //===============================================================
    /**
     * Creates new form PopupTable
     *
     * @param    parent   parent component.
     * @param    title    Window title.
     * @param    col      columns title.
     * @param    v        vector of String vectors.
     */
    //===============================================================
    public PopupTable(JFrame parent, String title, String[] col, List<List<String>> v) {
        super(parent, false);
        buildObject(title, col, v);
    }

    //===============================================================
    //===============================================================
    private void buildObject(String title, String[] col, List<List<String>> v) {
        col_names = col;
        initComponents();
        data = v;
        initMyComponents();
        titleLabel.setText(title);

        pack();
        ATKGraphicsUtils.centerDialog(this);
    }
    //===============================================================
    /**
     * This method is called from within the constructor to
     * initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is
     * always regenerated by the Form Editor.
     */
    //===============================================================
    private void initComponents() {//GEN-BEGIN:initComponents
        JPanel bottomPanel = new javax.swing.JPanel();
        JButton cancelBtn = new javax.swing.JButton();
        JPanel topPanel = new javax.swing.JPanel();
        titleLabel = new javax.swing.JLabel();

        addWindowListener(new java.awt.event.WindowAdapter() {
            public void windowClosing(java.awt.event.WindowEvent evt) {
                closeDialog(evt);
            }
        });

        cancelBtn.setText("Dismiss");
        cancelBtn.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                cancelBtnActionPerformed(evt);
            }
        });
        bottomPanel.add(cancelBtn);

        getContentPane().add(bottomPanel, java.awt.BorderLayout.SOUTH);
        titleLabel.setFont(new java.awt.Font("Dialog", 1, 18));
        titleLabel.setText("Dialog Title");
        topPanel.add(titleLabel);

        getContentPane().add(topPanel, java.awt.BorderLayout.NORTH);
        pack();
    }//GEN-END:initComponents

    //===============================================================
    //===============================================================
    private JTable my_table;
    private JScrollPane scrollPane;

    private void initMyComponents() {
        //	Initialise the final XML objects
        DataTableModel model = new DataTableModel();

        // Create the table
        final JTable table = new JTable(model);
        table.setRowSelectionAllowed(true);
        table.setColumnSelectionAllowed(true);
        table.setDragEnabled(false);
        table.setSelectionMode(ListSelectionModel.SINGLE_SELECTION);
        table.getTableHeader().setFont(new java.awt.Font("Dialog", 1, 14));

        //	Put it in a scrolled pane
        scrollPane = new JScrollPane(table);
        scrollPane.setPreferredSize(new Dimension(650, 450));

        getContentPane().add(scrollPane, BorderLayout.CENTER);
        my_table = table;
        model.fireTableDataChanged();
    }

    //===============================================================
    //===============================================================
    public void setPreferredSize(Dimension d) {
        scrollPane.setPreferredSize(d);
    }

    //===============================================================
    //===============================================================
    public void setPreferredSize(int[] width, int nb_lines) {
        final Enumeration enumeration = my_table.getColumnModel().getColumns();
        TableColumn tc;
        int sp_width = 0;
        for (int i = 0; enumeration.hasMoreElements(); i++) {
            tc = (TableColumn) enumeration.nextElement();
            tc.setPreferredWidth(width[i]);
            sp_width += width[i];
        }
        int height = (nb_lines + 2) * 16;
        scrollPane.setPreferredSize(new Dimension(sp_width, height));
        pack();

    }

    //===============================================================
    //===============================================================
    @SuppressWarnings("UnusedDeclaration")
    public void setColumnWidth(int[] width) {
        final Enumeration cenum = my_table.getColumnModel().getColumns();
        TableColumn tc;
        int sp_width = 0;
        for (int i = 0; cenum.hasMoreElements(); i++) {
            tc = (TableColumn) cenum.nextElement();
            tc.setPreferredWidth(width[i]);
            sp_width += width[i];
        }
        Dimension d = scrollPane.getPreferredSize();
        d.width = sp_width;
        System.out.println(d.width + ", " + d.height);
        scrollPane.setPreferredSize(d);
        pack();
    }

    //===============================================================
    //===============================================================
    @SuppressWarnings({"UnusedDeclaration"})
    private void cancelBtnActionPerformed(java.awt.event.ActionEvent evt) {
        doClose();
    }

    //===============================================================
    //===============================================================
    @SuppressWarnings({"UnusedDeclaration"})
    private void closeDialog(java.awt.event.WindowEvent evt) {
        doClose();
    }

    //===============================================================

    /**
     * Closes the dialog
     */
    //===============================================================
    private void doClose() {
        setVisible(false);
        dispose();
    }
    //===============================================================
    //===============================================================


    //=========================================================================
    //=========================================================================
    public class DataTableModel extends AbstractTableModel {
        private static final long serialVersionUID = -8416336946761607744L;

        //==========================================================
        //==========================================================
        public int getColumnCount() {
            return col_names.length;
        }

        //==========================================================
        //==========================================================
        public int getRowCount() {
            return data.size();
        }

        //==========================================================
        //==========================================================
        public String getColumnName(int aCol) {
            if (aCol >= getColumnCount())
                return col_names[getColumnCount() - 1];
            else
                return col_names[aCol];
        }

        //==========================================================
        //==========================================================
        public Object getValueAt(int row, int col) {
            if (row < data.size())
                if (col < data.get(row).size())
                    return data.get(row).get(col);
                else
                    return "";
            else
                return "";
        }
        //==========================================================
        //==========================================================
    }

}
