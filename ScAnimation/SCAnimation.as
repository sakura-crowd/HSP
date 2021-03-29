#ifndef __INCLUDE_SCANIMATION__
#define __INCLUDE_SCANIMATION__ 1

#include "ScUtil.as"
#include "SCImageSource.as"

// アニメーションフレームです。
// モジュール型変数配列はdelmodすると単純な追加ではなくなり、他の配列と同期がとりづらいので、セットにするためのモジュール型です。
// imageSource_ : ScImageSource型。描画用の画像情報です。
// displayTime_ : int。表示時間(ミリ秒単位)です。
// name_ : str。任意の名前です。
#module ScAnimationFrame imageSource_, displayTime_, name_
	#modinit var _imageSource, int _displayTime, str _name
		clone@ScImageSource _imageSource, imageSource_
		displayTime_ = _displayTime
		name_ = _name
		;logmes "modinit ScAnimationFrame," + name_
	return
	#modterm
		// imageSource_ は自動的に delmod されます。
		;logmes "modterm ScAnimationFrame," + name_
	return

	// --- アクセス関数 ---
	#modfunc local getImageSource var _dst
		_dst = imageSource_
	return
	#modcfunc local getDisplayTime
	return displayTime_
	#modcfunc local getName
	return name_

	// 描画
	#modfunc local draw
		draw@ScImageSource imageSource_
	return
#global

// アニメーションを行います。
// update 関数を呼び出すことで更新されます。
// 
// frames_ : ScAnimationFrame のリスト。
// imageSources_ : ScImageSource のリスト
// displayTimes_ : imageSources_ の表示時間。要素数は同じです。要素が0の場合はimageSourcesはdelmod済みで、フレームは無効とみなされます。
// lastIndex_ : 最後尾の要素番号です。
// time_ : 表示する時間軸の値です。update で更新されます。
// timeEnd_ : 表示秒数(ms)の合計値です。これを time_ が超えた場合は 0 秒へ巻き戻ります。
// curIndex_ : time_ に対応するフレームの要素番号です。
// width_, height_ : 全ての画像が含まれる外接矩形です。updateSize で更新されます。
// name_ : 任意の名前です。
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
		// frames_ はこのオブジェクトかそれを保持するオブジェクトの delmod のタイミングで delmod される。
		;logmes "modterm ScAnimation, " + name_
	return

	// クローンを作成。値渡しのかわりに行う。
	// 
	#modfunc local clone array _dst, str _name, local _frame, local _imgSrc, local _time, local i, local _dstIdx, local _dstMod
		_dstIdx = getNewmodNextIndex@ScUtil(_dst)
		newmod _dst, ScAnimation, _name
		for i, 0, length(frames_)
			getFrame@ScAnimation thismod, i, _frame
			getImageSource@ScAnimationFrame _frame, _imgSrc
			_time = getDisplayTime@ScAnimationFrame(_frame)

			addFrame@ScAnimation _dst(_dstIdx), _imgSrc, _time	// length(_dst)=2でもError34。引数 _dst の型を var から array に変えたらできた。
		next
	return

	// 幅の更新
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

	// アクセス関数
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

	// 指定された時間に対応したフレームの要素番号を返します。
	// timeEnd_ を超えた値の場合は対応するフレームがないため -1 を返します。
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
	
	// --- フレーム制御関数 ---
	
	// フレームを1コマ目から設定します。
	// 現在、フレームは削除できないので、変更したい場合は getFrame を使い、フレーム情報のクローンを使って作り直してください。
	// 
	// TODO : モジュール型変数配列は一部を delmod するとその後の newmod が穴埋めをするため順番が維持されません。
	//        対策としてモジュール型変数配列の要素番号を表示順で別の整数配列で管理するなどが考えられます。
	#modfunc local addFrame var _imageSource, int _displayTime
		if _displayTime < 1 {
			logmes "ScAnimation: addFrame : _displayTime が無効です。" + _displayTime
		}

		// アニメーション情報の更新
		timeEnd_ = timeEnd_ + _displayTime
		lastIndex_ = lastIndex_ + 1

		// フレームの追加
		newmod frames_, ScAnimationFrame, _imageSource, _displayTime, "" + lastIndex_

		// サイズの更新
		updateSize thismod
	return

	#modfunc getFrame var _image


	// --- 更新関数 ---
	// アニメーションの表示時間を更新し、対応したフレームを準備します。
	#modfunc local update int _deltaTime
		if timeEnd_ == 0 {	// アニメーションするフレームがない場合は何もしません。
			return
		}
		if lastIndex_ == 0 {	// アニメーションするフレームが１個の場合は固定なので時間によるフレームの選択、時間の経過をしません。
			curIndex_ = lastIndex_
			return
		}
		time_ = time_ + _deltaTime
		time_ = time_ \ timeEnd_

		// 現在の時刻に対応するフレームの要素番号を得る
		curIndex_ = getFrameIndex(thismod, time_)
	return

	// --- 描画関数 ---
	// この命令を呼び出す前に、update 命令を呼び出してください。
	#modfunc local draw
		if timeEnd_ == 0 {
			return
		}
		draw@ScAnimationFrame frames_(curIndex_)
	return 

#global

#module ScAnimationUtil
	// アニメーションオブジェクトを作成するための関数です。
	// @param _dst アニメーションオブジェクトの受け取り先の変数です。
	//             すでにモジュール型変数が割り当てられているものを指定すると動作は保障されません。先頭の要素に設定されるかもしれません。
	//             →多分 _dst を var から array にして要素を指定できるようになったので大丈夫。
	// @param _bufIds 表示する画像が配置されているスクリーンID の配列です。
	// @param _bufIds 表示する画像が配置されている x 座標(左)の配列です。
	// @param _bufIds 表示する画像が配置されている y 座標(上)の配列です。
	// @param _bufIds 表示する画像が配置されている横幅の配列です。
	// @param _bufIds 表示する画像が配置されている縦幅の配列です。
	// @param _bufIds 表示する画像が配置されている表示時間(ms)の配列です。
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
		// --- 3フレームの仮画像を作る ---
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

		// フレームが想定どおりの要素番号に格納されているか確認。
		getFrame@ScAnimation _anim, 0, _pFrame0
		logmes getName@ScAnimationFrame(_pFrame0)
		getFrame@ScAnimation _anim, 1, _pFrame1
		logmes getName@ScAnimationFrame(_pFrame1)
		getFrame@ScAnimation _anim, 2, _pFrame2
		logmes getName@ScAnimationFrame(_pFrame2)


		gsel 0: color 0, 0, 0: pos 0, 0: mes "何かキーを押すと終了します。"
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

		// 全てのモジュール型変数を破棄
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
	// createAnimation 命令でアニメーションを作り表示するテスト。
	// tamadot.png は HSP同梱(hsptvフォルダ)のフリー素材
	#deffunc test_createAnimation_1
		// 下向き歩行アニメーションを作成して表示する処理
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
