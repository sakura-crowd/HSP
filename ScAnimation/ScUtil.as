#ifndef __INCLUDE_SCUTIL__
#define __INCLUDE_SCUTIL__ 1

// common/hspmath.as �� define �� const �����Ȃ̂Ŋ������Ȃ�

#module ScUtil
	// ���� newmod �Ŋ��蓖�Ă���v�f�ԍ���Ԃ��܂��B
	// _mtv : ���W���[���^�ϐ��܂��͂��̔z��
	#defcfunc local getNewmodNextIndex array _mtv
		//logmes "length(_mtv) = " + length(_mtv)	// ���g�p�̕ϐ���1���Ԃ����

		// ���W���[���^�ϐ��ȊO�̏ꍇ�́A ���� newmod �����1�̃��W���[���^�ϐ��ɂȂ�̂ŗv�f�ԍ� 0 ��Ԃ��B
		if vartype(_mtv) != 5 {
			return 0
		}
		// ���W���[���^�ϐ��̏ꍇ�́A delmod �Ŗ��g�p�ɂȂ��Ă���v�f������΁A���̒��ōł��������v�f�ԍ���Ԃ��B
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
	// getNewmodNextIndex �̃e�X�g
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
			logmes "--- ���������̕ϐ����^����� 0 ���Ԃ� ---"
			_idx = getNewmodNextIndex@ScUtil(_modArray)
			logmes "_idx = " + _idx
	
			logmes "--- 1��������������Ă���ꍇ�� 1 (���ɒǉ������v�f�ԍ�) ��Ԃ��B ---"
			newmod _modArray, Mod, "test6-1"
			_idx = getNewmodNextIndex@ScUtil(_modArray)
			logmes "_idx = " + _idx
	
			logmes "--- 3����������Ă���ꍇ�� 3 (���ɒǉ������v�f�ԍ�) ��Ԃ��B ---"
			newmod _modArray, Mod, "test6-2"
			newmod _modArray, Mod, "test6-3"
			_idx = getNewmodNextIndex@ScUtil(_modArray)
			logmes "_idx = " + _idx
	
			logmes "--- �v�f�ԍ�1,2�̗v�f��delmod ����Ɨv�f�ԍ�1��Ԃ� ---
			delmod _modArray(1)
			_idx = getNewmodNextIndex@ScUtil(_modArray)
			logmes "_idx = " + _idx
	
			logmes "--- �������Ă��邩���ۂ� newmod ���Ē��g���m�F ---
			newmod _modArray, Mod, "test6-4"
			logmes "(" + _idx + ")" + serialize@Mod(_modArray(_idx))
	
			
		return
	#global
	test6
#endif


#endif	// #ifndef __INCLUDE_SCUTIL__
