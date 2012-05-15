
/*
   -----------------------------------------------------
   カレンダーで日付の入力補助をする
   Ver. 1.0.1
   update 2009.5.2
   Copyright (C) WEB-JOZU  URL:http://www.web-jozu.com/
   -----------------------------------------------------
*/



/* ---------- 設定領域 start ---------- */

//フォームのname属性を設定
formNm = "form";

//フォームの年のname属性を設定
yearNm = "yy";

//フォームの月のname属性を設定
monthNm = "mm";

//フォームの日のname属性を設定
dateNm = "dd";


//現在の月から何ヶ月前まで表示
bfMonNm = 6;

//現在の月から何ヶ月後まで表示
afMonNm = 6;

/* ---------- 設定領域 end ---------- */



function holidaySet(MM,DD,WEEK,DAY,TTL){
	holiMM[i] = MM; holiDD[i] = DD; holiWEEK[i] = WEEK; holiDAY[i] = DAY; holiTTL[i++] = TTL;
}

function showCalen(MM){
	calenData = createCalen(MM);
	if(document.getElementById) {
		document.getElementById('calenArea').innerHTML = calenData;
	}
}

function hideCalen(){
	if(document.getElementById) {
		document.getElementById('calenArea').innerHTML = '';
		view = "off";
	}
}

function chgForm(YY,MM,DD){
	this['document'][formNm][yearNm].value = YY;
	this['document'][formNm][monthNm].value = MM + 1;
	this['document'][formNm][dateNm].value = DD;

	document.getElementById('calenArea').innerHTML = '';
	view = "off";
}


view = "off";

function viewCalen(MM){
	if(view == "off"){
		dateReset();

		if(this['document'][formNm][yearNm].value != "" && this['document'][formNm][monthNm].value != ""){
			theYear = this['document'][formNm][yearNm].value;
			theMonth = this['document'][formNm][monthNm].value - 1;
		}

		showCalen(theMonth);
		view = "on";
	}else{
		document.getElementById('calenArea').innerHTML = '';
		view = "off";
	}
}

function dateReset(){
	//現在の日付を取得
	nowDate = new Date();
	theYear = nowDate.getFullYear();
	theMonth = nowDate.getMonth();
	theDate = nowDate.getDate();
	theDay = nowDate.getDay();

	//現在の日付を保持
	nowMonth = theMonth;
	nowYear = theYear;
}

dateReset();


