#ifndef __INCLUDE_SCUTIL__
#define __INCLUDE_SCUTIL__ 1

// common/hspmath.as は define と const だけなので環境制限なし

#module ScUtil
	// 次の newmod で割り当てられる要素番号を返します。
	// _mtv : モジュール型変数またはその配列
	#defcfunc local getNewmodNextIndex array _mtv
		//logmes "length(_mtv) = " + length(_mtv)	// 未使用の変数は1が返される

		// モジュール型変数以外の場合は、 次に newmod すると1個のモジュール型変数になるので要素番号 0 を返す。
		if vartype(_mtv) != 5 {
			return 0
		}
		// モジュール型変数の場合は、 delmod で未使用になっている要素があれば、その中で最も小さい要素番号を返す。
		for i, 0, length(_mtv)
			_retVaruse = varuse(_mtv(i))
			if _retVaruse = 0 {
				_break
			}
		next
		
		return i
	return

#global

#if 0
	// getNewmodNextIndex のテスト
	#module Mod name_
		#modinit str _name
			name_ = _name
			logmes "modinit " + serialize(thismod)
		return
	
		#modterm
			logmes "modterm " + serialize(thismod)
		return
	
		#modcfunc local getName
		return name_
	
		#modcfunc local serialize
		return "Mod," + name_
	#global
	
	#module
		#deffunc test6
			logmes "--- 未初期化の変数が与えると 0 が返る ---"
			_idx = getNewmodNextIndex@ScUtil(_modArray)
			logmes "_idx = " + _idx
	
			logmes "--- 1個だけ初期化されている場合は 1 (次に追加される要素番号) を返す。 ---"
			newmod _modArray, Mod, "test6-1"
			_idx = getNewmodNextIndex@ScUtil(_modArray)
			logmes "_idx = " + _idx
	
			logmes "--- 3個初期化されている場合は 3 (次に追加される要素番号) を返す。 ---"
			newmod _modArray, Mod, "test6-2"
			newmod _modArray, Mod, "test6-3"
			_idx = getNewmodNextIndex@ScUtil(_modArray)
			logmes "_idx = " + _idx
	
			logmes "--- 要素番号1,2の要素をdelmod すると要素番号1を返す ---
			delmod _modArray(1)
			_idx = getNewmodNextIndex@ScUtil(_modArray)
			logmes "_idx = " + _idx
	
			logmes "--- 正解しているか実際に newmod して中身を確認 ---
			newmod _modArray, Mod, "test6-4"
			logmes "(" + _idx + ")" + serialize@Mod(_modArray(_idx))
	
			
		return
	#global
	test6
#endif


#endif	// #ifndef __INCLUDE_SCUTIL__
