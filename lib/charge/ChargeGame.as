package lib.charge
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.text.TextField;
	import lib.charge.ChargeDoc;
	import lib.charge.DokiPhysics;
	import lib.bill.Parallax;
	import lib.charge.Guy;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.text.TextFormat;
	
	public class ChargeGame extends MovieClip
	{
		public var currentStage:MovieClip;
		public var enemyBase:MovieClip;
		public var yourBase:MovieClip;
		private var enemyCounter:Number;
		private var enemyCounterTotal:Number;
		private var SIICounter:Number;
		private var SIICounterTotal:Number;
		private var PBBCounter:Number;
		private var PBBCounterTotal:Number;
		private var CDDCounter:Number;
		private var CDDCounterTotal:Number;
		
		public var yourGuys:Array;
		public var enemyGuys:Array;
		
		private var siiButton:SimpleButton;
		private var pbbButton:SimpleButton;
		private var cddButton:SimpleButton;
		
		private var yBuffer:Number;
		private var xBuffer:Number;
		
		private var yourScore:Number;
		public var enemyScore:Number;
		
		private var yourField:TextField;
		public var enemyField:TextField;
		/*private var scoreFormat:TextFormat = new TextFormat;
		scoreFormat.size = 30;
		scoreFormat.font = "Comic Sans MS";
		scoreFormat.bold = true;*/
		
		//public var scrollBar:RoundScrollBar = new RoundScrollBar();
		private var intro:IntroClip = new IntroClip();
		private var tutorial:TutScreen = new TutScreen();
		private var dokiPhysics:DokiPhysics;
		private var pauseButton:PauseButton = new PauseButton();
		private var pauseScreen:PauseScreen = new PauseScreen();
		private var startMenu:StartScreen = new StartScreen();
		private var heart1:Heart = new Heart();
		private var heart2:Heart = new Heart();
		private var heart3:Heart = new Heart();
		
		private var rock:Guy = new Rock();
		private var guy:Guy = new Guy();
		//public var game:ChargeGame = new ChargeGame();
		
		public function ChargeGame ()
		{
			
			yBuffer = 100;
			xBuffer = 30;
			
			enemyCounter = 5; //5
			enemyCounterTotal = 30; //((Math.random()*100)*(Math.random()*50));  //10 for hard mode
			SIICounter = 100;
			PBBCounter = 100;
			CDDCounter = 100;
			SIICounterTotal = 100;
			PBBCounterTotal = 200;
			CDDCounterTotal = 500;
			
			yourGuys = new Array();
			enemyGuys = new Array();
			
			currentStage = new Stage1();
			siiButton = new SIIButton();
			pbbButton = new PBBButton();
			cddButton = new CDDButton();
			
			/*pbbButton.x = mouseX;
			siiButton.x = pbbButton.x - pbbButton.width;
			cddButton.x = pbbButton.x + pbbButton.width;
			siiButton.y = pbbButton.y = cddButton.y = 20;*/
			
			addChild(currentStage);
			addChild(siiButton);
			addChild(pbbButton);
			addChild(cddButton);
/////////			
/*SCORE*/	yourScore = 10;
/*SCORE*/	enemyScore = 10;
/////////		
			var scoreFormat:TextFormat = new TextFormat();
			scoreFormat.size = 30;
			scoreFormat.font = "Comic Sans MS";
			scoreFormat.bold = true;
			// ^^^ http://www.republicofcode.com/tutorials/flash/as3text/ &  https://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextFormat.html
		
			yourField = new TextField;
			yourField.defaultTextFormat = scoreFormat;
			yourField.width = 300;
			yourField.text = "Your Health: 10";
			
			enemyField = new TextField;
			enemyField.defaultTextFormat = scoreFormat;
			enemyField.width = 300;
			enemyField.text = "Enemy Health: 10";
			

			
			addChild(yourField);
			addChild(enemyField);
			
			siiButton.addEventListener(MouseEvent.CLICK, createSIIHandler);
			pbbButton.addEventListener(MouseEvent.CLICK, createPBBHandler);
			cddButton.addEventListener(MouseEvent.CLICK, createCDDHandler);
			
			/*scrollBar.x = 500;
			scrollBar.y = 5;
			addChild(scrollBar);
			scrollBar.addEventListener(Event.MouseEvent.CLICK, scrollBarHandler);*/
			
			yourBase = new Castle();
			enemyBase = new Castle();
			
			yourBase.y = enemyBase.y = currentStage.playingField.height - yourBase.height - yBuffer;
			enemyBase.x = currentStage.playingField.width - enemyBase.width - xBuffer;
			yourBase.x = xBuffer;
			
			currentStage.playingField.addChild(yourBase);
			currentStage.playingField.addChild(enemyBase);
						
			addEventListener(Event.ADDED_TO_STAGE, start);
		}
		
		private function start(evt:Event):void
		{
			addEventListener(Event.ENTER_FRAME, update);
			trace(stage);
			pauseButton.x = stage.stageWidth/2;// - pauseButton.width;
			pauseButton.y = stage.stageHeight - pauseButton.height;
			addChild(pauseButton);
			pauseButton.addEventListener(MouseEvent.CLICK, pause);
			
			pbbButton.x = stage.stageWidth/2;
			siiButton.x = pbbButton.x - pbbButton.width;
			cddButton.x = pbbButton.x + pbbButton.width;
			
			yourField.x = 0;
			enemyField.x = stage.stageWidth - enemyField.width;
		}
		
		private function createSIIHandler(evt:MouseEvent):void
		{
			createGuy("Good", "SII", new SII(), "Ranged");
		}
		
		private function createPBBHandler(evt:MouseEvent):void
		{
			createGuy("Good", "PBB", new PBB(), "Melee");
		}
		
		private function createCDDHandler(evt:MouseEvent):void
		{
			createGuy("Good", "CDD", new CDD(), "Melee");
		}
		
		public function createGuy(dir:String, unitType:String, newGuy:Guy, combat:String):void
		{
			trace(unitType +" created! " + dir);
			//trace("Guy y - " + newGuy.y, "Base y - " + yourBase.y);
			
			newGuy.setDir(dir, combat);
			newGuy.chargeGame = this;
			//if(unitType != "Rock"){
			newGuy.y = yourBase.y + yourBase.height - newGuy.height;
			/*} else {
				dokiPhysics.rockDeath();
				trace("rockDeath called");
				
			}*/
			
			
			if (dir == "Good")
			{
				counter("clicked", unitType);
				
				newGuy.x = xBuffer + newGuy.width;
				//newGuy.y = stage.stageHeight - newGuy.height - 5;
				
				newGuy.enemies = enemyGuys;
				newGuy.friends = yourGuys;
				
				yourGuys.push(newGuy);
			}
			else
			{
				newGuy.x = currentStage.playingField.width - newGuy.width - xBuffer;
				
				newGuy.enemies = yourGuys;
				newGuy.friends = enemyGuys;
				
				enemyGuys.push(newGuy);
			}
			
			currentStage.playingField.addChild(newGuy);
			
		}
/////// Better way w/ for loop?		
		private function update(evt:Event):void
		{
//			scrollBar.addEventListener(Event.MouseEvent.MOUSE_DOWN, stageMotion);
		
			counter("unclicked", "N/A");
			
			if(yourScore <= 0){
				endGame("Lose");
			}
			if(enemyScore <= 0){
				endGame("Win");
			}
		//	rock.x += 5;
			
			currentStage.update();
			

			var guy:Guy;
			
			for each (guy in yourGuys)
			{
				if (guy.x > enemyBase.x)
				{
					enemyScore--;
					enemyField.text = "Enemy Health: " + enemyScore;
					guy.purge();
				} else if (guy.x < 0){
					guy.purge();
				}
				else
				{
					guy.update();
				}
			}
			
			for each (guy in enemyGuys)
			{
				if (guy.x < yourBase.x + yourBase.width)
				{
					yourScore--;
					yourField.text = "Your Health: " + yourScore;
					guy.purge();
				}
				else
				{
					guy.update();
				}
			}
		}
		/*
		private function stageMotion(evt:MouseEvent):void {
			scrollBar.x = mouseX;
			currentStage.update(scrollBar.x);
//			scrollBar.addEventListener(Event.MouseEvent.MOUSE_UP, stopStageMotion);

			//addEventListener(Event.KeyboardEvent.KEY_DOWN, keyDownHandler);
			/*if(keyDown == false){
				currentStage.update();
			} 
		}*/
		/*
		private function stopStageMotion(evt:MouseEvent):void {
			var lastMouseX = mouseX;
			scrollBar.x = lastMouseX;
//			scrollBar.removeEventListener(Event.MouseEvent.MOUSE_UP, stopStageMotion);
		}*/
		
		/*private function keyDownHandler(evt:KeyboardEvent) {
			if(evt.keyCode != 32){
				keyDown = true;
			} else {
				keyDown = false;
			}
		}*/
		
		private function counter(clicked:String, unitType:String)
		{
			if(clicked == "unclicked"){
				if (SIICounter < SIICounterTotal)
				{
					SIICounter++;
				}
				else
				{
					siiButton.mouseEnabled = true;
					siiButton.alpha = 1;
				}
				if (PBBCounter < PBBCounterTotal)
				{
					PBBCounter++;
				}
				else
				{
					pbbButton.mouseEnabled = true;
					pbbButton.alpha = 1;
				}
				if (CDDCounter < CDDCounterTotal)
				{
					CDDCounter++;
				}
				else
				{
					cddButton.mouseEnabled = true;
					cddButton.alpha = 1;
				}
				if (enemyCounter < enemyCounterTotal)
				{
	 				enemyCounter++;
					//enemyCounterTotal = ((Math.random()*100)*(Math.random()*50));
					
				}
				else
				{
					enemyCounter = -100;
					createGuy("Bad", "SCG", new SCG(), "Melee");
					//trace(enemyCounterTotal);
				}
			}
			
			if(clicked == "clicked") 
			{				
				if (unitType == "SII")
				{
					SIICounter = 0;
					siiButton.mouseEnabled = false;
					siiButton.alpha = 0.3;
				}
				if (unitType == "PBB")
				{
					PBBCounter = 0;
					pbbButton.mouseEnabled = false;
					pbbButton.alpha = 0.3;
				}
				if (unitType == "CDD")
				{
					CDDCounter = 0;
					cddButton.mouseEnabled = false;
					cddButton.alpha = 0.3;
				}
			}
			
		}
		
		private function pause(evt:MouseEvent):void
		{
			removeEventListener(Event.ENTER_FRAME, update);
			removeEventListener(Event.ADDED_TO_STAGE, start);
			stage.addChild(pauseScreen);
			pauseScreen.unpauseBtn.addEventListener(MouseEvent.CLICK, unpause);
			pauseScreen.menuBtn.addEventListener(MouseEvent.CLICK, startChargeDoc);
		}
		
		private function unpause(evt:MouseEvent):void
		{
			pauseScreen.unpauseBtn.removeEventListener(MouseEvent.CLICK, unpause);
			stage.removeChild(pauseScreen);
			addEventListener(Event.ENTER_FRAME, update);
			addEventListener(Event.ADDED_TO_STAGE, start);
		}
		
		private function endGame(condition:String):void
		{
			removeEventListener(Event.ENTER_FRAME, update);
			removeEventListener(Event.ADDED_TO_STAGE, start);
			//gameEnded = true;
			var winScreen:WinScreen = new WinScreen();
			var loseScreen:LoseScreen = new LoseScreen();
			
			
			if(condition == "Win"){
				trace("Won");
				winScreen.x = stage.stageWidth/2;
				winScreen.y = stage.stageHeight/2;
				stage.addChild(winScreen);
				winScreen.playAgainW.addEventListener(MouseEvent.CLICK, startChargeDoc);
			} else if(condition == "Lose"){
				trace("Lost");
				loseScreen.x = stage.stageWidth/2;
				loseScreen.y = stage.stageHeight/2;
				stage.addChild(loseScreen);
				loseScreen.playAgainL.addEventListener(MouseEvent.CLICK, startChargeDoc);
			}
			mouseFollower();
		}
		
		private function startChargeDoc(evt:MouseEvent):void{
			//removeChild(evt.currentTarget.parent);
			evt.currentTarget.removeEventListener(MouseEvent.CLICK, startChargeDoc);
			//trace(evt.currentTarget.parent);		
			stage.removeChild(evt.currentTarget.parent);
			startMenu.x = 0;//stage.stageWidth/2;
			startMenu.y = 0;//stage.stageHeight/2;
			stage.addChild(startMenu);
			mouseFollower();
			trace("menu created");
			startMenu.startButton.addEventListener(MouseEvent.CLICK, startGameHandler);
			startMenu.storyButton.addEventListener(MouseEvent.CLICK, startStoryHandler);
			startMenu.tutorialButton.addEventListener(MouseEvent.CLICK, createTutorial);
		}
		private function startMenuHandler(evt:MouseEvent):void
		{
			//trace(evt.currentTarget.parent);
			stage.removeChild(intro);
			evt.currentTarget.removeEventListener(MouseEvent.CLICK, startGameHandler);
			startMenu.x = 0;//stage.stageWidth/2;
			startMenu.y = 0;//stage.stageHeight/2;
			stage.addChild(startMenu);
			trace("menu created");
			startMenu.startButton.addEventListener(MouseEvent.CLICK, startGameHandler);
			startMenu.storyButton.addEventListener(MouseEvent.CLICK, startStoryHandler);
			startMenu.tutorialButton.addEventListener(MouseEvent.CLICK, createTutorial);
			mouseFollower();
		}
		
		private function createTutorial(evt:MouseEvent):void {
			stage.addChild(tutorial);
			mouseFollower();
			tutorial.gotoAndStop(1);
			tutorial.nextBtn.addEventListener(MouseEvent.MOUSE_DOWN, playNext);
			tutorial.menuBtn.addEventListener(MouseEvent.CLICK, deleteTutorial);
		}
		private function deleteTutorial(evt:MouseEvent):void {
			stage.removeChild(tutorial);
		}
		
		private function startGameHandler(evt:MouseEvent):void
		{	
			//trace(evt.currentTarget.parent);
			stage.removeChild(evt.currentTarget.parent);
			evt.currentTarget.removeEventListener(MouseEvent.CLICK, startGameHandler);
			mouseFollower();
			createGame();
		}
			

		private function startStoryHandler(evt:MouseEvent):void
		{
			stage.removeChild(startMenu);
			evt.currentTarget.removeEventListener(MouseEvent.CLICK, startStoryHandler);
			
			stage.addChild(intro);
			intro.gotoAndPlay(1);
			intro.nextBtn.addEventListener(MouseEvent.MOUSE_DOWN, nxtFrm);
			intro.menuBtn.addEventListener(MouseEvent.CLICK, startMenuHandler);
			intro.playBtn.addEventListener(MouseEvent.CLICK, startGameHandler);
			mouseFollower();
		}
		
		private function nxtFrm (evt:MouseEvent): void {
			intro.play();
		}
		
		private function playNext(evt:MouseEvent):void{
			tutorial.play();
		}
		
		private function createGame():void
		{			
			var game:ChargeGame = new ChargeGame();
			stage.addChild(game);
			mouseFollower();
		}
		
		private function mouseFollower():void
		{
			stage.addChild(heart1);
			stage.addChild(heart2);
			stage.addChild(heart3);
			heart2.scaleX = .75;
			heart2.scaleY = .75;
			heart3.scaleX = .5;
			heart3.scaleY = .5;
			heart1.x = heart2.x = heart3.x = mouseX;
			heart1.y = heart2.y = heart3.y = mouseY;
			heart1.mouseEnabled = false;
			heart2.mouseEnabled = false;
			heart3.mouseEnabled = false;
			addEventListener(Event.ENTER_FRAME, mouseFollowerZ);
		}
		private function mouseFollowerZ(evt:Event)
		{
			heart1.x += ((mouseX + 20) - heart1.x) / 5;
			heart1.y += ((mouseY + 20) - heart1.y) / 5;	
			heart2.x += ((heart1.x + 30) - heart2.x) / 5;
			heart2.y += ((heart1.y + 30) - heart2.y) / 5;
			heart3.x += ((heart2.x + 25) - heart3.x) / 5;
			heart3.y += ((heart2.y + 25) - heart3.y) / 5;
		}
	}
}