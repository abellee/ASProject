package
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Elastic;
	import com.greensock.plugins.TransformAroundCenterPlugin;
	import com.greensock.plugins.TweenPlugin;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
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
		
		private var topicList:Array = [];
		private var curTopicIndex:int = -1;
		private var curTopic:Item = null;
		
		private var singleList:Array = new Array(6);
		
		private var counter:MovieClip = new (Resources.Counter)();
		
		private var leftSpacePerCol:Array = [];
		
		private var timer:Timer = new Timer(1000);
		
		public function YongKingBirthday()
		{
			TweenPlugin.activate([TransformAroundCenterPlugin]);
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
			
			initTopics();
			
			counter.stop();
			addChild(counter);
			counter.x = 230;
			counter.y = 713;
		}
		
		private function initTopics():void
		{
			var money:Item = new Item(new (Resources.Money)(), ItemTypes.MONEY);
			var livingGoods:Item = new Item(new (Resources.LivingGoods)(), ItemTypes.LIVING_GOODS);
			var food:Item = new Item(new (Resources.Food)(), ItemTypes.FOOD);
			var book:Item = new Item(new (Resources.Book)(), ItemTypes.BOOK);
			var weapon:Item = new Item(new (Resources.Weapon)(), ItemTypes.WEAPON);
			var plant:Item = new Item(new (Resources.Plant)(), ItemTypes.PLANT);
			
			topicList.push(money, livingGoods, food, book, weapon, plant);
		}
		
		private function drawMasker():void
		{
			if(!masker){
				masker = new Shape();
				masker.graphics.beginFill(0x000000, 0.3);
				masker.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
				masker.graphics.endFill();
			}
			addChild(masker);
		}
		
		private function initPropertyContainer():void
		{
			propertyContainer = new Sprite();
			propertyContainer.graphics.beginFill(0xFF0000, 0);
			propertyContainer.graphics.drawRect(0, 0, 446, 380);
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
				renshen, cake, noodle, taozi, fish, dogStick, feiBiao, shuangDao,
				tulongdao, yitianjian, fengye, hulu, mudan, xiaohua);
			
			var bookList:Array = [];
			bookList.push(bixuejian, juedaishuangjiao, ludingji, shendiaoxialv,
				tianlongbabu, xiaoshiyilang, xiaolifeidao, xiaoaojianghu);
			var moneyList:Array = [];
			moneyList.push(dollar, rmb, tongQian, yuanBao, moneyTree);
			var livingGoodsList:Array = [];
			livingGoodsList.push(trousers, hat, comb, shoe, clothes);
			var foodList:Array = [];
			foodList.push(renshen, cake, noodle, taozi, fish);
			var weaponList:Array = [];
			weaponList.push(dogStick, feiBiao, shuangDao,
				tulongdao, yitianjian);
			var plantList:Array = [];
			plantList.push(fengye, hulu, mudan, xiaohua, moneyTree);
			singleList[ItemTypes.BOOK] = bookList;
			singleList[ItemTypes.FOOD] = foodList;
			singleList[ItemTypes.LIVING_GOODS] = livingGoodsList;
			singleList[ItemTypes.MONEY] = moneyList;
			singleList[ItemTypes.PLANT] = plantList;
			singleList[ItemTypes.WEAPON] = weaponList;
			
			while(tempList.length){
				var index:int = Math.round(Math.random() * (tempList.length - 1));
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
			drawMasker();
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
				
				TweenLite.to(masker, 0.2, {alpha:0});
				
				showTopic();
			}
		}
		
		private function startChooseProperty():void
		{
			initPropertyContainer();
			showPropeties();
		}
		
		private function showTopic():void
		{
			var index:int = Math.round(Math.random() * topicList.length);
			if(curTopic){
				removeChild(curTopic);
			}
			//TODO:修改
			//index = 3;
			//
			curTopic = topicList[index];
			if(curTopic.itemType == ItemTypes.BOOK){
				showBooks();
			}else{
				startChooseProperty();
			}
			topicList.reverse();
			addChild(curTopic);
			curTopic.x = 400;
			curTopic.y = 655;
		}
		
		private function showBooks():void
		{
			initPropertyContainer();
			while(propertyContainer.numChildren){
				propertyContainer.removeChildAt(0);
			}
			for each(var item:Item in singleList[ItemTypes.BOOK]){
				item.x = (propertyContainer.numChildren % 4) * 128 - 20;
				item.y = int(propertyContainer.numChildren / 4) * 136 + 70;
				propertyContainer.addChild(item);
				addItemEvent(item);
			}
			singleList[ItemTypes.BOOK].reverse();
		}
		
		private function startGame(event:MouseEvent) : void
		{
			gameDes.startBtn.visible = false;
			gameDes.startBtn.buttonMode = false;
			gameDes.startBtn.removeEventListener(MouseEvent.CLICK, startGame);
			gameDes.gotoAndPlay(63);
		}
		
		private function showPropeties():void
		{
			while(propertyContainer.numChildren){
				propertyContainer.removeChildAt(0);
			}
			var randomI:int = Math.round(Math.random() * (numPerRound - 1));
			for(var i:int = 0; i < numPerRound; i++){
				var index:int = Math.round(Math.random() * (roundList.length - 1));
				var item:Item = roundList[index];
				roundList.splice(index, 1);
				if(i == randomI){
					var arr:Array = singleList[curTopic.itemType];
					var randomIndex:int = Math.round(Math.random() * (arr.length - 1));
					item = arr[randomIndex];
				}
				if(endX > 0 || endY > 0){
					var preItem:Item = propertyContainer.getChildAt(propertyContainer.numChildren - 1) as Item;
					if(endY + item.height > propertyContainer.height){
						var p:Point = new Point();
						p.x = preItem.x;
						p.y = preItem.y + preItem.height;
						leftSpacePerCol.push(p);
						if(endX >= propertyContainer.width - 100){
							item.y = 50;
						}else{
							item.y = 0;
						}
						item.x = endX;
						endY = item.y + item.height;
						endX = item.x + item.width + 5;
					}else{
						var tempP:Point = getSpaceByHeight(item.height);
						if(tempP){
							item.x = tempP.x;
							item.y = tempP.y + 5;
							addItemEvent(item);
							propertyContainer.addChildAt(item, 0);
							tempP.y += item.height + 5;
							continue;
						}else{
							item.y = endY + 5;
							item.x = preItem.x;
							endY = item.y + item.height;
							if(item.x + item.width > endX){
								endX = preItem.x + item.width + 5;
							}
						}
					}
				}else{
					item.x = 0;
					item.y = 50;
					endX = item.width + 5;
					endY = item.height + item.y;
				}
				addItemEvent(item);
				propertyContainer.addChild(item);
			}
			setRoundList();
		}
		
		private function addItemEvent(item:Item):void
		{
			if(!item.hasEventListener(MouseEvent.MOUSE_OVER)){
				item.buttonMode = true;
				item.mouseChildren = false;
				item.addEventListener(MouseEvent.MOUSE_OVER, item_mouseOverHandler);
				item.addEventListener(MouseEvent.MOUSE_OUT, item_mouseOutHandler);
				item.addEventListener(MouseEvent.CLICK, item_clickHandler);
			}
		}
		
		private function getSpaceByHeight(h:Number):Point
		{
			for each(var p:Point in leftSpacePerCol)
			{
				if(p.y + h + 5 <= propertyContainer.height){
					return p;
				}
			}
			return null;
		}
		
		protected function item_mouseOutHandler(event:MouseEvent):void
		{
			var item:Item = event.target as Item;
			TweenLite.to(item, 0.3, {transformAroundCenter:{scaleX:1, scaleY:1}, ease:Elastic.easeOut});
		}
		
		protected function item_clickHandler(event:MouseEvent):void
		{
			var item:Item = event.target as Item;
		}
		
		protected function item_mouseOverHandler(event:MouseEvent):void
		{
			var item:Item = event.target as Item;
			TweenLite.to(item, 0.3, {transformAroundCenter:{scaleX:1.2, scaleY:1.2}, ease:Elastic.easeOut});
		}
		
		private function getRightGoodsRandomNum() : int
		{
			return Math.round(Math.random() * 3);
		}
		
		private function getTimeByNumber(num:int) : Bitmap
		{
			return null;
		}
	}
}