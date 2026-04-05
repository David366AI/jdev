package codeaid.tools;

import java.util.*;

import org.gjt.sp.jedit.*;
import codeaid.popup.ExpressionFinder;

import org.gjt.sp.util.Log;

import jane.*;
import jane.lang.*;
import jane.parser.ccparser.*;

public class CompletionUtil {

 public static List getMemberList(ClassInfo ci, ClassInfo fci,
        boolean staticMembers, String methodName) {
        List memberList = new LinkedList();
        findMemberList(ci, fci, staticMembers, memberList, methodName);
        Collections.sort(memberList, Comparators.simple);
        removeDuplicates(memberList);

        return memberList;
    }
    
    private static void findMemberList(ClassInfo ci, ClassInfo fci,
        boolean staticMembers, List memberList,
        String methodName) {
        ClassInfoFinder finder = Jane.getContextFinder();
        if (methodName == null) {
            for (Iterator i = ci.getClasses().iterator(); i.hasNext(); ) {
                ClassInfo mi = (ClassInfo)
                    finder.findClass(ci.getFullName() + '$' + (ClassInfo) i.next());
                if (mi != null &&
                    MemberInfoUtils.isAccessAllowed(fci, mi, staticMembers, finder, false)) {
                    memberList.add(mi);
                } 
            }
            for (Iterator i = ci.getFields().iterator(); i.hasNext(); ) {
                FieldInfo mi = (FieldInfo) i.next();
                if (MemberInfoUtils.isAccessAllowed(fci, mi, staticMembers, finder, false)) {
                    memberList.add(mi);
                }
            }
        }

        for (Iterator i = ci.getMethods().iterator(); i.hasNext(); ) {
            MethodInfo mi = (MethodInfo) i.next();
            if (methodName == null || methodName.equals(mi.getName())) {
                if (MemberInfoUtils.isAccessAllowed(fci, mi, staticMembers, finder, false)) {
                    memberList.add(mi);
                }
            }
        }

        String[] ifs = ci.getInterfaces();
        String sc = ci.getSuperclass();
        for (int i = 0; i < ifs.length; i++) {
            ci = finder.findClass(ifs[i]);
            if (ci != null) {
                findMemberList(ci, fci, staticMembers, memberList, methodName);
            }
        }
        if (sc != null) {
            ci = finder.findClass(sc);
            if (ci != null) {
                findMemberList(ci, fci, staticMembers, memberList, methodName);
            }
        }
    }
    
    // assumes list is already sorted
    public static void removeDuplicates(Collection list) {
        if (list.size() > 0) {
            Iterator i = list.iterator();
            Object prev = i.next();
            while (i.hasNext()) {
                Object o = i.next();
                if (o.equals(prev)) {
                    i.remove();
                }
                prev = o;
            }
        }
    }
    
    public static void keepOnlyThisName(List list, String methodName) {
        if (list.size() > 0) {
            Iterator i = list.iterator();
            Object prev = i.next();
            while (i.hasNext()) {
                MethodInfo mi = (MethodInfo) i.next();
                if (methodName != null && ! methodName.equals(mi.getName())) {
                    i.remove();
                }
            }
        }
    }
}
