#ifndef __INCLUDE_SCANIMATION__
#define __INCLUDE_SCANIMATION__ 1

#include "ScUtil.as"
#include "SCImageSource.as"

// �A�j���[�V�����t���[���ł��B
// ���W���[���^�ϐ��z���delmod����ƒP���Ȓǉ��ł͂Ȃ��Ȃ�A���̔z��Ɠ������Ƃ�Â炢�̂ŁA�Z�b�g�ɂ��邽�߂̃��W���[���^�ł��B
// imageSource_ : ScImageSource�^�B�`��p�̉摜���ł��B
// displayTime_ : int�B�\������(�~���b�P��)�ł��B
// name_ : str�B�C�ӂ̖��O�ł��B
#module ScAnimationFrame imageSource_, displayTime_, name_
	#modinit var _imageSource, int _displayTime, str _name
		clone@ScImageSource _imageSource, imageSource_
		displayTime_ = _displayTime
		name_ = _name
		;logmes "modinit ScAnimationFrame," + name_
	return
	#modterm
		// imageSource_ �͎����I�� delmod ����܂��B
		;logmes "modterm ScAnimationFrame," + name_
	return

	// --- �A�N�Z�X�֐� ---
	#modfunc local getImageSource var _dst
		_dst = imageSource_
	return
	#modcfunc local getDisplayTime
	return displayTime_
	#modcfunc local getName
	return name_

	// �`��
	#modfunc local draw
		draw@ScImageSource imageSource_
	return
#global

