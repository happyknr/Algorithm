package com.example.web;

import java.io.IOException;
import java.util.Iterator;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.example.model.Expert;

public class select extends HttpServlet {

	private static final long serialVersionUID = 1L;
	
	public select()
	{
		super();
	}
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
	{
		
	}
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
	{
		String c = request.getParameter("color");
		System.out.println("선택값 : " + c);
		Expert expert = new Expert();
		List<String> result = expert.getBrands(c);
		
		Iterator<String> iterator = result.iterator();
		while(iterator.hasNext())
		{
			System.out.println(iterator.next());
		}
		System.out.println();
		
		request.setAttribute("styles", result);
		
		RequestDispatcher view = request.getRequestDispatcher("result.jsp");
		view.forward(request, response);
	}
}
