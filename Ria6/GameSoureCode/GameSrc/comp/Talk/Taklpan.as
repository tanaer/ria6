package comp.Talk
{
	import com.heptafish.map.BaseDisplayObject;
	
	import flash.display.Loader;
	import flash.net.URLRequest;
	
	public class Taklpan extends BaseDisplayObject
	{
		public function Taklpan()
		{
			super();
			loadpanswf()
		}
		
		public function loadpanswf():void{
		var loader:Loader=new Loader()
		this.addChild(loader)
		loader.load(new URLRequest("OutPart/Talk.swf"))
		
		}
			
		
		
	}
}