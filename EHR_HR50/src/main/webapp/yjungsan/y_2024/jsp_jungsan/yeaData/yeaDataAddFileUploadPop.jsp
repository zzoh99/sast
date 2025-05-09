<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>연말정산 PDF 업로드 테스트</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>

<script language="JavaScript">
//<!--
	var p = eval("<%=popUpStatus%>");
	var errorCnt = 0;
	var exeYn = "N"; //실행여부
	var limitFileSize = 0; //업로드 제한 파일 사이즈 크기
    var fileCnt = 0;//최대 파일 업로드 갯수
    var errorFlag = false;
    var fileUploadType = '0';
    
    var counter = 0;
    var isIE = false;
	$(function(){

		var arg = p.window.dialogArguments;
		
		var agent = navigator.userAgent.toLowerCase();
		if((navigator.appName == 'Netscape' && navigator.userAgent.search('Trident') != -1) || (agent.indexOf("msie") != -1)){
			isIE = true;
		}
		if(isIE){
    		$("#fileInfoText").text('');
    	}

        var searchWorkYy     	= "";
		var searchAdjustType	= "";
		var searchSabun      	= "";
		var searchSbNm       	= "";
		var searchFileType		= "";
		
		if( arg != undefined ) {
			searchWorkYy      	= arg["searchWorkYy"];
			searchAdjustType  	= arg["searchAdjustType"];
			searchSabun       	= arg["searchSabun"];
			searchSbNm			= arg["searchSbNm"];
			searchFileType      = arg["searchFileType"];
		}else{
			searchWorkYy      	= p.popDialogArgument("searchWorkYy");
			searchAdjustType  	= p.popDialogArgument("searchAdjustType");
			searchAdjustTypeElement  	= p.popDialogArgument("searchAdjustTypeElement");
			searchSabun       	= p.popDialogArgument("searchSabun");
			searchSbNm       	= p.popDialogArgument("searchSbNm");
			searchFileType     	= p.popDialogArgument("searchFileType");
		}

		$("#searchWorkYy").val(searchWorkYy);
		$("#searchAdjustType").val(searchAdjustType) ;
		$("#searchSabun").val(searchSabun) ;

		$("#popWorkYy").html(searchWorkYy) ;
		$("#popSabun").html(searchSabun) ;
		$("#popSbNm").html(searchSbNm) ;

		var adjustTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYear=<%=yeaYear%>", "C00303"), "전체" );
		var fileTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&useYn=Y&searchYear=<%=yeaYear%>", "YEA001"), "전체" );
		
		if(searchFileType == null || searchFileType == undefined || searchFileType.length == 0) {
			searchFileType = "";
		}

		$("#popFileType").html(fileTypeList[2]).val(searchFileType);
		
		//$("#popAdjustType").html(adjustTypeList[2]).val(searchAdjustType);

		//업로드 파일사이즈 설정 조회
		limitFileSize = ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&searchStdCd=CPN_YEAREND_LIMIT_SIZE", 'queryId=getSystemStdData',false).codeList[0].code_nm;
		//파일업로드 type 조회
		fileUploadType = ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&searchStdCd=CPN_YEA_FILE_UPLOAD_TYPE", "queryId=getSystemStdData",false).codeList[0];
		if(fileUploadType != null){
			//fileUploadType = fileUploadTypeList.code_nm
			$("#fileUploadType").val(fileUploadType.code_nm);
		} else {
			$("#fileUploadType").val('0');
		}
		
		getCprBtnChk();
	});

	function goAction(){

		if(exeYn == 'N') {
			if($("#inptUpload").val() == "") {
				alert("업로드 파일을 선택해주세요.");
				return;
			}
			
			if($("#popFileType").val() == ""){
				alert("파일구분을 선택해주세요.");
				return;
			}

			if(errorCnt > 0) {
				alert('업로드 할 수 없는 파일이 존재합니다.\n파일을 확인해 주세요');
				return;
			}
		    if(fileCnt > 10){
		    	 alert("파일 갯수가 10개가 넘습니다. \n압축파일로 업로드 해주세요.");
		    	 return;
		    }else{	
				exeYn = "Y";
				$("#progressCover").show();
				$("#searchFileType").val($("#popFileType").val()) ;
				if(fileUploadType == '1'){
					$("#uploadForm").attr({"method":"POST","target":"ifrmFileUpload","action":"yeaDataAddFileUploadPopRstS3.jsp"}).submit();
                } else{
                	$("#uploadForm").attr({"method":"POST","target":"ifrmFileUpload","action":"yeaDataAddFileUploadPopRst.jsp"}).submit();
                }
		    }
		} else {
			alert("처리중입니다. 잠시만 기다려 주세요.");
		}
	}
	//대상자성명 UPDATE
    function saveNmTxt(){
        var param = "searchWorkYy="+$("#searchWorkYy").val();
            param += "&searchAdjustType="+$("#searchAdjustType").val();
            param += "&searchSabun="+$("#searchSabun").val();
            param += "&searchFileType="+$("#searchFileType").val();
            param += "&fileUploadType="+$("#fileUploadType").val();
        
            
        var chk = false;
        /*
        for(var row=1; row<=sheet1.RowCount(); row++){
        	if(sheet1.GetCellValue(row, "nm_txt") != ''){
        		chk = true;
        	} 	
        }
        if(chk){
        	if(confirm("대상자 성명을 저장하시겠습니까?")){
            	sheet1.DoSave( "<%=jspPath%>/yeaData/yeaDataAddFileUploadPopRst.jsp?cmd=saveNmTxt",param,-1,0);	
            }
        }
        */
    }
    
    function changeFile(obj){

		var ext = ""; //파일 확장자
		errorCnt = 0; //초기화

		if(sheet1.RowCount() > 0) {
			for(var j = sheet1.RowCount() ; j >= 1; j--){
				sheet1.RowDelete(j,0);
			}
		}
		
		fileCnt = (obj == null || obj[0].files == null) ? 0 : obj[0].files.length;
		
		if (obj != null && obj[0].files != null) {
			for (var i = 0; i < obj[0].files.length; i++) {
				var file = obj[0].files[i];
				
				ext = file.name.split('.').pop().toLowerCase();
	
				sheet1.DataInsert();
				sheet1.SetCellValue(i+1, "file_name", file.name);
				sheet1.SetCellValue(i+1, "file_size", comma(file.size));
				sheet1.SetCellValue(i+1, "file_type", ext.toUpperCase());
	
				var adjustType = $("#searchAdjustType").val();
	
				if($.inArray(ext, ['pdf','hwp','txt','doc','docx','ppt','pptx','xls','xlsx','zip','rar','alz','egg','7z','jpg','jpeg','gif','png','tiff','bmp']) == -1) {
					//파일확장자 체크
					sheet1.SetRowBackColor(i+1, "#FAD5E6") ;
					sheet1.SetCellValue(i+1, "error_code", "1");
					sheet1.SetCellValue(i+1, "memo", "업로드 할 수 없는 파일 형식입니다.");
					errorCnt++;
				} else if(!(adjustType == '1' || adjustType == '3')) {
					//정산구분 체크
					sheet1.SetRowBackColor(i+1, "#FAD5E6") ;
					sheet1.SetCellValue(i+1, "error_code", "3");
					sheet1.SetCellValue(i+1, "memo", "정산구분을 확인해 주세요.(1-연말정산, 3-퇴직정산)");
					errorCnt++;
				} else if(file.size > limitFileSize) {
					//파일크기 체크
					sheet1.SetRowBackColor(i+1, "#FAD5E6") ;
					sheet1.SetCellValue(i+1, "error_code", "4");
					sheet1.SetCellValue(i+1, "memo", (limitFileSize/(1024*1024))+"MB 이하의 파일만 업로드 할수 있습니다.");
					errorCnt++;
				} else {
					sheet1.SetCellValue(i+1, "error_code", "0");
				}
			}
		}

		sheet1.RenderSheet(1);

	}

	//콤마찍기
    function comma(str) {
        str = String(str);
        return str.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
    }

	function procYn(err,message,memo){
		//console.log(err); //ie 구버전 사용 고객사 오류 발생. 20240105
		//console.log(message); //ie 구버전 사용 고객사 오류 발생. 20240105
		//console.log(memo); //ie 구버전 사용 고객사 오류 발생. 20240105
		//Input_file_
		$("#progressCover").hide();

		errorCnt = 0; //초기화
		exeYn = "N";

		var rv = $.parseJSON(memo);

		if(rv != null && rv.length > 0) {
			for (var i = 0;  i < rv.length; i++) {
				var strNm = '.Input_file_'+i;
				//console.log(strNm); //ie 구버전 사용 고객사 오류 발생. 20240105
				if(rv[i].errorCode == '0'){
					//console.log("업로드 성공"); //ie 구버전 사용 고객사 오류 발생. 20240105
					$(strNm + " .status").text('업로드 성공');
				} else{
					//console.log("업로드 실패"); //ie 구버전 사용 고객사 오류 발생. 20240105
					$(strNm + " .status").text('업로드 실패');
				}

				if(rv[i].errorCode > 0) {
					errorCnt++;
					errorFlag = true;
				} else {
					if(rv[i].errorMessage.length > 0) {
						errorFlag = false;
					}
				}
			}
		}

		if(err=="Y"){
		  alert(message);
		  if (p.window.opener) {
		    //p.window.opener.doAction1("Search");
// 		    p.window.opener.goSearch($("#searchFileType").val());
		    //p.window.close();
		    }
		} else {
		  alert(message);
		}
        if(!errorFlag){
          close();
          //saveNmTxt();
        }		
	}

	function close(){
		p.window.opener.goSearch($("#searchFileType").val());
		p.window.close();
	}
	
	function uploadHandler() {
		var fileInput = document.getElementById('basic');
		
		// 선택된 파일이 있는지 확인
        if (fileInput != null && fileInput.files != null && fileInput.files.length > 0) {
            // 첫 번째 선택된 파일의 파일명 출력
    		handleFileUpload(fileInput.files);
        } else {
        	alert('파일이 선택되지 않았습니다.');
        }
	}
	
	function handleFileUpload(files) {
		errorCnt = 0; //초기화
		var fileInfoContainer = document.getElementById("fileInfoContainer");
		// 기존에 추가된 파일 정보를 모두 제거
        fileInfoContainer.innerHTML = '';
		
		fileCnt = (files == null) ? 0 : files.length;
		
		for (var i = 0; i < fileCnt; i++) {
			var file = files[i];
			$("#fileInfoWrap").show() ;
			$("#fileInfoMesage").hide() ;
			//document.getElementById('fileNm').innerText = file.name;
			
			// 파일명을 표시할 span 요소 생성
            var fileNameSpan = document.createElement("span");
            fileNameSpan.className = "file-name";
            fileNameSpan.textContent = file.name;

            // 파일 상태를 표시할 span 요소 생성 (예: 업로드 중, 완료 등)
            var statusSpan = document.createElement("span");
            statusSpan.className = "status";
            statusSpan.textContent = "업로드 안됨";
            
            // 파일 정보를 감싸는 span 요소 생성
            var fileDiv = document.createElement("div");
            fileDiv.className = "Input_file_"+i;
            fileDiv.style.display = 'flex';
            fileDiv.appendChild(fileNameSpan);
            fileDiv.appendChild(statusSpan);

            // 파일 정보를 컨테이너에 추가
            fileInfoContainer.appendChild(fileDiv);
		}		
    }
	
	function dropHandler(event) {
        event.preventDefault();
        if(isIE){
        	var dropZone = document.getElementById('basic_drop_zone');
    		alert("Internet Explore에서는 파일선택을 통해서만 업로드가 가능합니다.");
    		dropZone.classList.remove('highlight');
    		return;
    	}
        // 드롭된 파일 가져오기
        var files = event.dataTransfer.files;
        
        // 업로드 로직 수행
        handleFileUpload(files,false);
        $("#basic").prop('files',files);
    }
	
	function enterDropZone(event) {
		event.preventDefault();
		counter++;
		var dropZone = document.getElementById('basic_drop_zone');
		dropZone.classList.add('highlight');
	}
	
	function leaveDropZone() {
		counter--;
		var dropZone = document.getElementById('basic_drop_zone');
        if (counter === 0) { 
          dropZone.classList.remove('highlight');
        }
	}
	
	//수정(이력) 관련 세팅
	function getCprBtnChk(){
        var params = "&cmbMode=all"
                   + "&searchWorkYy=" + $("#searchWorkYy").val()
                   + "&searchAdjustType="
                   + "&searchSabun=" ;
		
        //재계산 차수 값 조회
		var strUrl = "<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&queryId=getReCalcSeq884" + params ;
		var searchReCalcSeq = stfConvCode( codeList(strUrl,"") , "");
		
		if(searchReCalcSeq == null || searchReCalcSeq == "" || searchReCalcSeq[0] == "") {
			$("#popAdjustType").html("");
		} else {   			
  			$("#popAdjustType").html("<option value=''>전체</option>" + searchReCalcSeq[2]);
  			if($("#popAdjustType") != ''){
  				$('#popAdjustType option[value='+ $("#searchAdjustType").val() +']').attr('selected', true);
  			}
		}
	}