//カレンダー表示 最後まで
function createCalen(MM){

	i = 0;
	holiMM = new Array;
	holiDD = new Array;
	holiWEEK = new Array;
	holiDAY = new Array;
	holiTTL = new Array;
	

	theMonth = MM;
	
	if(theMonth >= 12){
		theYear++;
		theMonth = 0;
	} else if(theMonth <= -1){
		theYear--;
		theMonth = 11;
	}
	
	
	//月の日数取得
	monNum = new Date(theYear, theMonth + 1, 0).getDate();
	
	//1日の曜日を取得
	firstDay = new Date(theYear, theMonth, 1).getDay();
	
	//月の週を取得
	theWeek = Math.ceil((monNum + firstDay) / 7);
	
	
	//祝日を設定
	holidaySet(1,1,0,0,'元旦');
	holidaySet(1,0,2,1,'成人の日');
	holidaySet(2,11,0,0,'建国記念の日');
	
	if(theYear%4 == 0 || theYear%4 == 1){
		holidaySet(3,20,0,0,'春分の日');
	}else{
		holidaySet(3,21,0,0,'春分の日');
	}
	
	holidaySet(4,29,0,0,'昭和の日');
	holidaySet(5,3,0,0,'憲法記念日');
	holidaySet(5,4,0,0,'みどりの日');
	holidaySet(5,5,0,0,'こどもの日');
	holidaySet(7,0,3,1,'海の日');
	holidaySet(9,0,3,1,'敬老の日');
	
	if(theYear >= 2012 && theYear <= 2044 && theYear%4 == 0){
		holidaySet(9,22,0,0,'秋分の日');
	}else{
		holidaySet(9,23,0,0,'秋分の日');
	}
	
	holidaySet(10,0,2,1,'体育の日');
	holidaySet(11,3,0,0,'文化の日');
	holidaySet(11,23,0,0,'勤労感謝の日');
	holidaySet(12,23,0,0,'天皇誕生日');
	
	//祝日の数を取得
	holiNum = i;
	

	diffY = (theYear - nowYear) * 12;
	diffM = theMonth - nowMonth;

	//月前後ボタンの表示非表示
	if(afMonNm > diffY + diffM){
		rtBtn = '<a href="javascript:showCalen(theMonth + 1); void(0);">＞</a>';
	}else{
		rtBtn = '&nbsp;';
	}

	if(bfMonNm > - diffY - diffM){
		ltBtn = '<a href="javascript:showCalen(theMonth - 1); void(0);">＜</a>';
	}else{
		ltBtn = '&nbsp;';
	}

	
	//カレンダー表示
	calenData = '';
	calenData += '<span class="calenPopup">';
	calenData += '<table class="calTable">';
	calenData += '<tr>';
	calenData += '<td class="btn">' + ltBtn + '</td>';
	calenData += '<td colspan="5" class="mon"><span class="yView">' + theYear + '年</span>&nbsp;' + (theMonth + 1) + '月&nbsp;</td>';
	calenData += '<td class="btn">' + rtBtn + '</td>';
	calenData += '</tr>';
	calenData += '<tr>';
	calenData += '<th>日</th>';
	calenData += '<th>月</th>';
	calenData += '<th>火</th>';
	calenData += '<th>水</th>';
	calenData += '<th>木</th>';
	calenData += '<th>金</th>';
	calenData += '<th>土</th>';
	calenData += '</tr>';
	
	
	//重なり順用
	zNum = 32;
	
	dateNum = 0;
	subHoli = "off"
	nationHoli = "off";
	weekSun = 0;
	weekMon = 0;
	weekTue = 0;
	weekWed = 0;
	weekThu = 0;
	weekFri = 0;
	weekSat = 0;
	weekNum = new Array;
	for(i=0; i<=6; i++){
		weekNum[i] = 0;
	}
	
	for(i=0; i<6; i++){
	
		calenData += '<tr>';
	
		for(j=0; j<7; j++){
	
			calenData += '<td';
	
			if(i == 0 && j == firstDay){
				dateNum++;
			}
	
			holiMMDDCk = "off";
			for(k=0; k<holiNum; k++){
	
				holiMMCk = "off";
				holiDDCk = "off";
				if((theMonth + 1) == holiMM[k]){
					holiMMCk = "on";
				}
	
				if(holiMMCk == "on" && dateNum != 0 && holiDD[k] == 0 && holiWEEK[k] - 1 == weekNum[holiDAY[k]] && holiDAY[k] == j){
					holiDDCk = "on";
	
					if(dateNum != 0 && holiDD[k + 1] == 0 && holiWEEK[k + 1] - 1 == weekNum[holiDAY[k + 1]] && holiDAY[k + 1] == j + 2){
						nationHoli = "on";
					}else if(dateNum != 0 && holiDD[k + 1] == dateNum + 2 && holiWEEK[k + 1] == 0 && holiDAY[k + 1] == 0){
						nationHoli = "on";
					}
	
				}else if(holiMMCk == "on" && dateNum != 0 && holiDD[k] == dateNum && holiWEEK[k] == 0 && holiDAY[k] == 0){
					holiDDCk = "on";
	
					if(dateNum != 0 && holiDD[k + 1] == 0 && holiWEEK[k + 1] - 1 == weekNum[holiDAY[k + 1]] && holiDAY[k + 1] == j + 2){
						nationHoli = "on";
					}else if(dateNum != 0 && holiDD[k + 1] == dateNum + 2 && holiWEEK[k + 1] == 0 && holiDAY[k + 1] == 0){
						nationHoli = "on";
					}
	
				}
	
				if(holiMMCk == "on" && holiDDCk == "on"){
					holiMMDDCk = "on";
					viewTtl = holiTTL[k];
				}
	
			}
	
			if(holiMMDDCk == "on"){
				if(dateNum == theDate && theMonth == nowDate.getMonth() && theYear == nowDate.getFullYear()){
					calenData += ' class="sun today" title="' + viewTtl + '"';
				}else{
					calenData += ' class="sun" title="' + viewTtl + '"';
				}
	
				if(j == 0){
					subHoli = "on";
				}
	
			}else if(nationHoli == "on"){
				if(dateNum == theDate && theMonth == nowDate.getMonth() && theYear == nowDate.getFullYear()){
					calenData += ' class="sun today" title="国民の休日"';
				}else{
					calenData += ' class="sun" title="国民の休日"';
				}
	
				nationHoli = "off";
		
			}else if(subHoli == "on"){
				if(dateNum == theDate && theMonth == nowDate.getMonth() && theYear == nowDate.getFullYear()){
					calenData += ' class="sun today" title="振替休日"';
				}else{
					calenData += ' class="sun" title="振替休日"';
				}
	
				subHoli = "off";
		
			}else if(j == 0){
				if(dateNum == theDate && theMonth == nowDate.getMonth() && theYear == nowDate.getFullYear()){
					calenData += ' class="sun today"';
				}else{
					calenData += ' class="sun"';
				}
		
			}else if(j == 6){
				if(dateNum == theDate && theMonth == nowDate.getMonth() && theYear == nowDate.getFullYear()){
					calenData += ' class="sat today"';
				}else{
					calenData += ' class="sat"';
				}
	
			}else if(dateNum == theDate && theMonth == nowDate.getMonth() && theYear == nowDate.getFullYear()){
				calenData += ' class="today"';
			}
	
			calenData += '>';
	
	
			if((i == 0 && j < firstDay) || dateNum > monNum){
				calenData += '&nbsp;';
	
			}else{
				calenData += '<a href="javascript:chgForm(' + theYear + ',' + theMonth + ',' + dateNum + '); void(0);" class="linkArea">' + dateNum + '</a>';
				dateNum++;
	
				switch(j){
					case 0: weekNum[0] = ++weekSun; break;
					case 1: weekNum[1] = ++weekMon; break;
					case 2: weekNum[2] = ++weekTue; break;
					case 3: weekNum[3] = ++weekWed; break;
					case 4: weekNum[4] = ++weekThu; break;
					case 5: weekNum[5] = ++weekFri; break;
					case 6: weekNum[6] = ++weekSat; break;
				}
			}
	
			calenData += '</td>';
		}
	
		calenData += '</tr>';
	}
	
	calenData += '<tr>';
	calenData += '<td colspan="3" class="close"><a href="javascript:hideCalen(); void(0);">×&nbsp;閉じる</a></td>';
	calenData += '</table>';
	calenData += '</span>';

	return calenData;
}
//最初から
