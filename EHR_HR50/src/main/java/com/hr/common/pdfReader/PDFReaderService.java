package com.hr.common.pdfReader;
import java.io.File;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;


@Service("PDFReaderService")
public class PDFReaderService{
	@Inject
	@Named("Dao")
	private Dao dao;

	public List<?> getPDFReaderList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList("getPDFReaderList", paramMap);
	}
	
	public List<?> getPDFReaderCopyList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList("getPDFReaderCopyList", paramMap);
	}

	/**
	 * 사번 갖고와 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getTHRM100Sabun(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getTHRM100Sabun", paramMap);
	}
	
	/**
	 * 1 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int savePDFReader(Map<?, ?> convertMap, HttpServletRequest request) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deletePDFReader", convertMap);
			
			List<?> list = ((List<?>)convertMap.get("deleteRows"));
			
			for ( int i=0; i < list.size(); i++ ) {
				HashMap<String, Object> map  =  (HashMap<String, Object>)list.get(i);
				
				String filePath = (String) map.get("filePath");
				String fileNm   = (String) map.get("fileNm");
				String fileName    = filePath + "/" + fileNm;
				
				fileDelete(fileName);
			}
			
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("savePDFReader", convertMap);
			
			List<?> list = ((List<?>)convertMap.get("mergeRows"));
			
			for ( int i=0; i < list.size(); i++ ) {
				HashMap<String, Object> map  =  (HashMap<String, Object>)list.get(i);
				
				String filePath = (String) map.get("filePath");
				String fileNm   = (String) map.get("fileNm");
				
				String pageStart   = (String) map.get("pageStart");
				String workYy      = (String) map.get("workYy");
				String sabun       = (String) map.get("sabun");
				
				String fileName    = filePath + "/" + fileNm;
				String newFileName = filePath + "/" + ( sabun + "_" + workYy + "_" + pageStart + ".pdf" );
				
				rNmFile(fileName, newFileName);
			}
		}

		return cnt;
	}
	
	public int insertPDFReaderTCPN574(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		
		int cnt=0;
			  dao.delete("deletePDFReaderTCPN574", paramMap);
		cnt = dao.update("insertPDFReaderTCPN574", paramMap);
		
		return cnt;
	}
	public int createPDFReader(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		int cnt=0;

		dao.delete("deletePDFReaderAll", paramMap);

		HashMap<String, Object> returnMap 	= new HashMap<String, Object>();
		List<Serializable>  mergeRows		= new ArrayList<Serializable>();

		List<?> list = (List<?>) paramMap.get("list");
		int totCnt = ((List<?>) paramMap.get("list")).size();
		int chkCnt = 0;
		int nCnt = totCnt%100;

		for (int i = 0; i < list.size(); i++ ){
			HashMap<String, Object> map  =  (HashMap<String, Object>)list.get(i);
			returnMap.put("ssnEnterCd",(String) paramMap.get("ssnEnterCd"));
			returnMap.put("ssnSabun",(String) paramMap.get("ssnSabun"));
			returnMap.put("yyyy",(String) paramMap.get("yyyy"));
			returnMap.put("adjustType",(String) paramMap.get("adjustType"));

			map.put("seqNo", "");
			mergeRows.add(map);
			returnMap.put( "mergeRows" , mergeRows );

			if( totCnt >= chkCnt ){
				chkCnt++;
			}

			if ( chkCnt == 100 ){
				cnt += dao.update("createPDFReader", returnMap);
				totCnt = totCnt - chkCnt;
				chkCnt = 0;
				mergeRows		= new ArrayList<Serializable>();
			}else {
				if ( totCnt == nCnt && totCnt == chkCnt ){
					cnt += dao.update("createPDFReader", returnMap);
				}
			}
		}
		mergeRows		= new ArrayList<Serializable>();

		Log.Debug();
		return cnt;
	}
	
	public void rNmFile(String fileName, String newFileName) {
		
		File file = new File(  fileName );
		File fileNew = new File( newFileName );
		if( file.exists() ) {
			file.renameTo( fileNew );
		}
	}
	
	 public static void fileDelete(String fileName) {
		File file = new File(fileName);
		if( file.exists() ) {
			file.deleteOnExit();
		}
	 }
}