package com.soueidan.games.tawla.utils
{
	public class ArrayUtil
	{
		static public function isEmpty(array:Array):Boolean {
			return ( array.length == 0 );
		}
		
		static public function toString(array:Array):String {
			var str:String = "";
			for each(var item:String in array ) {
				str += item + ", ";
			}
			return str;
		}
		
		static public function merge(arr1:Array, arr2:Array):Array {
			for each(var item:* in arr2 ) {
				arr1.push(item);
			}
			return arr1;
		}
		
		static public function remove(array:Array, removeItem:*):Array {
			var newArray:Array = [];
			for each(var item:* in array ) {
				if ( item != removeItem ) {
					newArray.push(item);
				}
			}
			
			return newArray;
		}
		
		static public function contains(array:Array, findItem:*, integer:Boolean=false):Boolean {
			for each(var item:* in array ) {
				if ( integer ) {
					if ( Number(item) == Number(findItem) ) return true;
				} else {
					if ( item == findItem) return true;
				}
			}
			return false;
		}
		
		static public function increment(array:Array):Number {
			var num:int = 0;
			for each(var item:Number in array){
				num += item;
			}
			return num;
		}
		
		static public function exclude(array:Array, index:Number):Array {
			var newArray:Array = [];
			for(var i:int = 0;i<array.length;i++){
				if ( i != index ) {
					newArray.push(array[i]);
				}
			}
			
			return newArray;
		}
	}
}