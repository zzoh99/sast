<%@page import="com.hr.common.util.fileupload.impl.FileUploadConfig"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%
String uploadType = "pht001";
request.setAttribute("uploadType", uploadType);
FileUploadConfig fConfig = new FileUploadConfig(uploadType);
request.setAttribute("fConfig", fConfig.getPropertyByJSON());
%>
<!DOCTYPE html> <html class="hidden"><head> <title>개인사진관리</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<!-- <script src="http://malsup.github.com/jquery.form.js"></script>  -->
<script type="text/javascript" src="/common/plugin/Fileupload/jquery/jquery.form.js"></script>
<script type="text/javascript" src="/common/plugin/Fileupload/jquery/jquery.fileupload.js"></script>

<link rel="stylesheet" type="text/css" href="/common/plugin/Fileupload/css/jquery_ui_style.css" />
<link rel="stylesheet" type="text/css" href="/common/plugin/Fileupload/css/fileuploader_style.css" />

<script type="text/javascript">
	$(function() {
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,MergeSheet:0,Page:22,FrozenCol:0,DataRowMerge:0};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
			{Header:"No",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"소속도명",		Type:"Text",	Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"orgChartNm",	KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"시작일",			Type:"Text",	Hidden:1,	Width:0,	Align:"Left",	ColMerge:0,	SaveName:"sdate",		KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"상위소속코드",	Type:"Text",	Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"priorOrgCd",	KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"조직명",			Type:"Text",	Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"orgNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100,    TreeCol:1 },
			{Header:"팀",			Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"orgCd",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 }
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable(false);sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		var initdata2 = {};
		initdata2.Cfg = {SearchMode:smLazyLoad,MergeSheet:0,Page:22,FrozenCol:0,DataRowMerge:0};
		initdata2.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};

		initdata2.Cols = [
			{Header:"No",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"상태",			Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"다운",			Type:"DummyCheck", Hidden:0,  Width:30,	Align:"Center",	ColMerge:0,	SaveName:"sChk",	KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1 },
			{Header:"회사구분",			Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"enterCd",	KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"소속코드",			Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"orgCd",	KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"소속",			Type:"Text",	Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"orgNm",	KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"PAYBAND코드",	Type:"Text",	Hidden:1,	Width:70,	Align:"Center",  	ColMerge:0,   SaveName:"jikweeCd",    KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"PAYBAND",		Type:"Text",	Hidden:1,	Width:70,	Align:"Center",  	ColMerge:0,   SaveName:"jikweeNm",    KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"직급코드",	Type:"Text",      Hidden:1,  Width:70,   Align:"Center",  	ColMerge:0,   SaveName:"jikgubCd",    KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"직급",		Type:"Text",      Hidden:0,  Width:70,   Align:"Center",  	ColMerge:0,   SaveName:"jikgubNm",    KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"사번",		Type:"Text",      Hidden:0,  Width:70,   Align:"Center",  	ColMerge:0,   SaveName:"sabun",       KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"성명",		Type:"Text",      Hidden:0,  Width:70,   Align:"Center",  	ColMerge:0,   SaveName:"name",        KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"파일순번",	Type:"Text",      Hidden:1,  Width:70,   Align:"Center",  	ColMerge:0,   SaveName:"fileSeq",        KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"일련번호",	Type:"Text",      Hidden:1,  Width:70,   Align:"Center",  	ColMerge:0,   SaveName:"seqNo",        KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 }
		]; IBS_InitSheet(supSheet2, initdata2);supSheet2.SetEditable("${editable}");supSheet2.SetVisible(true);supSheet2.SetCountPosition(4);

		sheet1.ShowTreeLevel(-1);

		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");

	});
	
	$(function() {
		$("#btnPlus").click(function() {
			sheet1.ShowTreeLevel(-1);
		});

		$("#btnStep1").click(function()	{
			sheet1.ShowTreeLevel(0, 1);
		});

		$("#btnStep2").click(function()	{
			sheet1.ShowTreeLevel(1,2);
		});

		$("#btnStep3").click(function()	{
			sheet1.ShowTreeLevel(-1);
		});

		var options = $.extend(true, ${fConfig}, {
			context:"${ctx}",
			event:{
				success: function(jsonData) {
					if(jsonData.data !== undefined && jsonData.data !== null && jsonData.data.length > 0) {
						var params = function(p) {
							var rtn = "sabun="+encodeURIComponent($("#sabun").val()) + "&gubun=1";
							$.each(p, function(key, value) {
								rtn += "&" + key + "=" + encodeURIComponent(value);
							});
							
							return rtn
						}(jsonData.data[0]);
						
						var result = ajaxCall("/EmployeePhotoSave.do", params, false).result;
						if(result.code == "success") {
							downloadFile((new Date()).getTime());
						} else {
							alert(result.message);
						}
					}
				},
				error: function(jsonData) {
					alert(jsonData.msg);
				}
			}
		}),
		params = {
			'uploadType' :"${uploadType}",
			'fileSeq' : '',
			'sabun' : function() {return $("#sabun").val();}
		};

		$("#fileuploader").fileupload("init", options, params);

		// 파일선택 onclick시 file count 값 초기화 작업
		initFileUploader(options, params)
			.then(() => {
				$('.browse-btn').on('click', function(evt) {
					$("#fileuploader").fileupload("setCount", options.el, 0);
				});
			});

		$("#lower").change(function(){
			doAction2("Search");
		});
	});

	// 파일선택 onclick 이벤트 설정을 위해 promise 함수 생성
	function initFileUploader(options, params) {
		return new Promise((resolve, reject) => {
			try {
				// fileupload 초기화
				$("#fileuploader").fileupload("init", options, params);
				resolve();
			} catch (error) {
				reject(error); // 예외가 발생하면 프로미스를 거부
			}
		});
	}

	function remove(){
		$("#photo").attr("src","/common/images/common/img_photo.gif");
	}

	function downloadFile(){
		$("#photo").attr("src", "${ctx}/EmpPhotoOut.do?enterCd="+$("#enterCd").val()+"&searchKeyword="+$("#sabun").val()+"&t="+new Date().getTime());
	}	

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch( "${ctx}/EmpPictureMgr.do?cmd=getEmpPictureMgrOrgList","" );
			break;
		}
	}

	//Sheet2 Action
	function doAction2(sAction) {
		switch (sAction) {
		case "Search":
				var lower = "0";
			if($("input:checkbox[name='lower']").is(":checked") == true) {
				lower = "1";
			}
			var param = "orgCd="+sheet1.GetCellValue(sheet1.GetSelectRow(),"orgCd") + "&lower="+lower ;
			supSheet2.DoSearch( "${ctx}/EmpPictureMgr.do?cmd=getEmpPictureMgrUserList", param, 1 );
			break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}

			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			doAction1("Search");
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	// 셀 변경시 발생
	function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol) {
		try {
			if(sheet1.GetSelectRow() > 0) {
				if(OldRow != NewRow) {
					doAction2("Search");
				}
			}
		} catch (ex) {
			alert("OnSelectCell Event Error " + ex);
		}
	}

	// 조회 후 에러 메시지
	function supSheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			sheetResize();
			
			if(supSheet2.RowCount() == 0) {
				$("#txtSabun").text("");
				$("#sabun").val("");
				$("#txtName").text("");
				remove();
			}
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 저장 후 메시지
	function supSheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}

			doAction2("Search");
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}
	
	// 셀 변경시 발생
	function supSheet2_OnSelectCell(OldRow, OldCol, NewRow, NewCol) {
		try {
			if(supSheet2.GetSelectRow() > 0) {
				if(OldRow != NewRow) {
					$("#txtSabun").text(supSheet2.GetCellValue(NewRow,"sabun"));
					$("#sabun").val(supSheet2.GetCellValue(NewRow,"sabun"));
					$("#txtName").text(supSheet2.GetCellValue(NewRow,"name"));
					downloadFile();
				}
			}
		} catch (ex) {
			alert("OnSelectCell Event Error " + ex);
		}
	}

	function fileDownload() {
		var rows = supSheet2.FindCheckedRow("sChk");
		
		if(rows == "") {
			alert("체크된 항목이 없습니다.");
			return;
		}
		
		var rowarr = rows.split("|");
		var returnFileName = "";
		var params = [];
		for(var i=0;i<rowarr.length;i++) {
			params[i] = supSheet2.GetRowJson(rowarr[i]);
		}
		$.filedownload("${uploadType}", params);
		
		
// 		var downType = $("#downType option:selected").val();
// 		var saveData = supSheet2.GetSaveString(false,true,"sChk");
// 		imageDownload("STATUS=DOWNLOAD"+"&"+saveData);
	}
	
	function phtoOnLoad(imgObj) {
		
		if( !$("#area_resize").hasClass("hide") ) {
			$("#area_resize").addClass("hide");
		}
		
		var img = new Image();
		var _width, _height;
		img.src = imgObj.src;
		
		img.onload = function() {
			if( this.width != 70 && this.height != 91 ) {
				//console.log('img', this);
				$("#txt_width").html(this.width);
				$("#txt_height").html(this.height);
				if( this.width > 180 ) {
					$("#btn_resize").removeClass("hide");
				}
				$("#area_resize").removeClass("hide");
			}
		}
	}
	
	function resize() {
		var param = "searchKeyword=" + $("#sabun").val();
		var data = ajaxCall("${ctx}/EmployeePhotoResize.do", param, false);
		if( data != null && data != undefined ) {
			if( data.result.message != null && data.result.message != undefined && data.result.message != "" ) {
				alert(data.result.message);
			}
			if( data.result.code != null && data.result.code != undefined && data.result.code == "success" ) {
				downloadFile();
			}
		}
	}
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
	<colgroup>
		<col width="30%" />
		<col width="70%" />
	</colgroup>
	<tr>
		<td class="sheet_left">
			<div class="inner">
				<div class="sheet_title">
				<ul>
					<li class="txt">조직
						<div class="util">
						<ul>
							<li	id="btnPlus"></li>
							<li	id="btnStep1"></li>
							<li	id="btnStep2"></li>
							<li	id="btnStep3"></li>
						</ul>
						</div>
					</li>
					<!-- <li class="txt" >하위조직포함
						<div class="util  padding-left-xl">
							<input type="checkbox" id="lower" name="lower" />
						</div>
					</li> -->
					<li class="btn">
