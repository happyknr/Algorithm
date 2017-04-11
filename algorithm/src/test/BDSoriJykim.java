package test;

import java.util.Scanner;

public class BDSoriJykim {
	
	private static int songNumber;
	private static double fullResult = 0;
	static double tempPrice = 0;
	
	private int getSongNumber() {
		return songNumber;
	}
	
	private static void setSongNumber(int sn) {
		songNumber = sn;
	}

	private static double getFullResult() {
		return fullResult;
	}
	
	private static void setFullResult(double result) {
		fullResult = fullResult + result;
	}
	
	private static void setTempPrice(double tempPrice) {
		tempPrice = tempPrice;
	}
	
	BDSoriJykim(){
		setSongNumber(1);
		setFullResult(0);
	}
	
	public static void main(String args[]){
		try {
			//setSongNumber(Integer.parseInt(args[0]));
			System.out.println("프로그램 시작합니다.");
			setSongNumber(5);
		} catch (NumberFormatException e) {
			// TODO Auto-generated catch block
			System.out.println("정확한 숫자를 입력하여 주세요.");
			e.printStackTrace();
		}

		//StringBuffer sb = new StringBuffer();
		
		//SongList sl = new SongList(songNumber);
		
		SongList sl = new SongList(songNumber);
		//sl.initSongList(2);
		
		for(int nowCount=0;nowCount<songNumber;nowCount++){
			System.out.println("제목 : " + sl.getNames(nowCount));
			System.out.println("가격 : " + sl.getPrice(nowCount));
			System.out.println("할인율 : " + sl.getSalePercentage(nowCount));
			tempPrice = calcul(sl.getPrice(nowCount), sl.getSalePercentage(nowCount));
			//System.out.println("최종가격 : " + tempPrice);
			setFullResult(tempPrice);
			System.out.println();
		}
		
		//System.out.println("Total : " + getFullResult());
		
		Events ev = new Events();
		System.out.println("최종이벤트할인율 : " + ev.getFinalSale());
		
		double finalSaleResultPrice = calcul(getFullResult(), ev.getFinalSale());
		
		System.out.println("Total : " + finalSaleResultPrice);
		
	}
	
	private static double calcul(int price, double salePercentage){
		double result = 0;
		result = price - (price / 100 * salePercentage);
		return result;
	}
	
	private static double calcul(double price, double salePercentage){
		double result = 0;
		result = price - (price / 100 * salePercentage);
		return result;
	}
}

class SongList{
	String[] names;
	int[] price;
	double[] salePercentage;

	String getNames(int nc) {
		return this.names[nc];
	}
	
	int getPrice(int nc) {
		return this.price[nc];
	}
	
	double getSalePercentage(int nc) {
		return this.salePercentage[nc];
	}
	
	SongList(int songCount){ // 생성자에서 받은 노래 개수만큼 입력
		
		names = new String[songCount];
		price = new int[songCount];
		salePercentage = new double[songCount];
		/*
		names[0] = "노래제목1";
		names[1] = "노래제목2";
		price[0] = 10000;
		price[0] = 20000;
		salePercentage[0] = 30.5;
		salePercentage[1] = 20.5;
		*/
		
		Scanner scan = new Scanner(System.in);
		for(int nowCount=0;nowCount<songCount;nowCount++){
			System.out.println("제목 : ");
			names[nowCount] = scan.nextLine();
			System.out.println("가격 : ");
			price[nowCount] = scan.nextInt();
			System.out.println("할인율 : ");
			salePercentage[nowCount] = scan.nextDouble();
		}
		scan.close();
		
	}
	
	
	public void initSongList(int songCount){ // 생성자에서 받은 노래 개수만큼 입력
		
		String names[] = new String[songCount];
		int price[] = new int[songCount];
		double salePercentage[] = new double[songCount];
		
		names[0] = "노래제목1";
		names[1] = "노래제목2";
		price[0] = 10000;
		price[0] = 20000;
		salePercentage[0] = 30.5;
		salePercentage[1] = 20.5;
		
	}
	
	
}

class Events{
	private double finalSale = 33;
	public double getFinalSale(){
		return finalSale;
	}
}
