/**
 * nodeEditObj : 화상조직도에 선택된 노드의 정보를 표시하기 위한 창
 */
var nodeEditObj = {
	config: {
		readonly : true		// 읽기 전용으로 할건지 설정
	},
	/**
	 * 초기화
	 */
	init: function () {
		this.create();
		this.bindEvent();
	},
	/**
	 * 생성
	 */
	create: function () {
		var
			fields = ibconfig.model.fields,
			json,
			fld,
			code,
			readonly = nodeEditObj.config.readonly,
			imgW = 80,		// 정보창 이미지 가로 사이즈
			imgH = 100		// 정보창 이미지 세로 사이즈
		;

		// 정보 영역 필드 정보 지우기
		$("#editPanelArea").html("");

		table = $("<table />", {"style": "width:96%; margin:16px;"});
		tbody = $("<tbody />");

		// 일반 노드 정보 표시
		fields.forEach(function(fld) {
			// ibconfig 설정에서 숨김으로 된 필드들은 표시하지 않는다.
			if (fld.alias.hidden == true) {
				return true;		// continue 과 동일
			}

			// 구분
			tr = $("<tr />");

			// 명칭
			td = $("<td />", {"style": "min-width:60px;width:60px;"});
			td.append(fld.name);
			tr.append(td);

			td = $("<td />");

			if (fld.type === "picture") {
				input = $("<img />", { "class": "editNodeCol", id: "txt_" + fld.code, "style": "width:" + imgW + "px;height:" + imgH + "px;" });
			} else {
				// 값을 입력 받을 input 영역
				input = $("<input />", { type: "text", "class": "editNodeCol", id: "txt_" + fld.code, "readonly": readonly });
			}

			td.append(input);
			tr.append(td);

			tbody.append(tr);
		});

		// 공동 조직장일때 표시
		fields.forEach(function(fld) {
			// ibconfig 설정에서 숨김으로 된 필드들은 표시하지 않는다.
			if (fld.alias.hidden == true) {
				return true;		// continue 과 동일
			}

			// 구분
			tr = $("<tr class='dualNodeCol' style='display:none;'/>");

			// 명칭
			td = $("<td />", {"style": "min-width:60px;width:60px;"});
			td.append(fld.name);
			tr.append(td);

			// 값을 입력 받을 input 영역
			td = $("<td />");

			if (fld.type === "picture") {
				input = $("<img />", { "class": "editNodeCol", id: "txt_" + fld.code + "2", "style": "width:" + imgW + "px;height:" + imgH + "px;" });
			} else {
				// 값을 입력 받을 input 영역
				input = $("<input />", { type: "text", "class": "editNodeCol", id: "txt_" + fld.code + "2", "readonly": readonly });
			}

			td.append(input);
			tr.append(td);

			tbody.append(tr);
		});

		table.append(tbody);

		// 정보 영역에 위의 내용을 추가한다.
		$("#editPanelArea").append(table);
	},
	/**
	 *  bindEvent
	 */
	bindEvent: function () {
		/**
		 * 편집창 keyup 이벤트
		 * JQuery 1.6.2 버전 호환을 맞추기 위하 on 이벤트 대신 keyup을 사용
		 */
		$(".editNodeCol").keyup(function () {
			var
				col = this.id.replace("txt_", ""),		// 규칙에 의해 컬럼 값을 가져옴.
				nodes = orgObj.SelectNodeID(),			// 선택된 노드
				nodeID,
				key = ibconfig.model.useKey,
				row
			;

			// 선택된 노드가 없거나 2개 이상인 경우, 실행하지 않는다.
			// 노드는 하나만 선택해야 한다.
			if (nodes.length == 0 || nodes.length > 1) {
				return;
			}

			// 노드 ID
			nodeID = nodes.pkey();

			// 노드와 매칭되는 시트의 Row를 찾는다.
			row = sheetObj.FindText(key, nodeID);

			if (row > 0) {
				// 키가 눌리면 시트에 내용을 받영한다.
				sheetObj.SetCellValue(row, col, this.value);
				// 키가 눌리면 조직도 노드에 내용을 받영한다.
				orgObj.SetNodeDBData(nodeID, col, this.value);
			}

		});
	},
	/**
	 * 노드 선택시, 노드에 필드에 해당하는 값을 정보창으로 표시한다.
	 * @param NodeID
	 */
	setEditData: function (NodeID) {
		var
			fields = ibconfig.model.fields,
			template
		;

		template = orgObj.GetNodeTemplate(NodeID);
		if (template.indexOf("Dual") == 0) {
			$(".dualNodeCol").show();

			fields.forEach(function(fld) {
				// ibconfig 설정에서 숨김으로 된 필드들은 표시하지 않는다.
				if (fld.alias.hidden == true) {
					return true;
				}

				code = "txt_" + fld.code + "2";
				val = orgObj.GetNodeDBData(NodeID, fld.code + "2");

				if (fld.type === "picture") {
					$("#" + code).attr("src", val);
				} else {
					$("#" + code).val(val);
				}
			});
		} else {
			$(".dualNodeCol").hide();
		}

		fields.forEach(function(fld) {
			// ibconfig 설정에서 숨김으로 된 필드들은 표시하지 않는다.
			if (fld.alias.hidden == true) {
				return true;
			}

			code = "txt_" + fld.code;
			val = orgObj.GetNodeDBData(NodeID, fld.code);

			if (fld.type === "picture") {
				$("#" + code).attr("src", val);
			} else {
				$("#" + code).val(val);
			}
		});

	}
};