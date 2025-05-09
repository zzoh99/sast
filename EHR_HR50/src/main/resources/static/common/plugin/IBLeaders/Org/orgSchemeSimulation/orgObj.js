/**
 * orgObj : 화상조직도 관련 내용
 */
var orgObjPrevFocusKey = null;

var orgObj = {
	config : {
		/**
		 * 확정 여부
		 */
		isConfirmed : "N"
	},
	init : function() {
		this.create("myOrg", "100%", "96%");
	},
	/**
	 * IBOrg를 생성
	 * @param 	{object}	orgID			IBOrg#이 생성되는 객체
	 * @param	{String}	div_width		너비
	 * @param	{String}	div_height		높이
	 */
	create : function(orgID, div_width, div_height) {
		$('<div/>', {
			id: orgID,
			width: div_width,
			height: div_height,
		}).appendTo('#orgDiv');

		this.initIBOrg();
	},
	/**
	 * 조직도 설정
	 */
	initIBOrg : function() {
		var
			_opt,
			currKey //현재 정보에 보이는 사번
		  , that
		;

		that = this;

		// diagramPadding : 다이어그램 영역에 간격
		// expandButtonVisible : 노드 아래 하위노드 확장버튼을 숨김
		// contentAlign : 화상조직도 정렬 시작점
		// defaultImage : 기본 이미지(이미지가 없을때 대체하는 이미지)

		// layout.level : 레벨 정렬 사용 유무
		// layout.supporter : 보조자(direct) 사용 유무
		// layerSpacing : 노드 세로 간격
		// nodeSpacing : 노드 가로 간격

		// IBOrgJS 객체 생성시 사용할 option을 생성
		_opt = {
			diagramPadding: 30,
			expandButtonVisible: false,
			contentAlign: "TopCenter",
			defaultImage: "/common/plugin/IBLeaders/Org/IBOrgChange/img/default.png",
			defaultTemplate: {
				link: {
					style: {
						borderWidth: 2,
						borderColor: "#CCC",
						borderStyle: "solid"
					}
				}
			},
			layout: {
				level: 1,
				supporter: true,
				layerSpacing: 0,
				nodeSpacing: 5
			},
			event: {
				/**
				 * 조회 완료후 이벤트
				 * @param  {Object} evt
				 */
				onDiagramLoadEnd : function(evt) {
					var isTreeLevel = true;
					orgObj.UseLevelAlign(1);
					loadObj.hideBlockUI();												// 조회가 완료되면 Block영역을 숨김
					myOrg.nodes().root().select(true).center(100);						// 조회 완료시 루트노드를 선택하게 한다.
					myOrg.nodes().link().style("borderColor","#DCDCDC");
					//orgObj.showLegend();
				},
				/**
				 * 노드 마우스 클릭 이벤트
				 */
				onMouseDown: function(evt) {
					// evt 이벤트 객체
					// evt.node, evt.member 노드 객체나 리스트노드 객체
					if (evt.node || evt.member) {
						// 조직도 확정이 되어 있는 경우에는 이동 불가
						if(orgObj.config.isConfirmed == "Y") {
							return;
						} else {
							//if (evt.ctrlKey) {
							evt.org.dragging({
								isDragging: true,
								data: (evt.isMember) ? evt.member : evt.node
							});
							//}
						}
					}
				},
				/**
				 * 노드 마우스 클릭후 이벤트
				 */
				onMouseUp: function(evt) {
					if(evt.ctrlKey && orgObj.config.isConfirmed == "Y") {
						alert("조직도 확정이 되어 있는 상황에서 조직도 변경이 불가능합니다.");
						return;
					}

					// 마우스 우클릭(3) asdf
					if (evt.which === 3) {
						$.contextMenu("destroy");

						$.contextMenu({
							selector: "canvas",
							zIndex: 3,
							trigger: "none",
							animation: {
								duration: 0
							},
							items: contextMenu.getItems(evt)
						});

						// contextMenu.proc(evt);
					}
				},
				/**
				 * 마우스 오버 이벤트
				 */
				onMouseOver: function(evt) {
					//console.log('onMouseOver evt', evt);
					//console.log(evt.node);
					if(orgObj.config.isConfirmed == "N") {
						if(evt.key != null && evt.key != undefined && evt.isField) {
							var template = evt.node.template();
							if(template.indexOf("_Focus") == -1) {
								evt.node.template(template + "_Focus");
							}
							
							if(evt.key != orgObjPrevFocusKey && orgObjPrevFocusKey != null && orgObjPrevFocusKey != undefined) {
								var prevNode = evt.org.nodes(orgObjPrevFocusKey);
								prevNode.template(prevNode.template().substring(0, prevNode.template().indexOf("_Focus")));
							}
						} else {
							// 포커스 처리 초기화
							var pkeys = evt.org.template.source.pkeys;
							//console.log('items', evt.org.nodes);
							//myOrg.nodes(NodeID)
							if(pkeys != null && pkeys != undefined) {
								var keys = Object.keys(pkeys);
								if(keys != null && keys != undefined && keys.length > 0) {
									for(var idx = 0; idx < keys.length; idx++) {
										var item = evt.org.nodes(keys[idx]);
										if(item.template().indexOf("_Focus") > 0) {
											item.template(item.template().substring(0, item.template().indexOf("_Focus")));
										}
									}
								}
							}
						}
						
						orgObjPrevFocusKey = evt.key;
					}
				},
				/**
				 * 드래그 시작시 이벤트
				 */
				onDragStart: function(evt) {
					var node = evt.org.dragging().data,
						img = node.makeImage();

					img.id = "dragimg";
					img.style.zIndex = 9999;

					$("body").append(img);

					$("#dragimg").css({
						"position": "absolute",
						"left": (evt.pageX + 1),
						"top": (evt.pageY + 1),
						"opacity": 0.5
					});
				},
				onDrag: function(evt) {
					$("#dragimg").css({
						"position": "absolute",
						"left": (evt.pageX + 1),
						"top": (evt.pageY + 1),
						"opacity": 0.5
					});
				},
				onDragEnd: function(evt) {
					$("#dragimg").off().remove();
					$(".GridMain2").off();
					evt.org.etcData.set("draggingData", {});
				},
				onDrop: function(evt) {

					var node = evt.org.dragging().data,			// 변경 조직
					targetNode = evt.node;					// 변경 대상

					var org = evt.org;

					draggingData = org.etcData.get("draggingData");

					// 조직도에서 드래그된 데이터
					if ( targetNode != undefined ){

						if ( !$.isEmptyObject(draggingData) ){

							/**
							 * evt.node : 시트에서 조직도로 드래그 하여 놓을때, 타겟이 되는 노드의 정보
							 * 타겟이 되는 노드가 있으면 부모 노드가 되고, 없으면 상위 노드가 없는 상태로 생성된다.
							 */
							rkey = (evt.node) ? evt.node.pkey() : "";

							/**
							 * 조직 데이터 생성
							 *
							 * pkey는 노드의 유니크한 키
							 * rkey는 상위 연결 노드키
							 */
							nodedata = [{
								"template": "photo",
								"fields": {
									"pkey": {
										"value": draggingData.dept_cd
									},
									"rkey": {
										"value": rkey
									},
									"dept_nm": {
										"value": draggingData.dept_nm
									},
									"position": {
										"value": draggingData.position
									},
									"emp_cd": {
										"value": draggingData.emp_cd
									},
									"emp_nm": {
										"value": draggingData.emp_nm
									},
									"extension": {
										"value": draggingData.extension
									},
									"phone": {
										"value": draggingData.phone
									},
									"email": {
										"value": draggingData.email
									},
									"photo": {
										"value": draggingData.photo
									}
								}
							}];
							
							// org object에 새로운 orgData 추가
							org.nodes.add(nodedata);

						}else{
							// 변경대상 하위 노드로 이동(부서 이동)
							// 변경 대상의 key를 가져온다.
							pkey = targetNode.pkey();
							
							// 변경 대상이 하위 노드인지 체크
							var isChildNode = orgObj.IsChildren(node.pkey(), pkey);
							
							// 상위부서코드가 변경전과 동일한 경우인지 체크
							var isChangedPriorCd = orgObj.IsChangedPriorCd(node.pkey(), pkey);
							
							//console.log('isChildNode & isChangedPriorCd', "isChildNode : " + isChildNode + ", isChangedPriorCd : " + isChangedPriorCd);
							
							// 선택된 조직의 시트 row index
							var sheetIdx = sheetObj.GetNodeSheetIdx(node.pkey());
							
							// 선택된 상위부서 하위 노드들의 순번 최대값
							var maxSeq   = orgObj.MaxSeq(pkey) + 1;
							
							// 변경 대상이 하위 노드가 아니며, 상위부서코드가 변경된 경우에 처리진행
							if(!isChildNode && isChangedPriorCd) {
								// 상위부서 변경
								node.rkey(pkey);
								
							}
							
							/*
							 * 상위부서코드가 실제 변경된 경우 처리함.
							 * - 드래그하는 과정에서 조직노드가 1개이상 포커스된 경우 마지막 포커스된 조직노드를 targetNode로 반환하기 때문에 실제로 적용된 후 상위부서코드를 비교하여 적용함.
							 *   #1 마지막 포커스된 노드가 자신인 경우 상위부서코드를 자신의 부서코드로 반환
							 *   #2 드래그하여 옮기다만 경우 드래그하는 과정에서 조직이 포커스된 경우
							 */ 
							if(node.rkey() == pkey) {
								// 내부순번변경
								node.fields("seq").value( maxSeq );
								
								// 시트 내용 변경
								sheetObj.updateParent( node.pkey() , pkey );
								
								// 선택된 조직의 변경구분코드
								var changeGubun = sheetObj.GetCellValue(sheetIdx, "changeGubun");
								
								//var template1 = node.template();
								var template1 = orgObj.GetNodeTemplateBase(node.pkey());
								
								
								// 변경구분값이 존재하는 경우
								if(changeGubun != "") {
									template1 = template1 + "_Move";
								}
								
								// 템플릿 적용
								node.template(template1);
							}
							
						}
					}
				}
			}
		}

		// 조직도 생성
		createIBOrg("myOrg", _opt);
	},

	/**
	 * 조직도 기본 조회
	 */
	load : function() {
		orgObj.sheetToOrg();
	},
	/**
	 * JSON 데이터를 직접 조회한다.
	 */
	loadJson : function(jsonData) {
		myOrg.loadJson({data: jsonData});
	},
	/**
	 * 지정 단위 조직 JSON 데이터를 조직도에 추가
	 */
	appendByJson : function(jsonData) {
		myOrg.loadJson({data: jsonData, append: true});
	},
	/**
	 * 파일 불러오기 기능
	 */
	loadFile : function() {
		myOrg.loadFromFile();
	},
	/**
	 * 파일 저장 기능
	 */
	saveFile : function() {
		myOrg.saveAsJson();
	},

	/**
	 * Zoom 기능
	 * @param {float} val : Zoom 값
	 */
	Zoom : function(val) {
		myOrg.scale(val);
	},
	/**
	 * 조직도 데이터를 지운다.
	 */
	ClearData : function() {
		myOrg.clear();
	},
	/**
	 * 확대
	 */
	ZoomIn : function() {
		myOrg.zoomIn();
	},
	/**
	 * 축소
	 */
	ZoomOut : function() {
		myOrg.zoomOut();
	},
	/**
	 * 화면에 맞게 크기 조절
	 */
	FitScale : function() {
		myOrg.scale("fit");
	},
	/**
	 * 조직도를 이미지로 저장
	 */
	Down2Image : function() {
		myOrg.saveAsImage( { filename : "orgChart", backgroundColor : "white" } );
	},
	Down2Excel : function() {
		myOrg.saveAsExcel({});
	},

	/**
	 * 레벨정렬 설정
	 * @param {bool} flag true/false
	 */
	UseLevelAlign : function(flag) {
		myOrg.layout.level(flag);
	},
	/**
	 * 전체 노드 보기
	 */
	ShowAllNode : function() {
		myOrg.nodes.viewAll();
		myOrg.nodes().root().select(true).center(100);
	},
	/**
	 * 자식 노드 보기
	 * @param {string} NodeID 노드 ID
	 */
	ShowChildNode : function(NodeID) {
		myOrg.nodes.viewSubTree(NodeID);
		myOrg.nodes(NodeID).select(true).center(100);
	},
	/**
	 * 노드를 선택한다.
	 * @param NodeID
	 */
	SetSelectNode : function(NodeID) {
		myOrg.nodes(NodeID).select(true).center();
	},
	/**
	 * 선택된 노드 정보를 받는다.
	 * @returns
	 */
	SelectNodeID : function() {
		return myOrg.nodes.selected();
	},
	/**
	 * 지정노드 ID에 대응하는 해당 노드객체를 반환한다.
	 * @param {string} NodeID
	 * @returns {string}
	 */
	GetNode : function(NodeID) {
		if (!NodeID) return "[Error] NodeID를 입력해주세요.";
		return myOrg.nodes(NodeID);
	},
	/**
	 * 기준노드의 DBKey에 대응하는 해당 필드값을 반환한다.
	 * @param {string} NodeID
	 * @param {string} DBKey
	 * @returns {string}
	 */
	GetNodeDBData : function(NodeID, DBKey) {
		if (!NodeID) return "[Error] NodeID를 입력해주세요.";
		if (!DBKey) return "[Error] Key를 입력해주세요.";

		return myOrg.nodes(NodeID).fields(DBKey).value();
	},
	/**
	 * 노드 정보를 갱신한다.
	 * @param NodeID
	 * @param DBKey
	 * @param DBValue
	 * @returns {String}
	 */
	SetNodeDBData : function(NodeID, DBKey, DBValue) {
		if (!NodeID) return "[Error] NodeID를 입력해주세요.";
		if (!DBKey) return "[Error] Key를 입력해주세요.";

		myOrg.nodes(NodeID).fields(DBKey).value(DBValue);
	},
	/**
	 * 조직 갯수 카운트
	 */
	GetNodeCount : function() {
		return myOrg.nodes().length;
	},
	/**
	 * 디자인명
	 */
	GetNodeTemplate : function(NodeID) {
		return myOrg.nodes(NodeID).template();
	},
	/**
	 * 디자인명(기본형) 반환
	 */
	GetNodeTemplateBase : function(NodeID) {
		var template1 = myOrg.nodes(NodeID).template();
		if ( template1.indexOf("_Focus") > 0 ) template1 = template1.replace(/_Focus/g, '');
		if ( template1.indexOf("_Move")  > 0 ) template1 = template1.replace(/_Move/g,  '');
		if ( template1.indexOf("_Close") > 0 ) template1 = template1.replace(/_Close/g, '');
		return template1;
	},
	/**
	 * 하위노드 존재 여부 반환
	 * @param NodeId
	 * @returns
	 */
	HasChildren : function(NodeId) {
		var isExists  = false;
		var childrens = myOrg.nodes(NodeId).children();
		if(childrens != null && childrens != undefined && childrens.length > 0) {
			isExists = true
		}
		return isExists;
	},
	/**
	 * 하위노드 객체 반환
	 * @param NodeId
	 * @returns
	 */
	GetChildren : function(NodeId) {
		return myOrg.nodes(NodeId).children();
	},
	/**
	 * ChildNodeId가 NodeId의 하위 노드인지 여부 반환
	 */
	IsChildren : function(NodeId, ChildNodeId) {
		//console.log('IsChildren', "NodeId : " + NodeId +", ChildNodeId : " + ChildNodeId);
		var flag = false;
		var childrens = myOrg.nodes(NodeId).children();
		
		// 하위 노드가 존재하는 경우 진행
		if(childrens != null && childrens != undefined && childrens.length > 0) {
			var subChildren = null;
			for(var i = 0; i < childrens.length; i++) {
				// 초기화
				flag = false;
				
				// 현재 인덱스에 해당하는 노드가 확인대상 하위노드인 경우
				if(childrens[i].key == ChildNodeId) {
					
					flag = true;
					break;
					
				} else {
					
					// 하위노드가 존재하는지 확인 후 하위 노드에 확인대상노드가 존재하는지 확인 처리함.
					subChildren = myOrg.nodes(childrens[i].key).children();
					
					// 현재인덱스에 해당하는 노드에 하위 노드가 존재하는 경우 진행
					// 하위 노드에 대하여 재귀적으로 체크함으로써 최하위 노드까지 확인함.
					if(subChildren != null && subChildren != undefined && subChildren.length > 0) {
						flag = orgObj.IsChildren(childrens[i].key, ChildNodeId);
						if(flag) {
							break;
						}
					}
					
				}
			}
		}
		
		return flag;
	},
	/**
	 * 상위부서코드가 변경되었는지 여부 반환
	 */
	IsChangedPriorCd : function(NodeId, PriorOrgCd) {
		var isChangedPriorCd = false;
		var sheetIdx = sheetObj.GetNodeSheetIdx(NodeId);
		var priorOrgCdAfter = sheetObj.GetCellValue(sheetIdx, "priorOrgCdAfter");
		
		// "priorOrgCdAfter" 데이터가 존재하는 경우      ==> "priorOrgCdAfter" 데이터와 비교하여 상위부서코드가 변경되었는지 판단
		// "priorOrgCdAfter" 데이터가 존재하지 않는 경우 ==> orgObj 노드의 상위부서코드 데이터와 비교하여 변경되었는지 판단
		if(
			(priorOrgCdAfter != null && priorOrgCdAfter != undefined && priorOrgCdAfter != "" && priorOrgCdAfter != PriorOrgCd)
			|| (orgObj.GetNodeDBData(NodeId, "updeptcd") != PriorOrgCd)
		) {
			isChangedPriorCd = true;
		}
		return isChangedPriorCd;
	},
	/**
	 * 지정 상위 노드ID의 하위 노드의 최대순번값 반환
	 * @param PriorNodeId
	 * @returns
	 */
	MaxSeq : function(PriorNodeId) {
		var maxSeq    = 0;
		var childrens = myOrg.nodes(PriorNodeId).children();
		
		// 하위 노드가 존재하는 경우 진행
		if(childrens != null && childrens != undefined && childrens.length > 0) {
			var seq = null;
			for(var i = 0; i < childrens.length; i++) {
				seq = Number(orgObj.GetNodeDBData(childrens[i].key, "seq"));
				if(seq > maxSeq) {
					maxSeq = seq;
				}
			}
		}
		
		return maxSeq;
	},
	/**
	 * 시트 데이터를 조직도 데이터로 변경
	 */
	sheetToOrg : function() {

		var i , j
			, cnt = sheetObj.RowCount()
			, orgData = []
			, orgJson
			, designName = $("#treeType").val();

		var viewType = $("#viewType").val();
		var template = "";

		for ( i = 1 ; i <= cnt ; i++ ) {
			orgJson = {};

			design 				= "";
			deptCd 				= sheetObj.GetCellValue( i , "orgCd" );						// 부서코드
			deptNm 				= sheetObj.GetCellValue( i , "orgNm" );						// 부서명
			updeptCd 			= sheetObj.GetCellValue( i , "priorOrgCd" );				// 상위부서코드
			nodedesign 			= sheetObj.GetCellValue( i , "nodedesign" );
			deptLevel 			= sheetObj.GetCellValue( i , "orgLevel" );
			chief_position_nm 	= sheetObj.GetCellValue( i , "chiefPositionNm" );
			chief_nm 			= sheetObj.GetCellValue( i , "chiefNm" );
			seq 				= sheetObj.GetCellValue( i , "seq" );
			supporter 			= sheetObj.GetCellValue( i , "directYn" );
			changeGubun 		= sheetObj.GetCellValue( i , "changeGubun" );
			const subOrgVerticalOrderYn = ( sheetObj.GetCellValue( i, "vrtclOrderYn" ) === "Y" ); // 하위조직 세로정렬 여부
			
			template = (viewType == "") ? nodedesign : viewType;
			if(changeGubun != "") {
				template += (changeGubun == "4") ? "_Close" : "_Move";
			}

			// 디자인 설정
			orgJson.template = template;
			//orgJson.template = 'Org';
			

			// 레이아웃(레벨 값, 보조자 값) 설정
			orgJson.layout = {};

			// 노드 레벨값
			orgJson.layout['level'] = Number(deptLevel);
			if (subOrgVerticalOrderYn) {
				orgJson.layout.alignment = "busr";
			}

			// 보조자 설정
			if ( supporter  == "Y" ) {
				orgJson.layout['supporter'] = Number(deptLevel);
			}

			// 링크 연결선
			orgJson.link = {};
			orgJson.link.style = {};
			orgJson.link.style['borderColor'] = "red";

			orgJson.fields = {};

			// 테이블 리스트형 인 경우
			orgJson.fields['pkey'] = deptCd;				// pkey : 자신의 ID
			orgJson.fields['rkey'] = updeptCd;				// mkey : 테이블 구조에서 부모 ID

			orgJson.fields['deptcd'] = deptCd;
			orgJson.fields['deptnm'] = deptNm;
			orgJson.fields['updeptcd'] = updeptCd;
			orgJson.fields['seq'] = seq;
			orgJson.fields['chief_position_nm'] = chief_position_nm;
			orgJson.fields['chief_nm'] = chief_nm;

			//console.log('orgJson : ' + JSON.stringify(orgJson) );
			orgData.push(orgJson);
		}

		// 폰트명
		var fontName = 'NanumGothic';

		var jsonData = {};

		// 모델, 디자인 정보를 가져오면서 폰트명 변경(임시)
		// 폰트명, 폰트사이즈를 변경하기 위한 고도화 작업이 필요함.
		jsonData = (JSON.stringify(ibconfig)).replace(/Dotum/gi, fontName);
		jsonData = JSON.parse(jsonData);


		// 데이터 반영
		jsonData.orgData = orgData;

		// 화상조직도 데이터를 조회
		orgObj.loadJson(jsonData);
	},
};