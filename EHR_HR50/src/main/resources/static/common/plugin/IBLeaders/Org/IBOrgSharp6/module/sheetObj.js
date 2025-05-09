/**
 * sheetObj : 트리형 시트 관련 내용
 */
var sheetObj = {
	config : {
		
	},
	/**
	 * IBSheet 초기화
	 */
	init : function() {
    	var ObjType;
    	if($("#ObjType") == undefined || $("#ObjType") == ""){
    		ObjType = "Org";
    	}else{
    		ObjType = $("#ObjType").val();
    	}
		
		var initdata = {};
		
		this.create();
		
		initdata.Cfg = {SearchMode:smLazyLoad, Page:30, DragMode:0};
	    initdata.HeaderMode = {Sort:0, ColMove:0, ColResize:1, HeaderCheck:0};
	    if(ObjType == "Job"){
		    initdata.Cols = [
                {Header:"부서코드", 		Type:"Text",	Width:100,	SaveName:"deptcd",		Align:"Center", Edit:0, Hidden:1},
                {Header:"직무트리", 		Type:"Popup",	Width:200,	SaveName:"deptnm",		Align:"Left", TreeCol:1},
                {Header:"상위부서코드", 	Type:"Text",	Width:100,	SaveName:"updeptcd",	Align:"Center",Edit:0, Hidden:1},
                {Header:"EnterCD",		Type:"Text",	Width:40,	SaveName:"entercd",		Hidden:1, Align:"Center", Edit:0},
                {Header:"사번",			Type:"Text",	Width:40,	SaveName:"empcd",		Hidden:1, Align:"Center", Edit:0},
                {Header:"성명",			Type:"Text",	Width:40,	SaveName:"empnm", 		Hidden:1, Align:"Center", Edit:0},
                {Header:"사진",			Type:"Text",	Width:40,	SaveName:"photo", 		Hidden:1, Align:"Center", Edit:0},
                {Header:"직위",			Type:"Text",	Width:40,	SaveName:"position", 	Hidden:1, Align:"Center", Edit:0},
                {Header:"직책",			Type:"Text",	Width:40,	SaveName:"title", 		Hidden:1, Align:"Center", Edit:0},
                {Header:"내선",			Type:"Text",	Width:40,	SaveName:"inline", 		Hidden:1, Align:"Center", Edit:0},
                {Header:"연락처",		Type:"Text",	Width:40,	SaveName:"hp", 			Hidden:1, Align:"Center", Edit:0},
                {Header:"이메일",		Type:"Text",	Width:40,	SaveName:"email", 		Hidden:1, Align:"Center", Edit:0},
                {Header:"사진",			Type:"Text",	Width:40,	SaveName:"photo", 		Hidden:1, Align:"Center", Edit:0},
                {Header:"파견",			Type:"Text",	Width:40,	SaveName:"oriEnterCd",	Hidden:1, Align:"Center", Edit:0},
                {Header:"겸직",			Type:"Text",	Width:40,	SaveName:"doubleYn",	Hidden:1, Align:"Center", Edit:0},
                {Header:"정렬",			Type:"Text",	Width:40,	SaveName:"seq",			Hidden:1, Align:"Center", Edit:0},
                {Header:"부서레벨",		Type:"Text",	Width:40,	SaveName:"deptlevel", 	Hidden:1, Align:"Center", Edit:0},
                {Header:"노드디자인",		Type:"Text",	Width:40,	SaveName:"nodedesign", 	Hidden:1, Align:"Center", Edit:0},
                {Header:"보조자",		Type:"Text",	Width:40,	SaveName:"supportslot", Hidden:1, Align:"Center", Edit:0},
                {Header:"링크색",		Type:"Text",	Width:40,	SaveName:"linkcolor", 	Hidden:1, Align:"Center", Edit:0},
                {Header:"ListPID",		Type:"Text",	Width:40,	SaveName:"listpid", 	Hidden:1, Align:"Center", Edit:0},
                {Header:"NodeID",		Type:"Text",	Width:40,	SaveName:"nodeid", 		Hidden:1, Align:"Center", Edit:0},
                {Header:"ListCount",	Type:"Text",	Width:40,	SaveName:"listcount", 	Hidden:1, Align:"Center", Edit:0},
                {Header:"Empcnt",		Type:"Text",	Width:40,	SaveName:"empcnt", 		Hidden:1, Align:"Center", Edit:0},
                {Header:"sdate",		Type:"Text",	Width:40,	SaveName:"sdate", 		Hidden:1, Align:"Center", Edit:0},
                {Header:"공동부서장",		Type:"Text",	Width:40,	SaveName:"dualemp", 	Hidden:1, Align:"Center", Edit:0}
                ];
	    }else{
	    	initdata.Cols = [
	                     {Header:"부서코드", 		Type:"Text",	Width:100,	SaveName:"deptcd",		Align:"Center", Edit:0, Hidden:1},
	                     {Header:"조직트리", 		Type:"Popup",	Width:200,	SaveName:"deptnm",		Align:"Left", TreeCol:1},
	                     {Header:"상위부서코드", 	Type:"Text",	Width:100,	SaveName:"updeptcd",	Align:"Center",Edit:0, Hidden:1},
	                     {Header:"EnterCD",		Type:"Text",	Width:40,	SaveName:"entercd",		Hidden:1, Align:"Center", Edit:0},
	                     {Header:"사번",			Type:"Text",	Width:40,	SaveName:"empcd",		Hidden:1, Align:"Center", Edit:0},
	                     {Header:"성명",			Type:"Text",	Width:40,	SaveName:"empnm", 		Hidden:1, Align:"Center", Edit:0},
	                     {Header:"사진",			Type:"Text",	Width:40,	SaveName:"photo", 		Hidden:1, Align:"Center", Edit:0},
	                     {Header:"직위",			Type:"Text",	Width:40,	SaveName:"position", 	Hidden:1, Align:"Center", Edit:0},
	                     {Header:"직책",			Type:"Text",	Width:40,	SaveName:"title", 		Hidden:1, Align:"Center", Edit:0},
	                     {Header:"내선",			Type:"Text",	Width:40,	SaveName:"inline", 		Hidden:1, Align:"Center", Edit:0},
	                     {Header:"연락처",		Type:"Text",	Width:40,	SaveName:"hp", 			Hidden:1, Align:"Center", Edit:0},
	                     {Header:"이메일",		Type:"Text",	Width:40,	SaveName:"email", 		Hidden:1, Align:"Center", Edit:0},
	                     {Header:"사진",			Type:"Text",	Width:40,	SaveName:"photo", 		Hidden:1, Align:"Center", Edit:0},
	                     {Header:"파견",			Type:"Text",	Width:40,	SaveName:"oriEnterCd",	Hidden:1, Align:"Center", Edit:0},
	                     {Header:"겸직",			Type:"Text",	Width:40,	SaveName:"doubleYn",	Hidden:1, Align:"Center", Edit:0},
	                     {Header:"정렬",			Type:"Text",	Width:40,	SaveName:"seq",			Hidden:1, Align:"Center", Edit:0},
	                     {Header:"부서레벨",		Type:"Text",	Width:40,	SaveName:"deptlevel", 	Hidden:1, Align:"Center", Edit:0},
	                     {Header:"노드디자인",		Type:"Text",	Width:40,	SaveName:"nodedesign", 	Hidden:1, Align:"Center", Edit:0},
	                     {Header:"보조자",		Type:"Text",	Width:40,	SaveName:"supportslot", Hidden:1, Align:"Center", Edit:0},
	                     {Header:"링크색",		Type:"Text",	Width:40,	SaveName:"linkcolor", 	Hidden:1, Align:"Center", Edit:0},
	                     {Header:"ListPID",		Type:"Text",	Width:40,	SaveName:"listpid", 	Hidden:1, Align:"Center", Edit:0},
	                     {Header:"NodeID",		Type:"Text",	Width:40,	SaveName:"nodeid", 		Hidden:1, Align:"Center", Edit:0},
	                     {Header:"ListCount",	Type:"Text",	Width:40,	SaveName:"listcount", 	Hidden:1, Align:"Center", Edit:0},
	                     {Header:"Empcnt",		Type:"Text",	Width:40,	SaveName:"empcnt", 		Hidden:1, Align:"Center", Edit:0},
	                     {Header:"공동부서장",		Type:"Text",	Width:40,	SaveName:"dualemp", 	Hidden:1, Align:"Center", Edit:0}
	                     ];
	    }
	    IBS_InitSheet(mySheet, initdata);		// mySheet는 IBSheet의 createIBSheet2에서 생성된 전역객체
	    
	    mySheet.FitColWidth();
	    mySheet.SetFocusAfterProcess(0);
	    mySheet.SetWaitImageVisible(0);			// 대기 이미지 생성하지 않도록 설정
	    
	    this.bindEvent();
	    
//	    doAction("Org");
	},
	/**
	 * IBSheet 생성
	 */
	create : function() {
		/**
		 * IBSheet를 생성
		 * @param 	{object}				IBSheet가 생성될 대상 컨테이너
		 * @param	{object}				IBSheet의 ID
		 * @param	{String}	"100%"		너비
		 * @param	{String}	"100%"		높이
		 */
		createIBSheet2(document.getElementById("sheetDiv"), "mySheet", "190px", "91%", "kr");
	},
	/**
	 * 시트 데이터 로드
	 * @param data : JSON형태의 데이터
	 */
	loadData : function(data) {
		mySheet.RemoveAll();
		mySheet.LoadSearchData(data);
	},
	/**
	 * 관련 이벤트
	 */
	bindEvent : function() {
		function addEvents(mySheet, callbacks) {
			for (var prop in callbacks) {
				window[mySheet + "_" + prop] = callbacks[prop];
			}
		}
		
		addEvents(mySheet.id, {
			/**
			 * 조회 후 처리이벤트
			 */
			OnSearchEnd : function(Code, Msg, StCode, StMsg) {
				// 처리가 실패하는 경우 로그를 표시한다.
				if (Code != 0) {
					
				} else {
					// 시트 컬럼 너비 정렬
//					mySheet.ShowTreeLevel(1,1);
					
					mySheet.FitColWidth();
					
					// 시트 조회후, 조직도를 생성하도록 한다.
					orgObj.sheetToOrg();
					
					
					//setUseLevel();
				}
			},
			OnSaveEnd : function(Code, Msg, StCode, StMsg) {
				
			},
			OnResize : function(Width, Height) {
			    mySheet.FitColWidth();
			},
			/**
			 * 클릭 이벤트
			 */
			OnClick : function(Row, Col, Value, CellX, CellY, CellW, CellH) {
				var nodeID = mySheet.GetCellValue(Row, "deptcd");
				
				if (nodeID) {
					orgObj.SetSelectNode(nodeID);
				}
			},
			/**
			 * 돋보기 모양의 버튼 클릭 이벤트로 하위노드 보기를 지원한다.
			 */
			OnPopupClick : function(Row, Col) {
				var nodeID = mySheet.GetCellValue(Row, "deptcd");
				
				if (nodeID) {
					orgObj.ShowChildNode(nodeID);
				}
			},
			OnSelectCell : function(OldRow, OldCol, NewRow, NewCol) {
				/*
				var nodeID;
				
				조직도에 생성된 노드가 없는 경우
				if (orgObj.GetNodeCount()==0) return;
				
		        mySheet.SetCellBackColor(OldRow, OldCol, "#FFFFFF");
		        mySheet.SetCellBackColor(NewRow, NewCol, "#8998A4");
		        
		        nodeID = mySheet.GetCellValue(NewRow, "deptcd");
		        myOrg.ShowChildNode(nodeID);
		        */
			}
		});
	},
	/**
	 * 특정 컬럼 Index에 해당하는 InitColumns 함수에서 설정한 SaveName을 확인한다.
	 * @param DataRow
	 * @param Col
	 * @returns
	 */
	ColSaveName : function(DataRow, Col) {
		return mySheet.ColSaveName(DataRow, Col);
	},
	/**
	 * 해당 값이 있는 곳의 행을 찾는다.
	 * @param code : 검색하려는 문자열
	 * @returns
	 */
	FindText : function(colName, searchText) {
		return mySheet.FindText(colName, searchText, 0);
	},
	/**
	 * 행과 열의 위치에 따른 값을 가져온다.
	 * @param row
	 * @param colName
	 * @returns
	 */
	GetCellValue : function(Row, colName) {
		return mySheet.GetCellValue(Row, colName);
	},
	/**
	 * 트리구조에서 특정 행의 자식행들의 Index를 "|"로 조합하여 반환한다
	 * @param Row
	 * @param MaxLevel
	 * @returns
	 */
	GetChildRows : function(Row, MaxLevel) {
		return mySheet.GetChildRows(Row, MaxLevel);
	},
	/**
	 * 마지막 컬럼의 index를 반환한다.
	 * @returns
	 */
	LastCol : function() {
		return mySheet.LastCol();
	},
	/**
	 * 시트 전체의 행의 갯수
	 */
	RowCount : function() {
		return mySheet.RowCount();
	},
	/**
	 * 행 숨김
	 */
	SetRowHidden : function(Row) {
		mySheet.SetRowHidden(Row, 1);
	},
	/**
	 * 행과 열 위치에 값을 입력한다.
	 * @param row
	 * @param colName
	 * @param val
	 */
	SetCellValue : function(Row, colName, val) {
		mySheet.SetCellValue(Row, colName, val);
	},
	/**
	 * 행의 레벨값을 가져온다.
	 * @param row
	 * @return level
	 */
	GetRowLevel : function(Row) {
		return mySheet.GetRowLevel(Row);
	},
	/**
	 * 지정된 행을 선택
	 */
	SetSelectRow : function(Row) {
		mySheet.SetSelectRow(Row, 0);
	},
	/**
	 * 트리 형태 일 때 행의 Child Level이 펼쳐져 있는 상태인지 여부를 확인하거나 펼침 여부를 설정한다.
	 */
	SetRowExpanded : function(Row, Expand) {
		mySheet.SetRowExpanded(Row, Expand, 0);
	},
	/**
	 * 리스트 갯수를 반환한다.
	 * @param Key
	 * @param Value
	 */
	GetSubSumCount : function(Key, Value) {
		var i,
			row = mySheet.FindText(Key, Value, 0),
			count = 0
		;
		
		if (row < 1) {
			return count;
		}
		
		count = mySheet.GetCellValue(row, "listcount");
		return count;
	},
	/**
	 * 이름 검색
	 */
	findName : function() {
		var
			row,
			nodeID,
			iType = $("#selFindType").val(),
			iName = $("#inputFindName").val()
		;
		
		// 선택 타입이 없으면
		if (iType.length < 1) {
			return;
		}
		
		// 검색하고자 하는 명칭이 없는 경우
		if (iName.length < 1) {
			return;
		}
		
		// 이전 명칭과 비교해서 같지 않으면 처음부터 검색
		if (tmpName != iName) {
			startRow = 1;
		}
		
		// 검색된 명칭과 동일한 행을 찾는다.
		row = mySheet.FindText(iType, iName, startRow, 2, 0);
		
		if (row > 0) {
			tmpName = iName;
			startRow = Number(row + 1);
			
			mySheet.SetSelectRow(row, 0);
			
			nodeID = mySheet.GetCellValue(row, "deptcd");
			if (nodeID) {
				orgObj.SetSelectNode(nodeID);
			}
			
		} else {
			// 검색된 결과가 없으면
			startRow = 1;
			if (confirm("다시 검색하시겠습니까?")) {
				sheetObj.findName();
			}
		}
	},
	/**
	 * Test
	 */
	Test : function() {
		
	}
};

var tmpName;			// 이름 검색시 비교를 위한 임시이름
var startRow = 1;		// 검색 시작행