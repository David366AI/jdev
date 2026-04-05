/*
 * MemberListCellRenderer.java
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


public class MemberListCellRenderer extends JPanel implements ListCellRenderer
{
    protected JLabel typeLabel;
    protected JLabel nameLabel;
    protected JLabel paramLabel;
    protected JLabel closeLabel;

    private static ImageIcon classIcon = new ImageIcon(MethodListCellRenderer.class.getResource("/class.gif"));
    private static ImageIcon methodIcon = new ImageIcon(MethodListCellRenderer.class.getResource("/method.gif"));
    private static ImageIcon fieldIcon = new ImageIcon(MethodListCellRenderer.class.getResource("/field.gif"));
    private static ImageIcon packageIcon = new ImageIcon(MethodListCellRenderer.class.getResource("/package.gif"));
    private static ImageIcon constructorIcon = new ImageIcon(MethodListCellRenderer.class.getResource("/constructor.gif"));


    public MemberListCellRenderer(Object[] listData) {
        setLayout(new GridBagLayout());
        setOpaque(true);
        GridBagConstraints gbc = new GridBagConstraints();

        typeLabel = new JLabel();
        typeLabel.setOpaque(false);
        gbc.anchor = GridBagConstraints.WEST;
        gbc.weightx = .001;
        gbc.insets = new Insets(0, 0, 3, 3);
        add(typeLabel, gbc);

        nameLabel = new JLabel();
        nameLabel.setOpaque(false);
        gbc.insets = new Insets(0, 0, 3, 0);
        add(nameLabel, gbc);

        paramLabel = new JLabel();
        paramLabel.setOpaque(false);
        add(paramLabel, gbc);

        closeLabel = new JLabel();
        closeLabel.setOpaque(false);
        gbc.weightx = .997;
        add(closeLabel, gbc);
    }


    public void setFont(Font f) {
        super.setFont(f);
        if (nameLabel != null) {
            Font smallerFont = new Font("SansSerif", Font.PLAIN, Math.max(f.getSize() - 4, 10));
            typeLabel.setFont(smallerFont);
            nameLabel.setFont(f);
            paramLabel.setFont(smallerFont);
            closeLabel.setFont(f);
            typeLabel.setPreferredSize(null);
            typeLabel.setText("ObjectObject");
            typeLabel.setPreferredSize(typeLabel.getPreferredSize());
            typeLabel.setMinimumSize(typeLabel.getPreferredSize());
        }
    }


    public int getNameOffset() {
        return typeLabel.getPreferredSize().width;
    }


    public Component getListCellRendererComponent(JList list, Object value,
        int index, boolean isSelected,
        boolean cellHasFocus) {
        if (value instanceof FieldInfo) {
            createFieldText((FieldInfo) value);
        } else
            if (value instanceof MethodInfo) {
            createMethodText((MethodInfo) value);
        } else
            if (value instanceof ConstructorInfo) {
            createConstructorText((ConstructorInfo) value);
        } else
            if (value instanceof ClassInfo) {
            createClassText((ClassInfo) value);
        } else if (value instanceof SimpleInfo) {
            createUnknownText(value);
        } else if (value instanceof ImportInfo) {
            createUnknownText(value);
            if (value instanceof ImportInfo) {
                ImportInfo info = (ImportInfo) value;
                if (info.getImportType() == ImportInfo.CLASS) {
                    typeLabel.setIcon(classIcon);
                    closeLabel.setText(info.getPackageName());
                } else if (info.getImportType() == ImportInfo.SUBPACKAGE) {
                    typeLabel.setIcon(packageIcon);
                } else {
                    throw new IllegalArgumentException("wrong importinfo type :" + info.getImportType());
                }
            }
        } else {
            createUnknownText(value);
        }

        Color background = (
            isSelected ? list.getSelectionBackground() : list.getBackground()
        );
        Color foreground = (
            isSelected ? list.getSelectionForeground() : list.getForeground()
        );
        setBackground(background);
        typeLabel.setForeground(foreground);
        nameLabel.setForeground(foreground);
        paramLabel.setForeground(foreground);
        closeLabel.setForeground(Color.blue);

        return this;
    }


    protected void createFieldText(FieldInfo value) {
        typeLabel.setText(lastName(((MemberInfo) value).getType()));
        nameLabel.setText(((MemberInfo) value).getName());
        paramLabel.setText("");
        closeLabel.setText("");
        typeLabel.setIcon(fieldIcon);

    }


    protected void createMethodText(MethodInfo value) {
        typeLabel.setText(lastName(((MemberInfo) value).getType()));

        nameLabel.setText(((MemberInfo) value).getName());

        String params = "";
        String[] paramNames = ((MethodInfo) value).getParameterNames();
        String[] paramTypes = ((MethodInfo) value).getParameterTypes();
        for (int i = 0; i < paramTypes.length; i++) {
            if (i > 0) {
                params += ", ";
            }
            params += lastName(paramTypes[i]);
            if (paramNames != null && paramNames.length > i) {
                params += " " + paramNames[i];
            }
        }
        paramLabel.setText("(" + params + ")");
        closeLabel.setText("");
        typeLabel.setIcon(methodIcon);
    }


    protected void createConstructorText(ConstructorInfo value) {
        typeLabel.setText("");
        nameLabel.setText(((MemberInfo) value).getName());
        String params = "";
        String[] paramNames = ((ConstructorInfo) value).getParameterNames();
        String[] paramTypes = ((ConstructorInfo) value).getParameterTypes();
        for (int i = 0; i < paramTypes.length; i++) {
            if (i > 0) {
                params += ", ";
            }
            params += lastName(paramTypes[i]);
            if ((paramNames != null) && (paramNames.length > i)) {
                params += " " + paramNames[i];
            }
        }
        paramLabel.setText("(" + params + ")");
        closeLabel.setText("");
        typeLabel.setIcon(constructorIcon);

    }


    protected void createClassText(ClassInfo value) {
        typeLabel.setText("");
        nameLabel.setText(((MemberInfo) value).getName());
        paramLabel.setText(" ");
        closeLabel.setText(value.getPackage());
        typeLabel.setIcon(classIcon);
    }


    protected void createUnknownText(Object value) {
        typeLabel.setText("");
        nameLabel.setText(value.toString());
        paramLabel.setText("");
        closeLabel.setText("");
    }


    private static String lastName(String name) {
        int i = name.lastIndexOf('.');
        return (i >= 0) ? name.substring(i + 1) : name;
    }
}

