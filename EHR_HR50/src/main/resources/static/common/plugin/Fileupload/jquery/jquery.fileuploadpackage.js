/*
 * sheet upload package  IBSheet 초기화
 */
/*
function authPg(){
	var initdata = {};
	initdata.Cfg = {SearchMode:smLazyLoad,Page:20};
	initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
	initdata.Cols = [
	             	{Header:"상태",Type:"Status",Width:60,SaveName:"sStatus", Hidden:1},
	             	{Header:"선택",Type:"CheckBox",Width:40,SaveName:"chk"},
	             	{Header:"물리파일명",Type:"Text",Width:100,SaveName:"PFILENAME"},
	             	{Header:"파일명",Type:"Text",Width:250,SaveName:"LFILENAME"},
	             	{Header:"파일위치",Type:"Text",Align:"Center",Width:60,SaveName:"FILEPATH"},
	             	{Header:"크기(byte)",Type:"Int",Width:60,SaveName:"FILESIZE",Format:"#,###"}
	         	];
	IBS_InitSheet(supSheet, initdata);
	supSheet.FitColWidth();
}
*/

/*
 * sheet upload package  Upload 초기화
 */

function init_supUpload(){
	try{
//		if(!uploadProgramPath){
			supUpload.InitHostInfo(location.hostname,location.port,page_path,uploadProgramPath);
//		}
		//alert(location.hostname+","+location.port+","+page_path+","+uploadProgramPath);
		//supUpload.UploadType = 2; //버튼만 보이기.
		supUpload.ShowButtonList( "SELECTFILES"); //파일 추가 버튼만 보여주자.
		supUpload.ButtonImage(0,"/common/images/common/btn_file_add.jpg");
		supUpload.ButtonOverImage(0,"/common/images/common/btn_file_add.jpg");
		supUpload.OutLineBorder = 0;
		supUpload.MultiUploads = 1; //파일을 하나씩 서버로 전달한다.
		//디버깅 사용 -1 , 끄기 -2
		supUpload.ShowDebugMsg = -2;
	}catch(e){
		alert(e.message);
	}
}






/*
 * IBUpload 에 파일 추가시 발생 이벤트
 * desc: 파일 추가시 IBSheet에 파일 정보를 Insert 한다.
 */
function mainUpload_OnAddFile(FileName, FileSize){

	try{
		if(supUpload.TotalUploadedFiles!=0){
			//한번 업로드 후에는 재업로드는 불가능함.
			return;
		}

		var r = supSheet.DataInsert(-1);

		supSheet.SetCellText(r,"rFileNm",FileName);
		supSheet.SetCellText(r,"fileSize",FileSize);
		supSheet.SetCellText(r,"filePath","로컬");

	}catch(e){
		alert(e.message);
	}
}



//function AppendData(sheet,json){
//	sheet.RenderSheet(0);
//	json = JSON.parse(json);
//	for(var x=0;x<json.data.length;x++){
//		var row = sheet.DataInsert(-1);
//		sheet.SetCellText(row,"pfilename",json.data[x].pfilename);
//		sheet.SetCellText(row,"lfilename",json.data[x].lfilename);
//		sheet.SetCellText(row,"filepath",json.data[x].filepath);
//		sheet.SetCellText(row,"filesize",json.data[x].filesize);
//	}
//	sheet.RenderSheet(1);
//}

var prog_flag = null;
/*
 * 파일 전송율에 따른 progress bar 생성
 */
function mainUpload_OnTotalPercentageChanged(Percentage) {
	/*
	try{
		if(!useProgressBar) return;
		document.frm.transferPercent.value =Percentage;
		if(Percentage==0){
			$("#progressbar").css("visibility", "hidden");
		}else if(Percentage==1){
			$("#progressbar").css("visibility", "hidden");
		}else if(Percentage>0){
			if($( "#progressbar" ).css("visibility")!="visible" ){
				$("#progressbar").css("visibility", "visible");
				$( "#progressbar" ).progressbar( "option", "value", false );
				return;
			}
		}

	}catch(e){
		alert(e.message);
	}
	*/
}
/*
 * 조회 이후 컬럼의 너비를 정비한다.
 */
//function supSheet_OnSearchEnd(code,msg){
//	supSheet.FitColWidth();
//}

/*
 * 패키지 내부 "파일 업로드" 버튼 클릭시
 */
