package Racer {
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.*;
	public class GameDataStore extends EventDispatcher{
		// This class is meant to be a STATIC SINGLETON
		private static var _sharedInstance:GameDataStore = new GameDataStore();
		
		// Private instance variables
		private var _xmlLoader:URLLoader;
		private var _xml:XML;
		
		// Public event constants
		public static const LOAD_COMPLETE:String = "onLoadComplete";
		public static const LOAD_ERROR:String = "onLoadError";
		
		public function GameDataStore() {
			trace("Creating " + this);
			if( _sharedInstance ) throw new Error("Cannot create instance of singleton class. Use GameDataStore.sharedInstance");
		}
		
		public static function get sharedInstance():GameDataStore{return _sharedInstance;}
		public function get xml():XML{return _xml;}
		
		public function loadXML(aUrlToDownload:String){
			if (!_xmlLoader){
			trace(this + " loadXML() called with aUrlToDownload=" + aUrlToDownload);
			
			// Create _xmlLoader and request and set callback for when XML is loaded
			_xmlLoader = new URLLoader();
			
			// set up event listeners with weak references
			_xmlLoader.addEventListener(Event.COMPLETE,onXMLLoaded,false,0,true);
			_xmlLoader.addEventListener(IOErrorEvent.IO_ERROR,onXMLLoadError,false,0,true);
			
			// create a request and load the file
			var request:URLRequest = new URLRequest(aUrlToDownload);
			_xmlLoader.load(request);
			}
		}
		
		
		private function onXMLLoaded(e:Event){
			trace(this + " onXMLLoaded() called");
			_xml = new XML(e.target.data);
			//trace(this + "onXMLLoaded() - _xml=" + _xml);
			dispatchEvent(new Event(GameDataStore.LOAD_COMPLETE));
			cleanup();
			
		} // end onXMLLoaded
		
		private function onXMLLoadError(e:Event){
			trace(this + " onXMLLoadError() e=" + e);
			dispatchEvent(new Event(GameDataStore.LOAD_ERROR));
			cleanup();
		}
		
		public function cleanup(){
			// trigger garbage collection of URLLoader object
			_xmlLoader = null;
		}

	} // end class
	
} // end package
