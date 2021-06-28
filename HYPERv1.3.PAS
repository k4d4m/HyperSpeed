{BEGINING}
program hyperspeed;
uses crt;
type	scorer=record
		score:longint;
		name:string[7];end;
var	s,res:boolean;
	px,py,ax,ay,sx,sy,f:shortint;
	speed:integer;
	bonus,score:longint;
	scores:array[1..10] of scorer;
	t:text;
{BEGINING END}


{CLRSCRN}
procedure clrscrn;
var i,j:shortint;
begin
textcolor(7);
textbackground(black);
	for i:=1 to 80 do begin
		for j:=1 to 25 do begin
		gotoxy(i,j);
		write(' ');
		end;
	end;
end;
{CLRSCRN END}


{SHOOT}
procedure shoot;
begin
if s=true then begin
gotoxy(sx,sy);
write('*');
inc(sx);
if sx=79 then s:=false;
end;end;
{SHOOT END}


{POSITION}
procedure position;
begin
textcolor(white);
gotoxy(px,py-1);
write('\');
gotoxy(px,py);
write('= >');
gotoxy(px,py+1);
write('/');
end;
{POSITION END}


{MOVEMENT}
procedure movement;
var step:char;
begin
step:=readkey;
case step of
#72:dec(py);
#80:inc(py);
#75:dec(px);
#77:inc(px);
#27:f:=f+11;
#32:begin
	if s=false then begin
		sx:=px+3;
		sy:=py;
		s:=true;
		shoot;
		end;
	end;
end;

if py=2 then inc(py);
if py=25 then dec(py);
if px=1 then inc(px);
if px=78 then begin
	px:=3;
	bonus:=bonus+25;
	end;
gotoxy(px,py);
position;
end;
{MOVEMENT END}


{ASTEROID}
procedure asteroid;
begin
textcolor(7);
gotoxy(ax,ay);
write('#');
gotoxy(ax,ay+1);
write('#');
gotoxy(ax-1,ay);
write('#');
gotoxy(ax-1,ay+1);
write('#');
end;
{ASTEROID END}


{DESTRUCTION}
procedure destruction;
begin
if sy=ay then if sx=ax-2 then begin s:=false; res:=true;end;
if sy=ay+1 then if sx=ax-2 then begin s:=false; res:=true;end; 
if sy=ay then if sx=ax-1 then begin s:=false; res:=true;end;
if sy=ay+1 then if sx=ax-1 then begin s:=false; res:=true;end;
if sy=ay then if sx=ax then begin s:=false; res:=true;end;
if sy=ay+1 then if sx=ax then begin s:=false; res:=true end;
if res=true then bonus:=bonus+25;
end;
{DESTRUCTION END}


{CRASH}
procedure crash;
begin
if px+2 =ax-2 then if py=ay   then inc(f);
if px+2 =ax-2 then if py=ay+1 then inc(f);
if px+2 =ax-1 then if py=ay   then inc(f);
if px+2 =ax-1 then if py=ay+1 then inc(f);
if px+2 =ax   then if py=ay   then inc(f);
if px+2 =ax   then if py=ay+1 then inc(f);

if px =ax-2   then if py-1=ay+1 then inc(f);
if px =ax-1   then if py-1=ay+1 then inc(f);
if px =ax	then if  py-1=ay+1 then inc(f);

if px =ax-2   then if py+1=ay  then inc(f);
if px =ax-1   then if py+1=ay  then inc(f);
if px =ax	 then if py+1=ay  then inc(f);
end;
{CRASH END}


{STATUSBAR}
procedure statusbar;
begin
textcolor(7);
gotoxy(1,1);
write('speed:',speed,'km/s');
gotoxy(20,1);
textcolor(7);
write('score:',score);
if speed=3000 then
	begin
	gotoxy(40,1);
	textcolor(blue);
	write('H Y P E R  S P E E D !');
	end;
end;
{STATUSBAR END}


{HELP}
procedure help;
begin
clrscr;
textcolor(15);
gotoxy(28,7);writeln('HYPER SPEED 1.3 beta');
gotoxy(30,8);writeln('Made By: Kadam');
gotoxy(24,9);writeln('Email: k4d4m93@gmail.com');
writeln;writeln;
textcolor(7);
writeln('   controls:');
writeln('   full screen -   alt+enter');
writeln('   move up     -   up arrow');
writeln('   move down   -   down arrow');
writeln('   move left   -   left arrow');
writeln('   move right  -   right arrow');
writeln('   pause       -   pause button');
writeln('   shoot       -   space');
writeln('   select      -   enter');
writeln('   exit        -   escape');
gotoxy(1,25);
textcolor(24);
write('press any key to continue');
readkey;
end;
{HELP END}


{RECOVER}
procedure recover;
var	i:shortint;
begin
assign(t,'top10.txt');
reset(t);
for i:=1 to 10 do begin
	readln(t,scores[i].score);
	readln(t,scores[i].name);
	end;
close(t);
end;
{RECOVER END}


{HIGHSCORE}
procedure highscore;
var i:shortint;
begin
clrscr;
recover;
gotoxy(35,3);
textcolor(7);
write('HIGH SCORE');
for i:=1 to 10 do
	begin
	textcolor(white);
	gotoxy(30,3+i*2);
	write('#',i);
	gotoxy(35,3+i*2);
	write(scores[i].name);
	gotoxy(43,3+i*2);
	writeln('-  ',scores[i].score);
	end;
textcolor(24);
gotoxy(1,25);
write('press any key to continue');
readkey;
end;
{HIGHSCORE END}


{SAVESCORE}
procedure savescore;
var	tempscore:scorer;
	i,j:shortint;
begin
	for i:=1 to 9 do
		for j:=1 to 9 do begin
		if scores[j].score<scores[j+1].score then begin
		tempscore:=scores[j];
		scores[j]:=scores[j+1];
		scores[j+1]:=tempscore;
		end;
	end;
assign(t,'top10.txt');
rewrite(t);
	for i:=1 to 10 do begin
	writeln(t,scores[i].score);
	writeln(t,scores[i].name);
	end;
close(t);
highscore;
end;
{SAVESCORE END}


{FAIL}
procedure fail;
var choose:char;
begin
clrscr;
gotoxy(35,10);
textcolor(20);
write('GAME OVER');
gotoxy(8,14);
textcolor(white);
writeln('score: ',score);
gotoxy(8,15);
if score>scores[10].score then
	begin
	scores[10].score:=score;
	write('name: ');
	readln(scores[10].name);
	savescore;
	end;
 if score<=scores[10].score then
 begin
	write('you fail');
		repeat;
		choose:=readkey;
		if choose=#13 then choose:=#27;
		until choose=#27;
	 end;
end;
{FAIL END}


{GAME}
procedure GAME;
begin
px:=3;
py:=12;
speed:=0;
score:=0;
bonus:=0;
f:=0;
s:=false;
res:=false;
	repeat;
	randomize;
	clrscr;
	ax:=80;
	ay:=random(22)+2;
		repeat;
		clrscr;
		statusbar;
		position;
		shoot;
		asteroid;
		dec(ax);
		asteroid;
		if keypressed then movement;
		delay(4500-speed);
		destruction;
		crash;
		if f>0 then res:=true;
		if ax=2 then res:=true;
		until res=true;
	res:=false;
	speed:=speed+60;
	if speed>=2000 then begin speed:=speed-10; bonus:=bonus+10; end;
	if speed>=2500 then begin speed:=speed-20; bonus:=bonus+20;end;
	if speed>=3000 then begin speed:=speed-30; bonus:=bonus+30;end;
	if speed=2990 then speed:=speed+10;
	if speed=3000 then bonus:=bonus+25;
	score:=speed div 2+bonus;
	until f>0;
if f<10 then fail;
end;
{GAME END}


{MENU}
procedure menu;
var	i,x,y:integer;
	opt:shortint;
	choose:char;
begin
repeat;
clrscrn;
opt:=0;
x:=37;
y:=10;
gotoxy(31,5);
textcolor(7);
write('---HYPER SPEED---');
textcolor(8);
gotoxy(1,25);
write('v1.3á');
gotoxy(72,25);
write('By:Kadam');
textcolor(white);
gotoxy(x,y);
	repeat;
	case y of
	10: begin;
	opt:=1;
	gotoxy(x-2,12);
	write('HIGH SCORE');
	gotoxy(x,14);
	write('HELP');
	gotoxy(x,16);
	write('QUIT');
	gotoxy(x,y);
	textcolor(red);
	write('PLAY');
	textcolor(white);
	end;
	12: begin;
	opt:=2;
	gotoxy(x,10);
	write('PLAY');
	gotoxy(x,14);
	write('HELP');
	gotoxy(x,16);
	write('QUIT');
	gotoxy(x-2,y);
	textcolor(red);
	write('HIGH SCORE');
	textcolor(white);
	end;
	14: begin;
	opt:=3;
	gotoxy(x,10);
	write('PLAY');
	gotoxy(x-2,12);
	write('HIGH SCORE');
	gotoxy(x,16);
	write('QUIT');
	gotoxy(x,y);
	textcolor(red);
	write('HELP');
	textcolor(white);
	end;
	16: begin;
	opt:=4;
	gotoxy(x,10);
	write('PLAY');
	gotoxy(x-2,12);
	write('HIGH SCORE');
	gotoxy(x,14);
	write('HELP');
	gotoxy(x,y);
	textcolor(red);
	write('QUIT');
	textcolor(white);
	end;
	end;
	
	choose:=readkey;
	case choose of
		#72:y:=y-2;
		#80:y:=y+2;
		#27:begin
			opt:=4;
			choose:=#13;
			end;
	end;
	
	case y of
		18: y:=10;
		8: y:=16;
	end;
	until choose=(#13);
case opt of 
1: game;
2: highscore;
3: help;
end;
until opt=4;
end;
{MENU END}


{MAIN}
begin
menu;
end.
{MAIN END}