// �A�j���[�V�������s���܂��B
// update �֐����Ăяo�����ƂōX�V����܂��B
// 
// frames_ : ScAnimationFrame �̃��X�g�B
// imageSources_ : ScImageSource �̃��X�g
// displayTimes_ : imageSources_ �̕\�����ԁB�v�f���͓����ł��B�v�f��0�̏ꍇ��imageSources��delmod�ς݂ŁA�t���[���͖����Ƃ݂Ȃ���܂��B
// lastIndex_ : �Ō���̗v�f�ԍ��ł��B
// time_ : �\�����鎞�Ԏ��̒l�ł��Bupdate �ōX�V����܂��B
// timeEnd_ : �\���b��(ms)�̍��v�l�ł��B����� time_ ���������ꍇ�� 0 �b�֊����߂�܂��B
// curIndex_ : time_ �ɑΉ�����t���[���̗v�f�ԍ��ł��B
// width_, height_ : �S�Ẳ摜���܂܂��O�ڋ�`�ł��BupdateSize �ōX�V����܂��B
// name_ : �C�ӂ̖��O�ł��B
#module ScAnimation frames_, lastIndex_, time_, timeEnd_, curIndex_, width_, height_, name_
	#modinit str _name
		lastIndex_ = -1
		time_ = 0
		timeEnd_ = 0
		curIndex_ = 0
		
		name_ = _name
		;logmes "modinit ScAnimation, " + name_
	return

	#modterm
		// frames_ �͂��̃I�u�W�F�N�g�������ێ�����I�u�W�F�N�g�� delmod �̃^�C�~���O�� delmod �����B
		;logmes "modterm ScAnimation, " + name_
	return

	// �N���[�����쐬�B�l�n���̂����ɍs���B
	// 
	#modfunc local clone array _dst, str _name, local _frame, local _imgSrc, local _time, local i, local _dstIdx, local _dstMod
		_dstIdx = getNewmodNextIndex@ScUtil(_dst)
		newmod _dst, ScAnimation, _name
		for i, 0, length(frames_)
			getFrame@ScAnimation thismod, i, _frame
			getImageSource@ScAnimationFrame _frame, _imgSrc
			_time = getDisplayTime@ScAnimationFrame(_frame)

			addFrame@ScAnimation _dst(_dstIdx), _imgSrc, _time	// length(_dst)=2�ł�Error34�B���� _dst �̌^�� var ���� array �ɕς�����ł����B
		next
	return

	// ���̍X�V
	#modfunc local updateSize local i, local _imageSource, local _tmpWidth, local _tmpHeight
		width_ = 0: height_ = 0
		for i, 0, length(frames_)
			getImageSource@ScAnimationFrame frames_(i), _imageSource

			_tmpWidth = getWidth@ScImageSource(_imageSource)
			_tmpHeight = getHeight@ScImageSource(_imageSource)
			
			if width_ < _tmpWidth {
				width_ = _tmpWidth
			}
			if height_ < _tmpHeight {
				height_ = _tmpHeight
			}
		next
	return

	// �A�N�Z�X�֐�
	#modcfunc local getLastIndex
	return lastIndex_

	#modcfunc local getCurIndex
	return curIndex_

	#modcfunc local getCurTime
	return time_

	#modcfunc local getTimeEnd
	return timeEnd_

	#modfunc local getFrame int _idx, var _dst
		_dst = frames_(_idx)
	return

	#modcfunc local getWidth
	return width_

	#modcfunc local getHeight
	return height_

	// �w�肳�ꂽ���ԂɑΉ������t���[���̗v�f�ԍ���Ԃ��܂��B
	// timeEnd_ �𒴂����l�̏ꍇ�͑Ή�����t���[�����Ȃ����� -1 ��Ԃ��܂��B
	#modcfunc local getFrameIndex int _time, local _timeAdder, local _timeFrame, local _result
		if (_time >= timeEnd_) {
			return -1
		}
		
		_timeAdder = 0
		for i, 0, length(frames_)
			_timeFrame = getDisplayTime@ScAnimationFrame(frames_(i))
			_timeAdder = _timeAdder + _timeFrame
			if _timeAdder >= time_ {
				_result = i
				_break
			}
		next
	return _result
	
	// --- �t���[������֐� ---
	
	// �t���[����1�R�}�ڂ���ݒ肵�܂��B
	// ���݁A�t���[���͍폜�ł��Ȃ��̂ŁA�ύX�������ꍇ�� getFrame ���g���A�t���[�����̃N���[�����g���č�蒼���Ă��������B
	// 
	// TODO : ���W���[���^�ϐ��z��͈ꕔ�� delmod ����Ƃ��̌�� newmod �������߂����邽�ߏ��Ԃ��ێ�����܂���B
	//        �΍�Ƃ��ă��W���[���^�ϐ��z��̗v�f�ԍ���\�����ŕʂ̐����z��ŊǗ�����Ȃǂ��l�����܂��B
	#modfunc local addFrame var _imageSource, int _displayTime
		if _displayTime < 1 {
			logmes "ScAnimation: addFrame : _displayTime �������ł��B" + _displayTime
		}

		// �A�j���[�V�������̍X�V
		timeEnd_ = timeEnd_ + _displayTime
		lastIndex_ = lastIndex_ + 1

		// �t���[���̒ǉ�
		newmod frames_, ScAnimationFrame, _imageSource, _displayTime, "" + lastIndex_

		// �T�C�Y�̍X�V
		updateSize thismod
	return

	#modfunc getFrame var _image


	// --- �X�V�֐� ---
	// �A�j���[�V�����̕\�����Ԃ��X�V���A�Ή������t���[�����������܂��B
	#modfunc local update int _deltaTime
		if timeEnd_ == 0 {	// �A�j���[�V��������t���[�����Ȃ��ꍇ�͉������܂���B
			return
		}
		if lastIndex_ == 0 {	// �A�j���[�V��������t���[�����P�̏ꍇ�͌Œ�Ȃ̂Ŏ��Ԃɂ��t���[���̑I���A���Ԃ̌o�߂����܂���B
			curIndex_ = lastIndex_
			return
		}
		time_ = time_ + _deltaTime
		time_ = time_ \ timeEnd_

		// ���݂̎����ɑΉ�����t���[���̗v�f�ԍ��𓾂�
		curIndex_ = getFrameIndex(thismod, time_)
	return

	// --- �`��֐� ---
	// ���̖��߂��Ăяo���O�ɁAupdate ���߂��Ăяo���Ă��������B
	#modfunc local draw
		if timeEnd_ == 0 {
			return
		}
		draw@ScAnimationFrame frames_(curIndex_)
	return 

#global

#module ScAnimationUtil
	// �A�j���[�V�����I�u�W�F�N�g���쐬���邽�߂̊֐��ł��B
	// @param _dst �A�j���[�V�����I�u�W�F�N�g�̎󂯎���̕ϐ��ł��B
	//             ���łɃ��W���[���^�ϐ������蓖�Ă��Ă�����̂��w�肷��Ɠ���͕ۏႳ��܂���B�擪�̗v�f�ɐݒ肳��邩������܂���B
	//             ������ _dst �� var ���� array �ɂ��ėv�f���w��ł���悤�ɂȂ����̂ő��v�B
	// @param _bufIds �\������摜���z�u����Ă���X�N���[��ID �̔z��ł��B
	// @param _bufIds �\������摜���z�u����Ă��� x ���W(��)�̔z��ł��B
	// @param _bufIds �\������摜���z�u����Ă��� y ���W(��)�̔z��ł��B
	// @param _bufIds �\������摜���z�u����Ă��鉡���̔z��ł��B
	// @param _bufIds �\������摜���z�u����Ă���c���̔z��ł��B
	// @param _bufIds �\������摜���z�u����Ă���\������(ms)�̔z��ł��B
	#deffunc local createAnimation array _dst, str _name, array _bufIds, array _xs, array _ys, array _widths, array _heights, array _times, local _imgSrc, local i, local _dstIdx
		_dstIdx = getNewmodNextIndex@ScUtil(_dst)
		newmod _dst, ScAnimation, _name

		for i, 0, length(_bufIds)
			newmod _imgSrc, ScImageSource, _bufIds(i), _xs(i), _ys(i), _widths(i), _heights(i), "frame" + i
			;logmes "_dstIdx = " + _dstIdx + ", length(_dst) = " + length(_dst)
			addFrame@ScAnimation _dst(_dstIdx), _imgSrc, _times(i)
			delmod _imgSrc
		next
	return
