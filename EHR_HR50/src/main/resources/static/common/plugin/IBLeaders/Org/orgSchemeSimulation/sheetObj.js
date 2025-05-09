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

		var initdata = {};

		this.create();

		initdata.Cfg = {SearchMode:smLazyLoad, Page:30, DragMode:0};
	    initdata.HeaderMode = {Sort:0, ColMove:0, ColResize:1, HeaderCheck:0};

	    initdata.Cols = [
	    	 {Header:"삭제",					Type:"DelCheck",	SaveName:"sDelete"					, Hidden : 0	},
	    	 {Header:"상태",					Type:"Status",		SaveName:"sStatus"					, Hidden : 0	},
             {Header:"부서코드",				Type:"Text",		SaveName:"orgCd"					, Hidden : 0	},
             {Header:"조직트리",				Type:"Text",		SaveName:"orgNm"					, Hidden : 0	},
             {Header:"상위부서코드",			Type:"Text",		SaveName:"priorOrgCd"				, Hidden : 0	},
             {Header:"부서레벨",				Type:"Text",		SaveName:"orgLevel"					, Hidden : 0	},
             {Header:"노드디자인",			Type:"Text",		SaveName:"nodedesign"				, Hidden : 1	},
             {Header:"보조자",				Type:"Text",		SaveName:"supportslot"				, Hidden : 1	},
             {Header:"링크색",				Type:"Text",		SaveName:"linkcolor" 				, Hidden : 1	},
             {Header:"순차",					Type:"Text",		SaveName:"num" 						, Hidden : 0	},
             {Header:"정렬",					Type:"Text",		SaveName:"seq"						, Hidden : 0	},
             {Header:"변경구분",				Type:"Text",		SaveName:"changeGubun"				, Hidden : 0	},
             {Header:"조직명(변경전)",		Type:"Text",		SaveName:"orgNmPre"					, Hidden : 0	},
             {Header:"조직명(변경후)",		Type:"Text",		SaveName:"orgNmAfter"				, Hidden : 0	},
             {Header:"영문조직명(변경전)",		Type:"Text",		SaveName:"orgEngNmPre"				, Hidden : 0	},
             {Header:"영문조직명(변경후)",		Type:"Text",		SaveName:"orgEngNmAfter"			, Hidden : 0	},
             {Header:"상위부서코드(변경전)",	Type:"Text",		SaveName:"priorOrgCdPre"			, Hidden : 0	},
             {Header:"상위부서명(변경전)",		Type:"Text",		SaveName:"priorOrgNmPre"			, Hidden : 0	},
             {Header:"상위부서코드(변경후)",	Type:"Text",		SaveName:"priorOrgCdAfter"			, Hidden : 0	},
             {Header:"상위부서명(변경후)",		Type:"Text",		SaveName:"priorOrgNmAfter"			, Hidden : 0	},
             {Header:"조직구분",				Type:"Text",		SaveName:"objectType"				, Hidden : 1	},
             {Header:"내외구분",				Type:"Text",		SaveName:"inoutType"				, Hidden : 1	},
             {Header:"조직유형",				Type:"Text",		SaveName:"orgType"					, Hidden : 1	},
             {Header:"LOCAITON",			Type:"Text",		SaveName:"locationCd"				, Hidden : 1	},
             {Header:"직속여부",				Type:"Text",		SaveName:"directYn"					, Hidden : 1	},
             {Header:"세로표시",				Type:"Text",		SaveName:"vertYn"					, Hidden : 1	},
             {Header:"조직장포함",			Type:"Text",		SaveName:"leaderYn"					, Hidden : 1	},
             {Header:"비고",					Type:"Text",		SaveName:"memo"						, Hidden : 1	},
             {Header:"직위성명",				Type:"Text",		SaveName:"positionName"				, Hidden : 1	},
             {Header:"개편일자",				Type:"Text",		SaveName:"sdate"					, Hidden : 1	},
             {Header:"버젼명",				Type:"Text",		SaveName:"versionNm"				, Hidden : 1	},
             {Header:"조직장(변경전)",		Type:"Text",		SaveName:"chiefSabunPre"			, Hidden : 0	},
             {Header:"조직장명(변경전)",		Type:"Text",		SaveName:"chiefNmPre"				, Hidden : 0	},
             {Header:"조직장직위(변경전)",		Type:"Text",		SaveName:"chiefPositionNmPre"		, Hidden : 0	},
             {Header:"조직장(변경후)",		Type:"Text",		SaveName:"chiefSabunAfter"			, Hidden : 0	},
             {Header:"조직장명(변경후)",		Type:"Text",		SaveName:"chiefNmAfter"				, Hidden : 0	},
             {Header:"조직장직위(변경후)",		Type:"Text",		SaveName:"chiefPositionNmAfter"		, Hidden : 0	},
             {Header:"조직장명",				Type:"Text",		SaveName:"chiefNm"					, Hidden : 1	},
             {Header:"조직장직위",			Type:"Text",		SaveName:"chiefPositionNm"			, Hidden : 1	},
             {Header:"하위조직세로정렬여부",	Type:"Text",		SaveName:"vrtclOrderYn"				, Hidden : 1	}
        ];

	    IBS_InitSheet(mySheet, initdata);		// mySheet는 IBSheet의 createIBSheet2에서 생성된 전역객체

	    mySheet.FitColWidth();
	    mySheet.SetFocusAfterProcess(0);
	    mySheet.SetWaitImageVisible(0);			// 대기 이미지 생성하지 않도록 설정

	    this.bindEvent();

	    $("#sheetDiv").hide();

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

				// 시트 컬럼 너비 정렬
