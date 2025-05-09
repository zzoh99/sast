package com.hr.common.util.fileupload.jfileupload.web;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
import java.math.BigDecimal;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


@Service("JFileUploadService")
public class JFileUploadService{

	@Inject
	@Named("Dao")
	private Dao dao;


	/**
	 * @return String
	 * @throws Exception
	 */
	public String jFileSequence() throws Exception {
		Log.Debug();
		Map<?, ?> jfileseqmap = dao.getMap("jFileSequence", new HashMap<>() );
		return jfileseqmap != null && jfileseqmap.get("seq") != null ? jfileseqmap.get("seq").toString():null;
	}
	
	public Map<?, ?> jFileCount(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Map<?, ?>) dao.getMap("jFileCount", paramMap);
	}
	
	public Collection<?> fileSearchByFileSeq(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Collection<?>) dao.getList("fileSearchByFileSeq", paramMap);
	}
	
	public Map<?, ?> fileSearchBySeqNo(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		
		return (Map<?, ?>) dao.getMap("fileSearchBySeqNo", paramMap);
	}
	
	public List<?> jFileList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("fileSearch", paramMap);
	}
	
	public List<?> jIbFileList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("ibFileSearch", paramMap);
	}
	
	public Map<?, ?> tsys202Search(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		
		return (Map<?, ?>) dao.getMap("tsys202Search", paramMap);
	}
	
	public boolean fileStoreSave(Map<?, ?> saveMap1, List<Map<?, ?>> saveList2, List<Map<?, ?>> saveList3) throws Exception {
		Log.Debug();
		
		if(saveMap1 != null) {
			int r1 = dao.create("tsys200save", saveMap1);
			
			if(r1 == -1) {
				return false;
			}
		}
		
		if(saveList2 != null && saveList2.size() > 0) {
			int[] r2 = dao.batchUpdate("tsys201save", saveList2);
			
			for (int i = 0; i < r2.length; i++) {
				if (r2[i] == -1) {
					return false;
				}
			}
		}
		
		if(saveList3 != null && saveList3.size() > 0) {
			int[] r3 = dao.batchUpdate("tsys202save", saveList3);
			
			for (int i = 0; i < r3.length; i++) {
				if (r3[i] == -1) {
					return false;
				}
			}
		}
		
		
		return true;
	}
	
	public boolean fileStoreDelete(List<Map<?, ?>> list, boolean isDeleteTsys202) throws Exception {
		Log.Debug();

		int[] r2 = dao.batchUpdate("tsys201Delete", list);

		for (int i = 0; i < r2.length; i++) {
			if (r2[i] == -1) {
				return false;
			}
		}

		int tsys201Cnt = 0;

		Map<String, Object> chkMap = new HashMap<String, Object>();
		chkMap.put("ssnEnterCd", list.get(0).get("enterCd"));
		chkMap.put("fileSeq", list.get(0).get("fileSeq"));

		List<?> result = (List<?>) dao.getList("jFileCheckCount", chkMap);
		if (result != null && result.size() > 0) {
			Map<String, Object> map = (Map<String, Object>) result.get(0);
			tsys201Cnt = ((BigDecimal) map.get("cnt")).intValue();
		}

		if (tsys201Cnt == 0) {
			int[] r = dao.batchUpdate("tsys200Delete", list);

			for (int i = 0; i < r.length; i++) {
				if (r[i] == -1) {
					return false;
				}
			}

			if (isDeleteTsys202) {
				r = dao.batchUpdate("tsys202Delete", list);

				for (int i = 0; i < r.length; i++) {
					if (r[i] == -1) {
						return false;
					}
				}
			}
		}
		return true;
	}



	public boolean filePhotoStoreSave(Map<?, ?> saveMap1, List<Map<?, ?>> saveList2, List<Map<?, ?>> saveList3, List<Map<?, ?>> saveList4) throws Exception {
		Log.Debug();

		if(saveMap1 != null) {
			int r1 = dao.create("tsys200save", saveMap1);

			if(r1 == -1) {
				return false;
			}
		}

		if(saveList2 != null && saveList2.size() > 0) {
			int[] r2 = dao.batchUpdate("tsys201save", saveList2);

			for (int i = 0; i < r2.length; i++) {
				if (r2[i] == -1) {
					return false;
				}
			}
		}

		//thrm911 save
		if(saveList3 != null && saveList3.size() > 0) {
			int[] r3 = dao.batchUpdate("thrm911ImageInsert2", saveList3);

			for (int i = 0; i < r3.length; i++) {
				if (r3[i] == -1) {
					return false;
				}
			}
		}


		//emppicture save
		if(saveList4 != null && saveList4.size() > 0) {
			dao.batchUpdate("employeePictureBlodDelete", saveList4);
			int[] r4 = dao.batchUpdate("employeePictureBlodInsert", saveList4);
			dao.batchUpdate("employeePictureBlodUpdateClob", saveList4);

			for (int i = 0; i < r4.length; i++) {
				if (r4[i] == -1) {
					return false;
				}
			}
		}


		return true;
	}

	public boolean fileRecordStoreSave(Map<?, ?> saveMap1, List<Map<?, ?>> saveList2, List<Map<?, ?>> saveList3) throws Exception {
		Log.Debug();

		if(saveMap1 != null) {
			int r1 = dao.create("tsys200save", saveMap1);

			if(r1 == -1) {
				return false;
			}
		}

		if(saveList2 != null && saveList2.size() > 0) {
			int[] r2 = dao.batchUpdate("tsys201save", saveList2);

			for (int i = 0; i < r2.length; i++) {
				if (r2[i] == -1) {
					return false;
				}
			}
		}

		//thrm185 save PsnalRecordUpload-mapping-query.xml
		if(saveList3 != null && saveList3.size() > 0) {
			int[] r3 = dao.batchUpdate("thrm185Insert", saveList3); //

			for (int i = 0; i < r3.length; i++) {
				if (r3[i] == -1) {
					return false;
				}
			}
		}
		return true;
	}

	public boolean yjungsanPdfSave(List<Map<?, ?>> saveList1) throws Exception {
		Log.Debug();

		if(saveList1 != null && saveList1.size() > 0) {
			int[] r1 = dao.batchUpdate("tyea105save", saveList1);

			for (int i = 0; i < r1.length; i++) {
				if (r1[i] == -1) {
					return false;
				}
			}
		}

		return true;
	}

	public boolean yjungsanPdfDelete(List<Map<?, ?>> list) throws Exception {
		Log.Debug();

		if(list != null && list.size() > 0) {
			int[] r = dao.batchUpdate("tyea105Delete", list);

			for (int i = 0; i < r.length; i++) {
				if (r[i] == -1) {
					return false;
				}
			}
		}

		return true;
	}
}