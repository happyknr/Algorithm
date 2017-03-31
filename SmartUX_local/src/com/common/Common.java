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
		packageNameMap.put("com_skp_lbs_ptransit","T ���߱���");
		packageNameMap.put("com_skp_launcher_theme","T ���ȭ��");
		packageNameMap.put("com_skplanet_weatherpong_mobile","Weatherpong");
		packageNameMap.put("com_skp_tsearch","T �˻�");
		packageNameMap.put("com_sktechx_volo","VOLO");
		/*packageNameMap.put("com_skt_prod_cloud","Ŭ���庣��");*/
		packageNameMap.put("com_skp_launcher","��ó�÷���");
		packageNameMap.put("com_sktechx_datasoda","�����ͼҴ� ");
		
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
		packageName.put("T ���߱���","com.skp.lbs.ptransit");
		packageName.put("T ���ȭ��","com.skp.launcher.theme");
		packageName.put("Weatherpong","com.skplanet.weatherpong.mobile");
		packageName.put("T �˻�","com.skp.tsearch");
		/*packageName.put("T cloud","com.skt.tbagplus");*/
		packageName.put("VOLO","com.sktechx.volo");
		/*packageName.put("Ŭ���庣��","com.skt.prod.cloud");*/
		packageName.put("��ó�÷���","com.skp.launcher");
		packageName.put("�����ͼҴ�	","com.sktechx.datasoda");
		
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
