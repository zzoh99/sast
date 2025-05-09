<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>tus fileupload test</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

</head>
	<script type="text/javascript">

		$(function() {

			$("#searchYear").val("${curSysYear}");

			$("#searchYear").bind("keyup",function(event){
				makeNumber(this,"A");
				if( event.keyCode == 13){ fetchData(); $(this).focus(); }
			});

			init_sheet();


		});

		function formatBytes(bytes, decimals = 2) {
			if (!bytes) return '0Bytes';
			const k = 1024;
			const sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'];
			const dm = decimals < 0 ? 0 : decimals;
			const i = Math.floor(Math.log(bytes) / Math.log(k));
			const sizeString = parseFloat((bytes / Math.pow(k, i)).toFixed(dm)).toLocaleString();
			return sizeString+sizes[i];
		}

		function init_sheet(){

			const initdata1 = {};
			initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};

			initdata1.Cols = [
				{Header:"<sht:txt mid='sNo'       mdef='No'/>",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
				{Header:"선택",		Type:"CheckBox",	Hidden:0,  Width:50,   Align:"Center",  ColMerge:0,   SaveName:"copy",			KeyField:0,   CalcLogic:"",   Format:"",			PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1, TrueValue:"Y", FalseValue:"N" },
				{Header:"<sht:txt mid='name'  mdef='파일명'/>",			Type:"Text",	Hidden:0,Width:200,	Align:"Center",	ColMerge:0,	SaveName:"name",	Sort:0 },
				{Header:"<sht:txt mid='size'   mdef='용량'/>",		Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"size",		Format:"",		},
				{Header:"<sht:txt mid='key'   mdef='key'/>",		Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"key",		Format:"",		},
			]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

			sheet1.SetHeaderRowHeight(50);

			$(window).smartresize(sheetResize); sheetInit();
			fetchData()
		}

		async function fetchData (){
			const data = await fetch("/tus/api/read?path="+$('#searchYear').val()).then(async response=>{
				 const data = await response.json();
				return data.map(file=>({
					...file,
					size:formatBytes(file.size)
				}))
			})
			sheet1.LoadSearchData({ data, append: true })
		}
		function upload(){
			if($('#searchYear').val() == '' || $('#searchYear').val() == null) {
				alert('기준년도를 선택하세요.');
				return;
			}
			openUploadPopup()
		}

		function download(){
			const paths = sheet1.FindCheckedRow(1).split('|').map(i=>sheet1.GetRowData(i).key).filter(v=>v)

			if(!paths.length && !confirm('전체 파일을 다운 받으시겠습니까?')) return ;
			fetch("/tus/api/downloadZip"+(paths.length?"":"/all"),{
				method:"POST",
				headers: {
					'Content-Type': 'application/json'
				},
				body: JSON.stringify(paths.length?paths:{path:$('#searchYear').val()})
			}).then(async response=>{
				if(!response.ok) return alert(`다운로드 실패`)
				const blob = await response.blob(); // Blob 객체 가져오기

				const url = window.URL.createObjectURL(blob); // Blob URL 생성
				const a = document.createElement('a');
				a.style.display = 'none';
				a.href = url;
				a.download = 'files.zip';
				document.body.appendChild(a);
				a.click();
				window.URL.revokeObjectURL(url);
			})

		}

		function deleteFile(){
			const paths = sheet1.FindCheckedRow(1).split('|').map(i=>sheet1.GetRowData(i).key).filter(v=>v)
			if(!paths.length) return alert('삭제할 파일을 선택해 주세요.')

			fetch("/tus/api/delete",{
				method:"DELETE",
				headers: {
					'Content-Type': 'application/json'
				},
				body: JSON.stringify(paths)
			}).then(async response=>{
				if(!response.ok)
					alert(`삭제 완료`);
					fetchData()
			})
		}

		const debounce = ((delay=1000)=>{
			let timeout;
			return (fn)=>{
				clearTimeout(timeout);
				timeout = setTimeout(()=>fn(),delay)
			}
		})();

		function openUploadPopup(){
			if(!isPopup()) return;
			pGubun = "tusFileUploadLayer";
			var url 	= "${ctx}/Tus.do?cmd=viewTusFileUploadLayer";
			const p = {year: $('#searchYear').val()};
			var tusFileUploadLayer = new window.top.document.LayerModal({
				id: 'tusFileUploadLayer',
				url: url,
				parameters: p,
				width: 640,
				height: 700,
				title: '업로드',
				trigger: [
					{
						name: 'tusFileUploadTrigger',
						callback: function(rv) {
							debounce(()=>{
								fetchData()
							});
						}
					}
				]
			});
			tusFileUploadLayer.show();
		}

	</script>

	<body class="bodywrap">
	<div class="wrapper">
		<div class="sheet_search outer">
			<form id="srchFrm" name="srchFrm" >
				<table>
					<tr>
						<th><tit:txt mid='112270' mdef='기준년도'/></th>
						<td>
							<input type="text" id="searchYear" name="searchYear" class="date2 w80 center" maxlength="4"/>
						</td>
					</tr>
				</table>
			</form>
		</div>
		<div class="inner">
			<div class="sheet_title">
				<ul>
					<li class="btn">
						&nbsp;&nbsp;&nbsp;
						<btn:a href="javascript:download()" css="btn outline-gray authR" mid='download' mdef="다운로드"/>
						<btn:a href="javascript:deleteFile()" css="btn filled authA" mid='save' mdef="삭제"/>
						<btn:a href="javascript:upload()" css="btn filled authA" mid='upload' mdef="업로드"/>

					</li>
				</ul>
			</div>
		</div>
		<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
	</div>
	</body>

