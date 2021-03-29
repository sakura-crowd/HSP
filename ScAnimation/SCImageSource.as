#ifndef __INCLUDE_SCIMAGESOURCE__
#define __INCLUDE_SCIMAGESOURCE__ 1

// �摜�̃R�s�[�����ł��B
//
// bufferId_ : �摜���`�悳�ꂢ�Ă���E�B���h�EID�ł��B
// x_ : �摜��x���̃I�t�Z�b�g�ł��B
// y_ : �摜��y���̃I�t�Z�b�g�ł��B
// width_ : �摜�̉����ł��B
// height_ : �摜�̏c���ł��B
// name_ : �C�ӂ̖��O�ł��B
#module ScImageSource bufferId_, x_, y_, width_, height_, name_
	#modinit int _bufferId, int _x, int _y, int _width, int _height, str _name
		bufferId_ = _bufferId
		x_ = _x
		y_ = _y
		width_ = _width
		height_ = _height
		name_ = _name
		;logmes "modinit ScImageSource : " + serialize(thismod)
	return

	#modterm
		;logmes "modterm ScImageSource : " + serialize(thismod)
	return

	// ���g�̃f�[�^�𕶎���Ƃ��ĕԂ��܂��B
	#modcfunc local serialize
	return "ScImageSource," + bufferId_ + "," + x_ + "," + y_ + "," + width_ + "," + height_ + "," + name_	

	// �������܂��B
	// _dst : �󂯎���
	#modfunc local clone var _dst
		newmod _dst, ScImageSource, bufferId_, x_, y_, width_, height_, name_
	return

	#define MACRO_CLONE(%1, %2) \
		newmod %2, ScImageSource, getBufferId@ScImageSource(%1), getX@ScImageSource(%1), getY@ScImageSource(%1), getWidth@ScImageSource(%1), getHeight@ScImageSource(%1), getName@ScImageSource(%1)

	// --- �A�N�Z�X�֐� ---
	#modcfunc local getBufferId
	return bufferId_

	#modcfunc local getX
	return x_

	#modcfunc local getY
	return y_

	#modcfunc local getWidth
	return width_

	#modcfunc local getHeight
	return height_

	#modcfunc local getName
	return name_

	// --- �`�� ---
	#modfunc local draw
		gcopy bufferId_, x_, y_, width_, height_
	return
	
#global

#if 0
	#module TestScImageSource
	*TestStop
		flgStop = 1
	return 
		#deffunc local Test1
			newmod _is, ScImageSource, 1, 2, 3, 4, 5, "Test1"
			logmes "getBufferId() = " + getBufferId@ScImageSource(_is)
			logmes "getX() = " + getX@ScImageSource(_is)
			logmes "getY() = " + getY@ScImageSource(_is)
			logmes "getWidth() = " + getWidth@ScImageSource(_is)
			logmes "getHeight() = " + getHeight@ScImageSource(_is)
			logmes "getName() = " + getName@ScImageSource(_is)
			delmod _is
		return
	
		#deffunc local Test2
			// --- 3�t���[���̉��摜����� ---
			buffer 1, 640, 480
	
			color 64, 255, 64
			boxf  0,  0, 31, 31
	
			//color 96, 255, 96
			boxf 32,  8, 63, 31
	
			//color 128, 255, 128
			boxf 64, 24, 95, 31
	
			newmod _is, ScImageSource, 1,  0,  0, 32, 32, "f1"
			newmod _is, ScImageSource, 1, 32,  0, 32, 32, "f2"
			newmod _is, ScImageSource, 1, 64,  0, 32, 32, "f3"
	
			gsel 0: color 0, 0, 0: pos 0, 0: mes "�����L�[�������ƏI�����܂��B"
			flgStop = 0: onkey gosub *TestStop
			
			gsel 0
			gmode 2
			pos 128, 64
			while flgStop = 0// inifinite
				color 255, 255, 255: boxf ginfo_cx, ginfo_cy, ginfo_cx + 32, ginfo_cy + 32
				draw@ScImageSource _is(0)
				await 150
	
				color 255, 255, 255: boxf ginfo_cx, ginfo_cy, ginfo_cx + 32, ginfo_cy + 32
				draw@ScImageSource _is(1)
				await 150
	
				color 255, 255, 255: boxf ginfo_cx, ginfo_cy, ginfo_cx + 32, ginfo_cy + 32
				draw@ScImageSource _is(2)
				await 150
	
				color 255, 255, 255: boxf ginfo_cx, ginfo_cy, ginfo_cx + 32, ginfo_cy + 32
				draw@ScImageSource _is(1)
				await 150
			wend
	
			// �S�Ẵ��W���[���^�ϐ���j��
			foreach _is
				delmod _is(cnt)
			loop
	
			cls
		return
	
		#deffunc local Test3
			newmod _is, ScImageSource, 1, 2, 3, 4, 5, "Test3"
			clone@ScImageSource _is, _isCopied
			logmes serialize@ScImageSource(_isCopied)
			delmod _is
			delmod _isCopied
		return
	
		#deffunc local Test4
			newmod _is, ScImageSource, 0, 1, 2, 3, 4, "Test4-1"
			newmod _is, ScImageSource, 5, 6, 7, 8, 9, "Test4-2"
			clone@ScImageSource _is(0), _isCopied0
			clone@ScImageSource _is(1), _isCopied1
			logmes serialize@ScImageSource(_isCopied0)
			logmes serialize@ScImageSource(_isCopied1)
			//repeat:delmod _is(cnt):loop
			//delmod _isCopied0
			//delmod _isCopied1
		return
		
	#global
	
	//Test1@TestScImageSource
	//Test2@TestScImageSource
	//Test3@TestScImageSource
	Test4@TestScImageSource
#endif

#endif // #ifndef __INCLUDE_SCIMAGESOURCE__