function IBU_SAVE(){
	try{
		//서버로 전달할 파일이 있는 경우.
		var tfilecnt = supUpload.TotalFileCount;
		if(tfilecnt!=supUpload.TotalUploadedFiles){
			supUpload.CustomParams ="&FileCnt="+supUpload.TotalFileCount;
			supUpload.FileCustomParam ( supUpload.TotalFileCount -1, FormQueryStringEnc(document.forms[0]));
			supUpload.StartUpload();
		}else{
			//서버로 전달할 파일이 없는 경우
			alert("서버로 전송할 파일이 존재하지 않습니다.");
	// 		var xml = supSheet.GetSaveData(uploadProgramPath,FormQueryStringEnc(document.forms[0])  );
	// 		supSheet.LoadSaveData(xml);
		}
	}catch(ex){alert("OnSearchEnd Event Error : " + ex);}
}
/*
 * 패키지 내부 "파일 다운로드" 클릭시
 */
function IBU_DOWNLOAD(str){
	var saveData = "";
	//서버에서 다운로드 받을 파일명(값이 없을 경우 오늘 날짜 기준으로 임의의 파일명이 생성됨)
	var returnFileName = "";
	if(str==null||str===undefined){
		/*
		var rows = supSheet.FindCheckedRow("sChk");
		var rowarr = rows.split("|");
		for(var i=0;i<rowarr.length;i++){


			alert(supSheet.GetCellText(rowarr[i],"download"));
			if(supSheet.GetCellText(rowarr[i],"filePath")=="로컬"){
				alert("로컬의 파일은 다운로드 하실 수 없습니다.");
				supSheet.SelectCell(rowarr[i],"filePath",false);
				return;
			}
		}
		*/
		//var sText = supSheet.GetCellValue(Row, Col);

		saveData = supSheet.GetSaveString(false,true,"sChk");
		if(saveData==""){ alert("선택된 파일이 없습니다. 다운로드 할 파일을 선택하여 주세요."); return;}
		downsubmit("STATUS=DOWNLOAD"+"&"+saveData +"&returnFileName="+encodeURIComponent(returnFileName));
	}else{
		supSheet.SetCellValue(str,"sChk","1");
		saveData = supSheet.RowSaveStr(str);

		//alert('dss');
	}

	downsubmit("STATUS=DOWNLOAD"+"&"+saveData +"&returnFileName="+encodeURIComponent(returnFileName));
	//var downurl = uploadProgramPath+"&STATUS=DOWNLOAD"+"&"+saveData +"&returnFileName="+encodeURIComponent(returnFileName);
	//location.href = downurl;
	supSheet.SetCellValue(str,"sChk","0");
}
/*
function IBU_DOWNLOAD2(str){
	var saveData = "";
	//서버에서 다운로드 받을 파일명(값이 없을 경우 오늘 날짜 기준으로 임의의 파일명이 생성됨)
	var returnFileName = "";
	if(str==null||str===undefined){
		var rows = supSheet2.FindCheckedRow("sChk");
		var rowarr = rows.split("|");
		for(var i=0;i<rowarr.length;i++){
			if(supSheet2.GetCellText(rowarr[i],"filePath")=="로컬"){
				alert("로컬의 파일은 다운로드 하실 수 없습니다.");
				supSheet2.SelectCell(rowarr[i],"filePath",false);
				return;
			}
		}
		saveData = supSheet2.GetSaveString(false,true,"sChk");
		if(saveData==""){ alert("선택된 파일이 없습니다. 다운로드 할 파일을 선택하여 주세요."); return;}
		downsubmit("STATUS=DOWNLOAD"+"&"+saveData +"&returnFileName="+encodeURIComponent(returnFileName));
	}else{
		saveData = supSheet2.RowSaveStr(str);
		//alert('dss');
	}
	downsubmit("STATUS=DOWNLOAD"+"&"+saveData +"&returnFileName="+encodeURIComponent(returnFileName));
	//var downurl = uploadProgramPath+"&STATUS=DOWNLOAD"+"&"+saveData +"&returnFileName="+encodeURIComponent(returnFileName);
	//location.href = downurl;

}
*/
function downsubmit(str){
	var uplPath = "/fileuploadJFileUpload.do?cmd=jFileDown";
    try{
        if($('#filedownform').length>0){
            $("#filedownform").remove();
        }
        var myIF = null;
        if(!document.getElementById("myIFrame")){
        	myIF = $('<iframe>', {
                'id': "myIFrame",
                'name': "myIFrame",
              'style': 'width:0px;OVERFLOW: hidden; HEIGHT: 0px;'
          });
        	$(document.body).append(myIF);
        }
        if(document.getElementById("filedownform")){
        	document.body.removeChild(document.getElementById("filedownform"));
        }
        var newForm = $('<form>', {
                'id': "filedownform",
                'method': "POST",
              'action': uplPath,
              'target': 'myIFrame'
          });



      var items = str.split("&");
      for(var i =0; i<items.length; i++){
          var item = items[i].split("=");

          newForm.append(jQuery('<input>', {
            'name': item[0],
            'value': item[1],
            'type': 'hidden'
        }));
      }
//      alert(str);
      $(document.body).append(newForm);
      newForm.submit();



    }catch(e){
        alert(e.message);
    }

}


