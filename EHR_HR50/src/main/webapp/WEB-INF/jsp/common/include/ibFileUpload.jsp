<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script>

    /**
     * ibSheet 파일 업로드를 위한 초기화 함수
     * - form 에 ibFileListArrTemp, ibFileListArr 삽입
     * @param form form object
     */
    function initIbFileUpload(form) {
        // form에 input 추가
        form.append('<input id="ibFileListArrTemp" name="ibFileListArrTemp" type="hidden">');
        form.append('<input id="ibFileListArr" name="ibFileListArr" type="hidden">');
    }

    /**
     * clearFileListArr 함수 호출 시점 처리
     * @param func clearFileListArr 이후 호출 할 함수
     *  - sheet1.DoSearch 함수를 매개변수로 넘긴 경우, 해당 함수 호출 직전에 clearFileListArr 함수를 호출하도록 함.
     */
    function clearBeforeFunc(func) {
        return function (...args) {
            let sheetId = func.name.match(/^(.*?)(_|[.])/)[1];
            clearFileListArr(sheetId);
            return func(...args);
        }
    }

    /**
     * ibFileListArr 값 초기화
     * @param sheetId 초기화 할 sheet의 Id
     *  - 한 프로그램에 sheet가 여러개이고 각각의 sheet가 첨부파일을 가지는 경우, sheet별로 ibFileListArr 값이 초기화 되어야 함.
     */
    function clearFileListArr(sheetId) {
        if(sheetId !== '') {
            // JSON 문자열을 파싱하여 JSON 배열로 변환
            if($("#ibFileListArrTemp").val() != '' && $("#ibFileListArrTemp").val() != '[]') {
                let ibFileListArrTemp = JSON.parse($("#ibFileListArrTemp").val());
                if(ibFileListArrTemp.length > 0) {
                    let newIbFileListArr = ibFileListArrTemp.filter(item => item.sheet !== sheetId);

                    // JSON 배열을 다시 문자열로 변환하여 input에 설정
                    $("#ibFileListArr").val(JSON.stringify(newIbFileListArr));
                    $("#ibFileListArrTemp").val('');
                }
            } else {
                $("#ibFileListArr").val('')
            }
        } else {
            $("#ibFileListArr").val('')
        }

    }

    /**
     * ibFileListArr에 처리할 파일 목록 데이터 대입
     * @param sheetId 처리 할 sheet의 Id
     *  - 한 프로그램에 sheet가 여러개이고 각각의 sheet가 첨부파일을 가지는 경우, sheet별로 ibFileListArr 값을 처리하여야 함.
     */
    function setFileListArr(sheetId) {
        if(sheetId !== '') {
            // JSON 문자열을 파싱하여 JSON 배열로 변환
            if($("#ibFileListArr").val() != '') {
                let ibFileListArr = JSON.parse($("#ibFileListArr").val());
                if(ibFileListArr.length > 0) {
                    let applyIbFileListArr = ibFileListArr.filter(item => item.sheet === sheetId);
                    let ibFileListArrTemp = ibFileListArr.filter(item => item.sheet !== sheetId);

                    // JSON 배열을 다시 문자열로 변환하여 input에 설정
                    $("#ibFileListArr").val(JSON.stringify(applyIbFileListArr));
                    $("#ibFileListArrTemp").val(JSON.stringify(ibFileListArrTemp));
                }
            }
        }
    }

    /**
     * ibFileListArr 에 반영할 파일 목록 및 상태 입력
     * 레이어 팝업 trigger 에 필수로 추가해 주어야 함.
     * @param sheet 파일 업로드를 적용한 ibSheet 객체
     * @param row sheet의 Row
     * @param result file upload Layer 결과
     */
    function addFileList(sheet, row, result) {

        var ibFileListArr = new Array();
        var oldIbFileListArr = $("#ibFileListArr").val();

        // JSON 문자열을 파싱하여 JSON 배열로 변환
        if($("#ibFileListArr").val() != '')
            ibFileListArr = JSON.parse($("#ibFileListArr").val());

        // 새로운 데이터를 JSON 배열에 추가
        var fileList = result.fileList;
        if(fileList != null && fileList.length > 0) {
            var fileInfo = { "fileSeq": result.fileSeq, "fileList": fileList, "uploadType": result.uploadType};

            // 시트 정보가 함께 넘어온 경우, 시트id 값 저장 (여러 시트가 한 페이지에 있는 경우, 어떤 시트에서 파일 업로드 작업을 수행했는지 확인하기 위함.
            if(sheet != null)
                fileInfo.sheet = sheet.id;

            if(ibFileListArr.length > 0) {
                var idx = ibFileListArr.findIndex(obj => obj.fileSeq === fileInfo.fileSeq);
                if (idx !== -1) {
                    // 중복된 fileSeq 값을 가진 객체가 있으면 해당 객체의 값을 교체
                    ibFileListArr[idx] = fileInfo;
                } else {
                    // 중복된 fileSeq 값을 가진 객체가 없으면 새로운 데이터를 배열에 추가
                    ibFileListArr.push(fileInfo);
                }
            } else {
                ibFileListArr.push(fileInfo);
            }

            // JSON 배열을 다시 문자열로 변환하여 input에 설정
            $("#ibFileListArr").val(JSON.stringify(ibFileListArr));

            // 값이 변경 되었다면, 상태 값 변경
            if(sheet != null && row != null) {
                if(oldIbFileListArr != $("#ibFileListArr").val()) {
                    sheet.SetCellValue(row, "sStatus", 'U');
                }
            }
        }
    }

    /**
     * ibFileListArr의 값을 Json 형태로 가져오기
     * @param fileSeq TSYS200.FILE_SEQ 값
     */
    function getFileList(fileSeq) {
        var res = '';
        var ibFileListArr = new Array();

        // JSON 문자열을 파싱하여 JSON 배열로 변환
        if($("#ibFileListArr").val() !== '' && (fileSeq !== '' || fileSeq !== null)) {
            ibFileListArr = JSON.parse($("#ibFileListArr").val());
            var ibFileList = ibFileListArr.find(obj => obj.fileSeq === fileSeq);
            if(typeof ibFileList != 'undefined' && typeof ibFileList.fileList != 'undefined')
                res = JSON.stringify(ibFileList.fileList);

        }
        return res;
    }
</script>