#global

#module TestScAnimation
*TestStop
	flgStop = 1
return 
	#deffunc local test1
		// --- 3�t���[���̉��摜����� ---
		buffer 1, 640, 480

		color 64, 255, 64
		boxf  0,  0, 31, 31

		//color 96, 255, 96
		boxf 32,  8, 63, 31

		//color 128, 255, 128
		boxf 64, 24, 95, 31

		newmod _anim, ScAnimation, "test1"
/*
		newmod _is, ScImageSource, 1,  0,  0, 32, 32, "f1"
		newmod _is, ScImageSource, 1, 32,  0, 32, 32, "f2"
		newmod _is, ScImageSource, 1, 64,  0, 32, 32, "f3"

		addFrameByArrayElem@ScAnimation _anim, _is, 0, 150
		addFrameByArrayElem@ScAnimation _anim, _is, 1, 150
		addFrameByArrayElem@ScAnimation _anim, _is, 2, 150
*/

		newmod _is0, ScImageSource, 1,  0,  0, 32, 32, "f1"
		newmod _is1, ScImageSource, 1, 32,  0, 32, 32, "f2"
		newmod _is2, ScImageSource, 1, 64,  0, 32, 32, "f3"

		addFrame@ScAnimation _anim, _is0, 150
		addFrame@ScAnimation _anim, _is1, 150
		addFrame@ScAnimation _anim, _is2, 150

		// �t���[�����z��ǂ���̗v�f�ԍ��Ɋi�[����Ă��邩�m�F�B
		getFrame@ScAnimation _anim, 0, _pFrame0
		logmes getName@ScAnimationFrame(_pFrame0)
		getFrame@ScAnimation _anim, 1, _pFrame1
		logmes getName@ScAnimationFrame(_pFrame1)
		getFrame@ScAnimation _anim, 2, _pFrame2
		logmes getName@ScAnimationFrame(_pFrame2)


		gsel 0: color 0, 0, 0: pos 0, 0: mes "�����L�[�������ƏI�����܂��B"
		flgStop = 0: onkey gosub *TestStop
		
		gsel 0
		gmode 2
		pos 128, 64
		while flgStop = 0// inifinite
			update@ScAnimation _anim, 25
			color 255, 255, 255: boxf ginfo_cx, ginfo_cy, ginfo_cx + 32, ginfo_cy + 32
			draw@ScAnimation _anim
			//logmes "curTime = " + getCurTime@ScAnimation(_anim)
			//logmes "curIndex = " + getCurIndex@ScAnimation(_anim)
			await 25
		wend

		// �S�Ẵ��W���[���^�ϐ���j��
		foreach _is
			delmod _is(cnt)
		loop
		delmod _anim

		cls
	return
#global

//test1@TestScAnimation

#if 0
#module
	// createAnimation ���߂ŃA�j���[�V���������\������e�X�g�B
	// tamadot.png �� HSP����(hsptv�t�H���_)�̃t���[�f��
	#deffunc test_createAnimation_1
		// ���������s�A�j���[�V�������쐬���ĕ\�����鏈��
		celload "tamadot.png", 1, 2
		celdiv 1, 64, 64
		
		_bufIds =  1,      1,      1,      1
		_xs = 64 * 4, 64 * 5, 64 * 6, 64 * 7
		_ys =      0,      0,      0,      0
		_widths = 64,     64,     64,     64
		_heights =64,     64,     64,     64
		_times =  75,    150,    150,     75
		
		createAnimation@ScAnimationUtil _animPcWalkDown, "animPcWalkDown", _bufIds, _xs, _ys, _widths, _heights, _times
		clone@ScAnimation _animPcWalkDown, _copyAnim, "copyAnim"
		
		gsel 0:cls
		*main
			cls
			
			gmode 2:pos 50, 25
			update@ScAnimation _animPcWalkDown, 25
			draw@ScAnimation _animPcWalkDown
		
			gmode 2:pos 150, 25
			update@ScAnimation _copyAnim, 5
			draw@ScAnimation _copyAnim
		
			await 25
			goto *main
	return
#global
test_createAnimation_1
#endif
#endif // #ifndef __INCLUDE_SCANIMATION__
