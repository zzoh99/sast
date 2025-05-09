<%@	page	language="java"	contentType="text/html;	charset=UTF-8"	pageEncoding="UTF-8"%>
<%@	include	file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE	html>	<html	class="hidden">	<head>	<title></title>
<%@	include	file="/WEB-INF/jsp/common/include/meta.jsp"%>
<html	class="bodywrap">
<head>
<meta	http-equiv="Content-Type"	content="text/html;	charset=utf-8"	/>
<title></title>
<link	rel="stylesheet"	href="/common/css/dotum.css"	/>
<link	rel="stylesheet"	href="/common/theme1/css/style.css"	/>
<script src="${ctx}/common/js/jquery/3.6.1/jquery.min.js" type="text/javascript" charset="utf-8"></script>
<script src="${ctx}/common/js/ui/1.13.2/jquery-ui.min.js" type="text/javascript" charset="utf-8"></script>

<!--	COMMON	SCRIT	-->
<script	src="/common/js/common.js"></script>
<script	src="/common/js/commonIBSheet.js"></script>
<!--	IBSHEET		-->
<script	type="text/javascript"	src="/common/plugin/IBLeaders/Sheet/js/ibsheetinfo.js"></script>
<script	type="text/javascript"	src="/common/plugin/IBLeaders/Sheet/js/ibsheet.js"></script>

<link	rel="stylesheet"	type="text/css"	href="/common/plugin/IBLeaders/Sheet/css/style.css">
<link	rel="stylesheet"	type="text/css"	href="/common/plugin/IBLeaders/Sheet/css/nwe_common.css">

<script	type="text/javascript">

	var	isCall	=	true;
	var	result	=	null;

	$(function()	{
		window.onunload	=	function(){
			window.returnValue	=	"true";
			window.close();
		};

		setInterval(progress,	100)	;

	});

	var	percent	=	0;
	function	progress()	{
		percent+=5;
		if(	percent	>	100	)	percent	=	0;

		setProgress(percent);
	}

	function	setProgress(value)	{

		$("#progressTxt").text(value);
		$("#progressBar").width(value+"%");

		if(isCall){

			var	url	=	"${ctx}/DictMgr.do?cmd=createDictMgrList";
			var	async	=	true;
			var	params	=	"";

			$.ajax({
				url		:	url,
				type	:	"post",
				dataType:	"json",
				async	:	async,
				data	:	params,
				success	:	function(data)	{
					obj	=	data;
					alert("작업이	완료되었습니다.");
					window.open('','_self').close();
				},
				error	:	function(jqXHR,	ajaxSettings,	thrownError)	{
					ajaxJsonErrorAlert(jqXHR,	ajaxSettings,	thrownError);
					window.open('','_self').close();
				}
			});
			isCall	=	false;
		}
	};
</script>
</head>
<body	class="bodywrap">
<div	class="wrapper">
	<div	class="popup_title">
	<ul>
		<li><tit:txt mid='104346' mdef='잠시만	기다려	주세요...'/></li>
	</ul>
	</div>

	<div	class="popup_main">
		<table	border="0"	cellpadding="0"	cellspacing="0"	class="table">
		<colgroup>
			<col	width="80%"	/>
			<col	width="20%"	/>
		</colgroup>
		<tr>
			<td><div	class="progressbar"><div	id="progressBar"></div></div></td>
			<td	class="center"><span	id="progressTxt"	class="tPink	strong">75</span>	%</td>
		</tr>
		</table>
	</div>

</div>

</body>
</html>
