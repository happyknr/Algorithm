package com.common;

import java.util.Calendar;
import java.util.HashMap;
import java.util.LinkedHashMap;

public class Common {
	
	public Common() {
		
	}
	
	public HashMap<String, String> getPackageName_UX() 
	{
		
		HashMap<String, String> packageNameMap = new LinkedHashMap<String, String>();
		
		packageNameMap.put("com_skt_tlife","T life");
		packageNameMap.put("skplanet_musicmate","Musicmate");
		packageNameMap.put("com_skt_sh","Smart Home");
		packageNameMap.put("com_real_tcolorring","T colorring");
		packageNameMap.put("com_skt_skaf_l001mtm091","T map");
		packageNameMap.put("com_skplanet_tmaptaxi_android_passenger","T taxi");
		packageNameMap.put("com_skp_lbs_ptransit","T 대중교통");
		packageNameMap.put("com_skp_launcher_theme","T 배경화면");
		packageNameMap.put("com_skplanet_weatherpong_mobile","Weatherpong");
		packageNameMap.put("com_skp_tsearch","T 검색");
		packageNameMap.put("com_sktechx_volo","VOLO");
		/*packageNameMap.put("com_skt_prod_cloud","클라우드베리");*/
		packageNameMap.put("com_skp_launcher","런처플래닛");
		packageNameMap.put("com_sktechx_datasoda","데이터소다 ");
		
		return packageNameMap;
	}
	
	public HashMap<String, String> getPackageName() 
	{
		
		HashMap<String, String> packageName = new LinkedHashMap<String, String>();
		
		packageName.put("T life", "com.skt.tlife");
		packageName.put("Musicmate","skplanet.musicmate");
		packageName.put("Smart Home","com.skt.sh");
		packageName.put("T colorring","com.real.tcolorring");
		packageName.put("T map","com.skt.skaf.l001mtm091");
		packageName.put("T taxi","com.skplanet.tmaptaxi.android.passenger");
		packageName.put("T 대중교통","com.skp.lbs.ptransit");
		packageName.put("T 배경화면","com.skp.launcher.theme");
		packageName.put("Weatherpong","com.skplanet.weatherpong.mobile");
		packageName.put("T 검색","com.skp.tsearch");
		/*packageName.put("T cloud","com.skt.tbagplus");*/
		packageName.put("VOLO","com.sktechx.volo");
		/*packageName.put("클라우드베리","com.skt.prod.cloud");*/
		packageName.put("런처플래닛","com.skp.launcher");
		packageName.put("데이터소다	","com.sktechx.datasoda");
		
		return packageName;
	}
	
	public String getDate(String sdate)
	{
		if(sdate == null || sdate == "")
		{
			String lastMonth = "";
			Calendar cal = Calendar.getInstance();
			cal.add ( cal.MONTH, -1 );
			
			if(cal.get(cal.MONTH) < 10) 
			{
				if(cal.get(cal.DATE) < 10)
				{
					lastMonth = cal.get(cal.YEAR) + "-0" + (cal.get ( cal.MONTH )+1)  + "-0" + cal.get(cal.DATE);
				}
				else
				{
					lastMonth = cal.get(cal.YEAR) + "-0" + (cal.get ( cal.MONTH )+1)  + "-" + cal.get(cal.DATE);
				}
			} 
			else
			{
				if(cal.get(cal.DATE) < 10)
				{
					lastMonth = cal.get(cal.YEAR) + "-" + (cal.get ( cal.MONTH )+1)  + "-0" + cal.get(cal.DATE);
				}
				else
				{
					lastMonth = cal.get(cal.YEAR) + "-" + (cal.get ( cal.MONTH )+1)  + "-" + cal.get(cal.DATE);
				}
			}
			
			sdate = lastMonth;
		} 
		return sdate;
	}
	
}