/*
 * 팩키지 내부 "파일 삭제" 버튼 클릭시 호출
 */
function IBU_DELETE(){
	var uplPath = "/fileuploadJFileUpload.do?cmd=jFileDel";
	var rows = supSheet.FindCheckedRow("sChk");
	if(rows==""){ alert("선택된 파일이 존재하지 않습니다. \n삭제할 파일을 선택하여 주세요."); return;}
	var rowarr = rows.split("|");
	for(var i=0;i<rowarr.length;i++){
		if(supSheet.GetCellText(rowarr[i],"filePath")=="로컬"){
			alert("로컬의 파일은 삭제하실 수 없습니다.");
			supSheet.SelectCell(rowarr[i],"filePath",false);
			return;
		}
		/*
		//서버로 전달되기 전의 파일은 바로 삭제한다.
		if(supSheet.GetCellValue(rowarr[i],"sStatus")=="I"){
			//추가된 행을 지울때, 업로드 컨트롤의 파일도 삭제한다.
			supUpload.RemoveAt(   getFileIndex( supSheet.GetCellText(rowarr[i],"LFILENAME")   )      );
			supSheet.RowDelete(row,false);
		}else{
			//서버의 파일은 상태를 삭제로 변경한다.
			supSheet.SetCellValue(rowarr[i],"sStatus","D");
		}
		*/
		supSheet.SetCellValue(rowarr[i],"sStatus","D");
	}

	//삭제할 파일이 있는지 확인 후 서버로 전송한다.
	if(supSheet.LastRow()!=0){
		//var saveData = supSheet.GetSaveString(false,true,"sChk");
		//var xml = supSheet.GetSaveData(uploadProgramPath,FormQueryStringEnc(document.forms[0]) +"&STATUS=DELETE"+"&"+saveData );
		//supSheet.LoadSaveData(xml);
		//delsubmit("STATUS=DELETE"+"&"+saveData +"&returnFileName="+encodeURIComponent(returnFileName));


		IBS_SaveName(document.uploadForm,supSheet);
		supSheet.DoSave( uplPath, {Param:$("#uploadForm").serialize(),Quest:0} );


	}




}




/*
 * 공통 함수
 * IBUpload 내부에서 파일 이름을 기준으로 index를 리턴해 준다.
 */
function getFileIndex(fn){
	var cnt = supUpload.TotalFileCount ;

	for(var i=0;i<cnt;i++){

		if(supUpload.FileName(i)==fn){
			return i;
		}
	}
	return -1;
}

/*
 * 공통함수
 * 기본 IBUpload의 Files의 개념으로 서버에 이미 존재하는 파일의 정보를
 * 시트에 Load 한다. 데이터 양식은 기본 IBSheet의 json 유형을 따른다. (물리파일명,논리파일명만 넣으면 된다.)
 * ex)
 * var files = {};
	files.data = [{"pfilename":"530232088610097","lfilename":"Book1.xlsx"}
					,{"pfilename":"49121818213171475","lfilename":"IBSheet7 UI설문답변 및 BMT 화면 설명.xlsx"}
					,{"pfilename":"1396721875904373","lfilename":"KG이니시스 정산고도화구축 UI설문답변 (2).xlsx"}
					,{"pfilename":"23829700561946376","lfilename":"UI솔루션_파일럿_구현.pptx"}
						];
*/
function IBS_SetFiles(filedatas){
	supSheet.LoadSearchData(filedatas);
}



/*
 * 모든 파일이 전송되고 난 이후 발생하는 이벤트
 * desc: 전송 후 돌려받은 데이터 중 저장된 내용을 시트에 반영한다.
 */
function mainUpload_OnUploadFinish() {

	try{
		supUpload.ClearList();
		doAction("Search");
	}catch(e){
		alert(e.message);
	}
}
function mainUpload_OnDebugMsg(LogLevel, Message){
	alert(LogLevel+":"+Message);
}