//					mySheet.ShowTreeLevel(1,1);

				// 시트 조회후, 조직도를 생성하도록 한다.
				orgObj.sheetToOrg();
			},
			OnSaveEnd : function(Code, Msg, StCode, StMsg) {
				
				
				try{
					if(Msg != "") {
						alert(Msg);
						loadObj.hideBlockUI();
					}
					
					if(parseInt(Code, 10) > 0) {
						$("#td_diff_text").text("");
						if(confirm("조직도를 저장된 내용으로 재적용하시겠습니까?")) {
							//orgObj.sheetToOrg();
							orgSearch();
						}
					}
				}catch(ex){
					alert("OnSaveEnd Event Error " + ex);
				}
			},
			OnResize : function(Width, Height) {
			    mySheet.FitColWidth();
			},
			/**
			 * 클릭 이벤트
			 */
			OnClick : function(Row, Col, Value, CellX, CellY, CellW, CellH) {

			},
			/**
			 * 돋보기 모양의 버튼 클릭 이벤트로 하위노드 보기를 지원한다.
			 */
			OnPopupClick : function(Row, Col) {

			},
			OnSelectCell : function(OldRow, OldCol, NewRow, NewCol) {

			},
			/**
			 * 변경시 이벤트
			 */
			OnChange : function(Row, Col, Value, OldValue) {
				printModifySheet();
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
	 * 새로운 Row 추가 후 Row Index 반환한다.
	 */
	DataInsert : function() {
		return mySheet.DataInsert();
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
	 * 지정 노드의 Sheet에서의 인덱스값 반환
	 */
	GetNodeSheetIdx : function(NodeID) {
		var sheetIdx = -1;
		for(var i = mySheet.HeaderRows(); i <= mySheet.LastRow(); i++){
			var deptcd = mySheet.GetCellValue( i  , "orgCd" );
			if ( deptcd == NodeID ){
				sheetIdx = i;
				break;
			}
		}
		return sheetIdx;
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

			nodeID = mySheet.GetCellValue( row , "deptcd" );
			if (nodeID) {
				orgObj.SetSelectNode(nodeID);
			}

		} else {
			// 검색된 결과가 없으면
			startRow = 1;
			if ( confirm( "다시 검색하시겠습니까?" ) ) {
				sheetObj.findName();
			}
		}
	},
	/**
	 * Test
	 */
	Test : function() {

	},
	/**
	 * 상위부서 정보 갱신
	 */
	updateParent : function( targetOrgCd , parentOrgCd ){
		// 선택된 조직의 시트 row index
		var sheetIdx      = sheetObj.GetNodeSheetIdx(targetOrgCd);
		// 선택된 조직 상위부서의 시트 row index
		var sheetIdxPrior = sheetObj.GetNodeSheetIdx(parentOrgCd);
		// 선택된 조직의 변경전 상위부서코드
		var priorOrgCdPre = sheetObj.GetCellValue(sheetIdx, "priorOrgCdPre");
		// 선택된 조직의 변경구분코드
		var changeGubun   = sheetObj.GetCellValue(sheetIdx, "changeGubun");
		// 선택된 조직 상위부서의 부서명
		var parentOrgNm   = sheetObj.GetCellValue(sheetIdxPrior, "orgNm");
		// 선택 부서의 정렬값
		var seq           = orgObj.GetNodeDBData(targetOrgCd, "seq");
		
		// 상위부서 정보 변경 처리
		mySheet.SetCellValue( sheetIdx , "priorOrgCd" , parentOrgCd );
		
		// 변경전 상위부서코드와 변경후 상위부서코드가 다른 경우 시트 변경 처리
		if(priorOrgCdPre != parentOrgCd) {
			mySheet.SetCellValue( sheetIdx , "priorOrgCdAfter" , parentOrgCd );
			mySheet.SetCellValue( sheetIdx , "priorOrgNmAfter" , parentOrgNm );
			
			// 기존에 설정된 변경구분코드가 "1:조직신설"이 아닌 경우 변경구분코드 변경처리
			if(changeGubun != "1") {
				mySheet.SetCellValue( sheetIdx , "changeGubun" , "3" );		// 상부조직변동
			}
		}
		
		// 변경전 상위부서코드와 변경후 상위부서코드가 같은 경우 변경후 정보 초기화함.
		if(priorOrgCdPre == parentOrgCd) {
			mySheet.SetCellValue( sheetIdx , "priorOrgCdAfter" , "" );
			mySheet.SetCellValue( sheetIdx , "priorOrgNmAfter" , "" );
			// 기존에 설정된 변경구분코드가 "3:상부조직변동"인 경우 초기화처리함.
			if(changeGubun == "3") {
				mySheet.SetCellValue( sheetIdx , "changeGubun" , "" );		// 상부조직변동
			}
		}
		
		mySheet.SetCellValue( sheetIdx , "seq" , seq );		// seq
	},
	/**
	 * 변경정보반환
	 * @param Row
	 * @param OrgCd
	 * @returns
	 */
	GetChangeInfo : function(Row, OrgCd) {
		
		if(Row == null && Row == undefined && OrgCd == null && OrgCd == undefined) {
			return null;
		}
		
		if(Row == null && Row == undefined) {
			Row = sheetObj.GetNodeSheetIdx(OrgCd);
		}
		
		// 신규
		var isNew            = false;
		// 조직장변경
		var isChangeChief    = false;
		// 상위조직변경
		var isChangePriorOrg = false;
		// 폐쇄
		var isClosed         = false;
		
		var orgNmPre         = mySheet.GetCellValue( Row, "orgNmPre"        );
		var orgNmAfter       = mySheet.GetCellValue( Row, "orgNmAfter"      );
		var chiefNmPre       = mySheet.GetCellValue( Row, "chiefNmPre"      );
		var chiefNmAfter     = mySheet.GetCellValue( Row, "chiefNmAfter"    );
		var priorOrgCdPre    = mySheet.GetCellValue( Row, "priorOrgCdPre"   );
		var priorOrgCdAfter  = mySheet.GetCellValue( Row, "priorOrgCdAfter" );
		var changeGubun      = mySheet.GetCellValue( Row, "changeGubun"     );
		
		// 신규
		if(orgNmPre == "" && orgNmAfter != "") {
			isNew = true;
		}
		
		// 조직장변경
		if(chiefNmPre != "" && chiefNmAfter != "" && chiefNmPre != chiefNmAfter) {
			isChangeChief = true;
		}
		
		// 상위조직변경
		if(priorOrgCdPre != "" && priorOrgCdAfter != "" && priorOrgCdPre != priorOrgCdAfter) {
			isChangePriorOrg = true;
		}
		
		// 폐쇄
		if(changeGubun == "4") {
			isClosed = true;
		}
		
		return {
			newOrg         : isNew,
			changePriorOrg : isChangePriorOrg,
			changeChief    : isChangeChief,
			closed         : isClosed
		};
		
	},
	/**
	 * 변경여부반환
	 * @param Row
	 * @param Org
	 * @returns
	 */
	IsChange : function(Row, Org) {
		var changeInfo = sheetObj.GetChangeInfo(Row, Org);
		var isChange = false;
		
		if(changeInfo != null) {
			if( changeInfo.newOrg || changeInfo.changePriorOrg || changeInfo.changeChief || changeInfo.closed ) {
				isChange = true;
			}
		}
		
		return isChange;
	}
};

var tmpName;			// 이름 검색시 비교를 위한 임시이름
var startRow = 1;		// 검색 시작행