<!-- 						<a href="javascript:doAction1('Search');" class="button">조회</a> -->
					</li>
				</ul>
				</div>
			</div>
			<script type="text/javascript"> createIBSheet("sheet1", "30%", "100%"); </script>
		</td>
		<td class="sheet_right">
			<div class="inner">
				<div class="sheet_title">
				<ul>
					<li class="txt">조직원</li>

					<li class="btn">
						<!-- <select id="downType" name="downType" style="width: 80px;" class="box-back" >
							<option value="0">사번</option>
							<option value="1">이름</option>
						</select> -->
						<input type="checkbox" class="checkbox" id="lower" name="lower" onClick="doAction2('Search');" style="vertical-align:middle;"/><b>하위조직포함</b>
						<a href="javascript:fileDownload();" class="btn outline_gray" >다운로드</a>
					</li>
				</ul>
			</div>
			<script type="text/javascript"> createIBSheet("supSheet2", "70%", "90%"); </script>
			<input type="hidden" name="utype" id="utype" value="picture" />	
			<div class="inner">
				<div class="sheet_title" style="overflow: hidden;">
					<ul>
						<li class="txt">사진등록</li>
						<li class="btn">
							<div id='fileuploader' class="fileuploader" align='right'></div>
							<input type="hidden" id="sabun" name="sabun" />
							<input type="hidden" id="enterCd" name="enterCd"/>
						</li>
					</ul>
				</div>
			</div>
			
			<table border="0" cellpadding="0" cellspacing="0" class="default inner fixed">
			<colgroup>
				<col width="" />
				<col width="20%" />
				<col width="" />
			</colgroup>
			<tr>
				<td rowspan="3" class="photo"><img src="/common/images/common/img_photo.gif" id="photo" width="110" height="165" onerror="javascript:this.src='/common/images/common/img_photo.gif'" onload="javascript:phtoOnLoad(this);"></td>
				<th>사번</th>
				<td><span id="txtSabun"></span></td>
			</tr>
			<tr>
				<th>성명</th>
				<td><span id="txtName"></span></td>
			</tr>
			<tr>
				<td colspan="2" class="h40">
					- 업로드 기준 사이즈 : 180px * 270px<br/>
					- 확장자 : jpg,jpeg 만 가능합니다.(ex) aa.jpg, aa.jpeg<br/>
					<div id="area_resize" class="mat10 hide">
						사진 실제 크기 : <span id="txt_width" class="f_red"></span> px X <span id="txt_height" class="f_red"></span> px
						&nbsp;&nbsp;
						<a href='javascript:resize();' id="btn_resize" class='button hide' title='사진크기조정'>사진크기조정</a>
					</div>
				</td>
			</tr>
			</table>
		</td>
	</tr>
	</table>
</div>
</body>
</html>