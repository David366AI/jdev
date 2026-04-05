/*
 * MethodListCellRenderer.java
 * Copyright (c) 1999, 2000, 2001, 2002 CodeAid team
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
 */


package codeaid.popup;

import java.awt.*;
import javax.swing.*;

import jane.lang.*;


public class MethodListCellRenderer extends JPanel implements ListCellRenderer
{
    private JLabel nameLabel;
    private JLabel paramLabel;
    private JLabel closeLabel;


    public MethodListCellRenderer(MemberInfo[] listData) {
        nameLabel = new JLabel();
        paramLabel = new JLabel();
        closeLabel = new JLabel();

        JPanel panel2 = new JPanel();
        panel2.setOpaque(false);
        panel2.setLayout(new BorderLayout());
        panel2.add(BorderLayout.WEST, paramLabel);
        panel2.add(BorderLayout.CENTER, closeLabel);

        setLayout(new BorderLayout());
        add(BorderLayout.WEST, nameLabel);
        add(BorderLayout.CENTER, panel2);

        if (listData.length > 0) {
            nameLabel.setText(listData[0].getName() + "(");
        }
    }


    public void setFont(Font f) {
        super.setFont(f);
        if (nameLabel != null) {
            Font smallerFont = new Font("SansSerif", Font.PLAIN,
                Math.max(f.getSize() - 4, 10));
            nameLabel.setFont(f);
            paramLabel.setFont(smallerFont);
            closeLabel.setFont(f);
        }
    }


    public int getNameOffset() {
        return nameLabel.getPreferredSize().width;
    }


    public Component getListCellRendererComponent(JList list, Object value,
        int index, boolean isSelected,
        boolean cellHasFocus) {
        MemberInfo mi = (MemberInfo) value;
        nameLabel.setText(mi.getName() + "(");

        String params = "";
        String[] paramNames;
        String[] paramTypes;
        if (mi instanceof ConstructorInfo) {
            paramNames = ((ConstructorInfo) mi).getParameterNames();
            paramTypes = ((ConstructorInfo) mi).getParameterTypes();
        } else {
            paramNames = ((MethodInfo) mi).getParameterNames();
            paramTypes = ((MethodInfo) mi).getParameterTypes();
        }

        for (int i = 0; i < paramTypes.length; i++) {
            if (i > 0) {
                params += ", ";
            }
            params += lastName(paramTypes[i]);
            if ((paramNames != null) && (paramNames.length != 0)) {
                params += " " + paramNames[i];
            }
        }

        paramLabel.setText(params);
        closeLabel.setText(")");

        Color background = (
            isSelected ? list.getSelectionBackground() : list.getBackground()
        );
        Color foreground = (
            isSelected ? list.getSelectionForeground() : list.getForeground()
        );
        setBackground(background);
        nameLabel.setForeground(foreground);
        paramLabel.setForeground(foreground);
        closeLabel.setForeground(foreground);

        return this;
    }


    private static String lastName(String name) {
        int i = name.lastIndexOf('.');
        return (i >= 0) ? name.substring(i + 1) : name;
    }
}

