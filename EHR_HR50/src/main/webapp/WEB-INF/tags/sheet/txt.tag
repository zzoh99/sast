<%@ tag language="java" pageEncoding="UTF-8" body-content="empty"
%><%@ tag import="com.hr.common.language.LocaleUtil"
%><%@ attribute name="mid" required="true"
%><%@ attribute name="mdef"
%><%@ attribute name="margs"
%><%
	String   msg = "";
	String[] arrMid = null;
	String[] arrMdef = null;
	String[] arrMargs = null;

	if(mid != null && mid.length() > 0 && mid.contains("|")) {
		arrMid = mid.split("\\|");
	}
	
	if(mdef != null && mdef.length() > 0) {
		arrMdef = mdef.split("\\|");
	}

	if(margs != null && margs.length() > 0) {
		arrMargs = margs.split("\\|");
	}
	
	if(arrMid != null && arrMid.length > 0 && arrMdef != null && arrMdef.length > 0 && arrMid.length == arrMdef.length ){
		for(int i = 0, len = arrMid.length; i < len; i++) {
			String shtMid = arrMid[i];
			String shtMdef = "";
			String shtMargs = "";

			if(mdef != null && arrMdef.length > i) {
				shtMdef = arrMdef[i];
			}

			if(margs != null && arrMargs.length > i) {
				shtMargs = arrMargs[i];
			}

			if(i == 0) {
				msg += shtMdef;
			} else {
				msg += String.format("|%s", LocaleUtil.getMessage(request, "sht", shtMid, shtMdef, shtMargs, null));
			}
		}
	} else {
		msg += LocaleUtil.getMessage(request, "sht", mid, mdef, margs, null);
	}
%><%= msg %>