package com.example.model;

import java.util.ArrayList;
import java.util.List;

public class Expert {
	public List<String> getBrands(String color)
	{
		List<String> brands = new ArrayList<String>();
		if(color.equals("red"))
		{
			brands.add("red brand");
			brands.add("red brand2");
		}
		else
		{
			brands.add("no red");
		}
		
		return brands;
	}
}
