package
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import res.Resources;
	
	[SWF(width="990", height="760", frameRate="30")]
	public class YongKingBirthday extends Sprite
	{
		private var background:Bitmap = new (Resources.Background)();
		private var startButton:Sprite;
		private var gameDes:MovieClip = new (Resources.GameDescription)();
		private var itemList:Array = [];
		private var propertyContainer:Sprite;
		private var curIndexs:Array = [];
		private var numPerRound:int = 22;
		private var curType:int = -1;
		
		private var roundList:Array;
		
		private var endX:int = 0;
		private var endY:int = 0;
		
		private var masker:Shape;
		
		public function YongKingBirthday()
		{
			addChild(background);
			
			startButton = new Sprite();
			var startButtonBitmap:Bitmap = new (Resources.StartButton)();
			startButton.addChild(startButtonBitmap);
			startButton.mouseChildren = false;
			startButton.buttonMode = true;
			startButton.x = (stage.stageWidth - startButton.width) / 2;
			startButton.y = (stage.stageHeight - startButton.height) / 2;
			showStartGameButton();
			
			initItems();
		}
		
		private function drawMasker():void
		{
			masker = new Shape();
			masker.graphics.beginFill(0x000000, 0.3);
			masker.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			masker.graphics.endFill();
			addChild(masker);
		}
		
		private function initPropertyContainer():void
		{
			propertyContainer = new Sprite();
			propertyContainer.graphics.beginFill(0xFF0000, 0);
			propertyContainer.graphics.drawRect(0, 0, 462, 363);
			propertyContainer.graphics.endFill();
			addChild(propertyContainer);
			propertyContainer.x = 270;
			propertyContainer.y = 233;
		}
		
		private function initItems():void
		{
			var dollar:Item = new Item(new (Resources.Dollar)(), ItemTypes.MONEY);
			var rmb:Item = new Item(new (Resources.RMB)(), ItemTypes.MONEY);
			var tongQian:Item = new Item(new (Resources.TongQian)(), ItemTypes.MONEY);
			var yuanBao:Item = new Item(new (Resources.YuanBao)(), ItemTypes.MONEY);
			var moneyTree:Item = new Item(new (Resources.MoneyTree)(), ItemTypes.MONEY | ItemTypes.PLANT);
			
			var trousers:Item = new Item(new (Resources.Trousers)(), ItemTypes.LIVING_GOODS);
			var hat:Item = new Item(new (Resources.Hat)(), ItemTypes.LIVING_GOODS);
			var comb:Item = new Item(new (Resources.Comb)(), ItemTypes.LIVING_GOODS);
			var shoe:Item = new Item(new (Resources.Shoe)(), ItemTypes.LIVING_GOODS);
			var clothes:Item = new Item(new (Resources.Clothes)(), ItemTypes.LIVING_GOODS);
			
			var renshen:Item = new Item(new (Resources.RenShen)(), ItemTypes.FOOD);
			var cake:Item = new Item(new (Resources.Cake)(), ItemTypes.FOOD);
			var noodle:Item = new Item(new (Resources.Noodle)(), ItemTypes.FOOD);
			var taozi:Item = new Item(new (Resources.TaoZi)(), ItemTypes.FOOD);
			var fish:Item = new Item(new (Resources.Fish)(), ItemTypes.FOOD);
			
			var bixuejian:Item = new Item(new (Resources.BiXueJian)(), ItemTypes.BOOK, true);
			var juedaishuangjiao:Item = new Item(new (Resources.JueDaiShuangJiao)(), ItemTypes.BOOK, false);
			var ludingji:Item = new Item(new (Resources.LuDingJi)(), ItemTypes.BOOK, true);
			var shendiaoxialv:Item = new Item(new (Resources.ShenDiaoXiaLv)(), ItemTypes.BOOK, true);
			var tianlongbabu:Item = new Item(new (Resources.TianLongBaBu)(), ItemTypes.BOOK, true);
			var xiaoshiyilang:Item = new Item(new (Resources.XiaoShiYiLang)(), ItemTypes.BOOK, false);
			var xiaolifeidao:Item = new Item(new (Resources.XiaoLiFeiDao)(), ItemTypes.BOOK, false);
			var xiaoaojianghu:Item = new Item(new (Resources.XiaoAoJiangHu)(), ItemTypes.BOOK, true);
			
			var dogStick:Item = new Item(new (Resources.DogStick)(), ItemTypes.WEAPON);
			var feiBiao:Item = new Item(new (Resources.FeiBiao)(), ItemTypes.WEAPON);
			var shuangDao:Item = new Item(new (Resources.ShuangDao)(), ItemTypes.WEAPON);
			var tulongdao:Item = new Item(new (Resources.TuLongDao)(), ItemTypes.WEAPON);
			var yitianjian:Item = new Item(new (Resources.YiTianJian)(), ItemTypes.WEAPON);
			
			var fengye:Item = new Item(new (Resources.FengYe)(), ItemTypes.PLANT);
			var hulu:Item = new Item(new (Resources.HuLu)(), ItemTypes.PLANT);
			var mudan:Item = new Item(new (Resources.MuDan)(), ItemTypes.PLANT);
			var xiaohua:Item = new Item(new (Resources.XiaoHua)(), ItemTypes.PLANT);
			
			var tempList:Array = [];
			tempList.push(dollar, rmb, tongQian, yuanBao, moneyTree, trousers, hat, comb, shoe, clothes,
				renshen, cake, noodle, taozi, fish, bixuejian, juedaishuangjiao, ludingji, shendiaoxialv,
				tianlongbabu, xiaoshiyilang, xiaolifeidao, xiaoaojianghu, dogStick, feiBiao, shuangDao,
				tulongdao, yitianjian, fengye, hulu, mudan, xiaohua);
			while(tempList.length){
				var index:int = Math.random() * tempList.length;
				itemList.push(tempList[index]);
				tempList.splice(index, 1);
			}
			setRoundList();
		}
		
		private function setRoundList():void
		{
			roundList = itemList.reverse().concat([]);
		}
		
		private function showStartGameButton():void
		{
			startButton.visible = true;
			startButton.addEventListener(MouseEvent.CLICK, showGameDescription);
			addChild(startButton);
		}
		
		protected function showGameDescription(event:MouseEvent):void
		{
			startButton.removeEventListener(MouseEvent.CLICK, showGameDescription);
			startButton.visible = false;
			gameDes.x = stage.stageWidth / 2;
			gameDes.y = stage.stageHeight / 2;
			addChild(gameDes);
			gameDes.gotoAndPlay(1);
			addEventListener(Event.ENTER_FRAME, onEnter);
		}
		
		private function onEnter(event:Event) : void
		{
			if(gameDes.currentFrame == 62){
				if(!gameDes.startBtn.buttonMode){
					gameDes.startBtn.visible = true;
					gameDes.stop();
					gameDes.startBtn.buttonMode = true;
					gameDes.startBtn.addEventListener(MouseEvent.CLICK, startGame);
				}
			}else if(gameDes.currentFrame == gameDes.totalFrames){
				gameDes.stop();
				removeEventListener(Event.ENTER_FRAME, onEnter);
			}
		}
		
		private function startGame(event:MouseEvent) : void
		{
			initPropertyContainer();
			gameDes.startBtn.visible = false;
			gameDes.startBtn.buttonMode = false;
			gameDes.startBtn.removeEventListener(MouseEvent.CLICK, startGame);
			gameDes.gotoAndPlay(63);
			showPropeties();
		}
		
		private function showPropeties():void
		{
			for(var i:int = 0; i < 5; i++){
				var index:int = Math.random() * (roundList.length - 1);
				var item:Item = roundList[index];
				roundList.splice(index, 1);
				item.x = endX;
				item.y = endY;
				if(endX > 0 || endY > 0){
					var preItem:Item = propertyContainer.getChildAt(propertyContainer.numChildren - 1) as Item;
					if(endY + item.height > propertyContainer.height){
						endX = preItem.x + preItem.width;
						endY = preItem.y;
					}else{
						endX = preItem.x;
						endY = preItem.y + preItem.height;
					}
				}else{
					endX = item.width;
					endY = item.height;
				}
				propertyContainer.addChild(item);
			}
		}
		
		private function getRightGoodsRandomNum() : int
		{
			return Math.random() * 3;
		}
		
		private function getTimeByNumber(num:int) : Bitmap
		{
			return null;
		}
	}
}