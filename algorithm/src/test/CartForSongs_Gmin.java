package test;

import java.util.*;

class Song_Gmin {
	String name;
	int price;
	int discount;
	int EventPrice;
	Song_Gmin(String name, int price, int discount) {
		this.name = name;
		this.price = price;
		this.discount = discount;
		this.EventPrice = (int)price-price*discount/100;
	}
}

public class CartForSongs_Gmin {
	static int Total = 0;
	void CalcTotal(int ... EventPrices) {
		for(int i=0; i<EventPrices.length; i++) {
			Total += EventPrices[i];
		}
	}
	public static void main(String[] args) {
		CartForSongs_Gmin cart = new CartForSongs_Gmin();
		List<Song_Gmin> songList = new ArrayList<Song_Gmin>();
		//Song(name, price, discount)
		songList.add(new Song_Gmin("벚꽃 엔딩", 1000, 30));
		songList.add(new Song_Gmin("스타킹", 1000, 30));
		songList.add(new Song_Gmin("mama", 1000, 30));
		
		System.out.println("제목\t가격\t할인율\t할인가\t");
		for(int i=0; i < songList.size(); i++) {
			System.out.println(songList.get(i).name+"\t"+songList.get(i).price+"\t"+songList.get(i).discount+"%"+"\t"+songList.get(i).EventPrice);
			cart.CalcTotal(songList.get(i).EventPrice);
		}
		System.out.println("Total : "+Total);
	}
}