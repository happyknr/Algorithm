/* 문제1)
 * 두 수를 입력받아 두 수의 최대공약수와 최소공배수를 반환해주는 gcdlcm 함수를 완성해 보세요. 
 * 배열의 맨 앞에 최대공약수, 그 다음 최소공배수를 넣어 반환하면 됩니다. 
 * 예를 들어 gcdlcm(3,12) 가 입력되면, [3, 12]를 반환해주면 됩니다.
 * */
package test;

import java.util.Arrays;

public class TryHelloWorld {
	public int[] gcdlcm(int a, int b) {
        int[] answer = new int[2];
        int small = a, big = b ;
        System.out.println(a + " " + b);
        
        if(a > b)
        {
        	big = a;
        	small = b;
        }
        
        if(big%small == 0)
        {
        	answer[0] = small;
        	answer[1] = small * big/small;
        }
        else
        {
        	answer[0] = big%small;
        	answer[1] = answer[0] * small/answer[0] * big/answer[0];
        }
        	
        return answer;
    }

    // 아래는 테스트로 출력해 보기 위한 코드입니다.
    /*public static void main(String[] args) {
        TryHelloWorld c = new TryHelloWorld();
        System.out.println(Arrays.toString(c.gcdlcm(79, 61)));
    }*/
	
	
    //-------------------------------------------------------------------------------------------------------------------
	/* 문제2)
	 * 자연수로 이루어진 길이가 같은 수열 A,B가 있습니다. 최솟값 만들기는 A, B에서 각각 한 개의 숫자를 뽑아 두 수를 곱한 값을 누적하여 더합니다. 
	 * 이러한 과정을 수열의 길이만큼 반복하여 최종적으로 누적된 값이 최소가 되도록 만드는 것이 목표입니다.
	 * 예를 들어 A = [1, 2] , B = [3, 4] 라면
	 * 1. A에서 1, B에서 4를 뽑아 곱하여 더합니다.
	 * 2. A에서 2, B에서 3을 뽑아 곱하여 더합니다.
	 * 수열의 길이만큼 반복하여 최솟값 10을 얻을 수 있으며, 이 10이 최솟값이 됩니다.
	 * 수열 A,B가 주어질 때, 최솟값을 반환해주는 getMinSum 함수를 완성하세요.
	 * */
    public int getMinSum(int []A, int []B)
    {
        int answer = 0;

        return answer;
    }
    public static void main(String[] args)
    {
        TryHelloWorld test = new TryHelloWorld();
        int []A = {1,2};
        int []B = {3,4};
        System.out.println(test.getMinSum(A,B));
    }
}
