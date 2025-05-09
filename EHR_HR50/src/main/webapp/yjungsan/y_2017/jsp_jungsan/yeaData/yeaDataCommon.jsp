<%
	String adminYn = ( request.getParameter("orgAuthPg") != null && "A".equals(request.getParameter("orgAuthPg")) ) ? "Y" : "N";

	String headerColorA = "#cdf0f1" ;
	String headerColorB = "#c7e5ff" ;
	
%>  

<style type="text/css">
	table.yeaData1 th.yeaData2 {background-color:#cdf0f1; border:1px solid #afcdce;}
	table.yeaData1 td.yeaData2 {background-color:#e6f4f5; border:1px solid #afcdce;}
	table.yeaData1 td.yeaData2 input {border:1px solid #afcdce;}
	
	table.yeaData1 th {background-color:#c7e5ff; border:1px solid #acd5fe;}
	table.yeaData1 td {background-color:#e4f7ff; border:1px solid #acd5fe;}
	table.yeaData1 td input {border:1px solid #acd5fe;}
	
	table.yeaData2 th {background-color:#cdf0f1; border:1px solid #afcdce;}
	table.yeaData2 td {background-color:#e6f4f5; border:1px solid #afcdce;}
	table.yeaData2 td input {border:1px solid #afcdce;}
	
		
	.table-pdf {width:100%; text-align:center}
	.table-pdf td {padding:5px}
	a.pdf.disabled {color:#a6a699 !important;border:1px solid #ccccc0 !important}
	a.pdf {display: inline-block;line-height: 125%;margin-right: .1em;cursor: pointer;vertical-align: middle;text-align: center;overflow: visible; /* removes extra width in IE */background:#f4f4ee url(bg_button_pdf.png) center bottom repeat-x;color: #666652 !important;font-size:12px;border:1px solid #bbbbaf;letter-spacing:-1px;word-break:keep-all; /* padding+size */ padding: 14px 10px 5px 11px;padding:12px 11px 5px 10px\9;width:85%; height:68px;}
	a:hover.pdf {color:#39392b !important}
	a:hover.pdf.disabled {color:#a6a699 !important}
	a.pdf .pdfItem {font-size:1.125em; font-weight:700; padding-bottom:12px; display:block}
	a.pdf .pdfAmt {letter-spacing:.75px; display:block}
	a.pdf .pdfCnt {font-size:11px; display:block}
	
</style>