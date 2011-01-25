// ActionScript file
private var isHit:Boolean;
private function onHit(evnet:Event):void
{
	if(_player.hitTestObject(_player4))
	{
		if(intNo==12 )
		{
//			_player.stopCharacter();//停人物
			labelTest.visible=true;
			intNo++;
			isHit=true;
		}
	}
	else
	{
			offHit();
			isHit=false;
	}
}
private function offHit():void
{
	if(isHit)
	{
		labelTest.visible=false;
	}
}
