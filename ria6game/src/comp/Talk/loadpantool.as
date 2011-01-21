package comp.Talk
{
	import com.heptafish.map.BaseDisplayObject;
	
	import flash.display.Loader;
	import flash.net.URLRequest;
	
	public class loadpantool extends BaseDisplayObject
	{
		public function loadpantool(inname:String)
		{
			super();
			loadpanswf(inname)
		}
		
		public function loadpanswf(filename:String):void{
		var loader:Loader=new Loader()
		this.addChild(loader)
		loader.load(new URLRequest(filename))
		
		}
			
		
		
	}
}