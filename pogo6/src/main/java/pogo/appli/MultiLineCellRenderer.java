//+======================================================================
// $Source$
//
// Project:   Tango
//
// Description:  Dialog Class to edit  in a JTable.
//
// $Author$
//
// $Revision$
//
// $Log$
//
// Copyleft 2003 by European Synchrotron Radiation Facility, Grenoble, France
//               All Rights Reversed
//-======================================================================
package pogo.appli;

/**
 * <p>Copyright: Copyright (c) 2002</p>
 * @author Guillaume Barreau (guillaume@runtime-collective.com)
 * @version 1.0
 *
 * Distributable under GPL license.
 * See terms of license at gnu.org.
 */

import javax.swing.*;
import javax.swing.table.TableCellRenderer;
import java.awt.*;

public class MultiLineCellRenderer extends JTextArea implements TableCellRenderer {

  public MultiLineCellRenderer() {
    setEditable(false);
    setLineWrap(false);
    setWrapStyleWord(false);
  }

  public Component getTableCellRendererComponent(JTable table,Object value,
												boolean isSelected, boolean hasFocus, int row, int column) {

    if (value instanceof String) {
      setText((String)value);
      // set the table's row height, if necessary
      //updateRowHeight(row,getPreferredSize().height);
    }
    else
      setText("");
    return this;
  }
}