//-->
</script>
</head>
<body class="bodywrap">
	<div id="progressCover" style="display:none;position:absolute;top:0;bottom:0;left:0;right:0;background:url(<%=imagePath%>/common/process.png) no-repeat 50% 50%;"></div>
    <div class="wrapper">
        <div class="popup_title">
            <ul>
                <li>파일 업로드</li>
                <!--<li class="close"></li>-->
            </ul>
        </div>
        <div class="popup_main">
        <div style="margin-top: 8px;">
        	<table cellpadding="0" cellspacing="0" class="default outer">
				<colgroup>
					<col width="10%" />
					<col width="11%" />
					<col width="10%" />
					<col width="11%" />
					<col width="10%" />
					<col width="11%" />
					<col width="" />
				</colgroup>
				<tr>
					<th>성명</th>
					<td id="popSbNm"></td>
					<th>사번</th>
					<td id="popSabun"></td>
					<th>귀속년도</th>
					<td id="popWorkYy"></td>
				</tr>
				<tr>
					<th>정산구분</th>
					<td><select id="popAdjustType" name ="popAdjustType" class="box" disabled="disabled"></select></td>
					<th>파일구분</th>
					<td><select id="popFileType" name ="popFileType" class="box"></select></td>
					<th></th>
					<td></td>
				</tr>
			</table>
        </div>
		<form id="uploadForm" method="post" enctype="multipart/form-data">
		<input type="hidden" id="searchWorkYy" name="searchWorkYy" value="" />
		<input type="hidden" id="searchAdjustType" name="searchAdjustType" value="" />
		<input type="hidden" id="searchSabun" name="searchSabun" value="" />
		<input type="hidden" id="searchFileType" name="searchFileType" value="" />
		<input type="hidden" id="fileUploadType" name="fileUploadType" value="" />
		<!-- PDF 등록 파일업로드 Start -->
		<!--
		<div class="outer">
			<table border="0" cellpadding="0" cellspacing="0" class="default outer" id="fileUpload">
			    <colgroup>
			        <col width="80%" />
			        <col width="20%" />
			    </colgroup>
			    <tr>
			        <th class="center">파일찾기</th>
			        <th class="center">업로드</th>
			    </tr>
			    <tr>
			        <td class="center">
			            <input type="file" multiple="multiple" id="inptUpload" name="upload" class="text" style="width:100%;">
			        </td>
			        <td class="center">
			        	<a href="javascript:goAction();" class="basic btn-upload" title="전자문서 제출">업로드</a>
			        </td>
			    </tr>
		    </table>
		</div>
		-->
		<div class="file-upload">
          <input type="file" name="file" multiple="multiple" id="basic" class="simple-upload" onchange="uploadHandler()">
          <div id="basic_drop_zone" class="dropZone simple-upload simple-upload-droppable" ondrop="dropHandler(event)" ondragover="event.preventDefault()" ondragenter="enterDropZone(event)" ondragleave="leaveDropZone(event)">
            <div class="inner-wrap">
              <div class="img-wrap">
                <img src="../../../common_jungsan/images/common/file-pdf-box_2x.png" alt="">
              </div>
              <div class="info-wrap">
                <a class="basic btn-white out-line btn-fileSelect" href="javascript:void(0);" onclick="document.getElementById('basic').click();">파일선택</a>
                <p class="info" id="fileInfoText">또는 증빙자료 파일 끌어놓기</p>
              </div>
            </div>
          </div>
          <div id="basic_progress" class="simple-upload"></div>
          <div id="basic_message" style="height: 187px;">
            <p class="desc text-center" id="fileInfoMesage">선택한 파일 정보가 표시됩니다.</p>
            <div class="file-info-wrap" id="fileInfoWrap" style="display:none">
              <div class="file-info" id="fileInfoContainer" style="display: block; align-items: center;">
                <span>
                  <span class="file-name" id="fileNm"></span>
                </span>
                <span class="status" id="uploadN">업로드 안됨</span>
                <span class="status upload" id="uploadS" style="display:none">업로드 됨</span>
              </div>
            </div>
          </div>
          <div class="btn-wrap text-center">
            <a href="javascript:goAction();" class="btn-upload" id="uploadBtn">업로드</a>
          </div>
		<!-- PDF 등록 파일업로드 End -->
		</form>
		<!--<script type="text/javascript">createIBSheet("sheet1", "100%", "200px"); </script>
		-->
		<iframe id="ifrmFileUpload" name="ifrmFileUpload" width="0" height="0" src="" border="0" frameborder="0" marginwidth="0" marginheight="0"></iframe>
        <!--
        <div class="popup_button outer">
            <ul>
                <li>
                    <a href="javascript:close();" class="gray large">닫기</a>
                </li>
            </ul>
        </div>
        -->
        </div>
    </div>
</body>
</html>