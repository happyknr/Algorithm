package com.common;

import java.io.File;
import java.util.Arrays;
import java.util.Comparator;
import java.util.LinkedHashMap;
import java.util.Map;

public class FileUtils {

	public final int COMPARETYPE_NAME = 0;
	public final int COMPARETYPE_DATE = 1;

	/* 파일 정렬을 위한 메소드 */
	public File[] sortFileList(File[] files, final int compareType) 
	{
		Arrays.sort(files, new Comparator<Object>() 
		{
			public int compare(Object object1, Object object2) 
			{
				String s1 = "";
				String s2 = "";
				if (compareType == COMPARETYPE_NAME) 
				{
					s1 = ((File) object1).getName();
					s2 = ((File) object2).getName();
				} 
				else if (compareType == COMPARETYPE_DATE) 
				{
					s1 = ((File) object1).lastModified() + "";
					s2 = ((File) object2).lastModified() + "";
				}
				return s1.compareTo(s2);
			}
		});
		return files;
	}
	
	/* 파일 정렬을 위한 메소드 */
	public File[] sortFileList_desc(File[] files) 
	{
		Arrays.sort(files, new Comparator<Object>() 
		{
			public int compare(Object object1, Object object2) 
			{
				File f1 = (File)object1;
				File f2 = (File)object2;
				
				if (f1.lastModified() > f2.lastModified())
				return -1;
				
				if (f1.lastModified() == f2.lastModified())
				return 0;
				
				return 1;
			}
		});
		
		return files;
	}
	
	public Map<String, String> changeOverviewKeyName(Map<String, String> map)
	{
		Map<String, String> newOverviewName = new LinkedHashMap<String, String>();
		
		newOverviewName.put("테스트명", map.get("Test Name"));
		newOverviewName.put("테스트 대상 버전", map.get("Package Version"));
		newOverviewName.put("테스트 수행일", map.get("Test Date"));
		newOverviewName.put("테스트케이스 #", map.get("Test Case #"));
		newOverviewName.put("PASS #", map.get("Pass #"));
		newOverviewName.put("FAIL #", map.get("Fail #"));
		newOverviewName.put("테스트 단말", map.get("Device Name"));
		newOverviewName.put("단말 OS", map.get("Device Version"));
		
		map.clear();
		return newOverviewName;
	}
}
