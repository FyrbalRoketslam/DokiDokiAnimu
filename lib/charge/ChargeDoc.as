package lib.charge {
	import flash.display.StageScaleMode;
	import flash.events.MouseEvent;
	import flash.display.MovieClip;
	import lib.charge.ChargeGame;
	import com.greensock.*;
	import flash.events.Event;

	public class ChargeDoc extends MovieClip {
		private var intro: IntroClip = new IntroClip();
		private var tutorial: TutScreen = new TutScreen();
		private var heart1: Heart = new Heart();
		private var heart2: Heart = new Heart();
		private var heart3: Heart = new Heart();

		public function ChargeDoc() {
			stage.scaleMode = StageScaleMode.NO_SCALE;

			init();
			//createIntroClip();
		}

		private function createIntroClip(evt: MouseEvent): void {
			removeChild(evt.currentTarget.parent);
			evt.currentTarget.removeEventListener(MouseEvent.CLICK, createIntroClip);
			stage.addChild(intro);
			intro.gotoAndPlay(1);
			intro.nextBtn.addEventListener(MouseEvent.MOUSE_DOWN, nxtFrm);
			intro.menuBtn.addEventListener(MouseEvent.CLICK, createStartMenu);
			intro.playBtn.addEventListener(MouseEvent.CLICK, startGameHandler);

			/*if (currentFrame == 23) {
				intro.nextBtn.visible = true;
			}else if (currentFrame != 23) {
				intro.nextBtn.visible = false;
			}*/
			/*
			if (currentFrame == 323) {
				intro.playBtn.visible = true;
			}else if (currentFrame != 323) {
				intro.playBtn.visible = false;
			}*/
			//trace("Events added");
		}

		//Button handler for intro "next" buttons
		//private function nextIntroFrame(evt:MouseEvent):void {
		//	trace("Clicked Next");			
		//	this.play();//thanks Nic
		//	
		//}
		private function nxtFrm(evt: MouseEvent): void {
			intro.play();
		}

		private function playNext(evt: MouseEvent): void {
			tutorial.play();
		}

		private function init(): void {
			var startMenu: StartScreen = new StartScreen();
			startMenu.x = 0; //stage.stageWidth/2;
			startMenu.y = 0; //stage.stageHeight/2;
			addChild(startMenu);

			mouseFollower();

			startMenu.startButton.addEventListener(MouseEvent.CLICK, startGameHandler);
			startMenu.storyButton.addEventListener(MouseEvent.CLICK, createIntroClip);
			startMenu.tutorialButton.addEventListener(MouseEvent.CLICK, createTutorial);
		}

		private function createStartMenu(evt: MouseEvent): void {
			stage.removeChild(intro);
			var startMenu: StartScreen = new StartScreen();
			startMenu.x = 0; //stage.stageWidth/2;
			startMenu.y = 0; //stage.stageHeight/2;
			addChild(startMenu);

			mouseFollower();

			startMenu.startButton.addEventListener(MouseEvent.CLICK, startGameHandler);
			startMenu.storyButton.addEventListener(MouseEvent.CLICK, createIntroClip);
			startMenu.tutorialButton.addEventListener(MouseEvent.CLICK, createTutorial);
		}

		private function createTutorial(evt: MouseEvent): void {
			stage.addChild(tutorial);
			mouseFollower();
			tutorial.gotoAndStop(1);
			tutorial.nextBtn.addEventListener(MouseEvent.MOUSE_DOWN, playNext);
			tutorial.menuBtn.addEventListener(MouseEvent.CLICK, deleteTutorial);
		}
		private function deleteTutorial(evt: MouseEvent): void {
			stage.removeChild(evt.currentTarget.parent);
		}

		private function startGameHandler(evt: MouseEvent): void {
			removeChild(evt.currentTarget.parent);

			evt.currentTarget.removeEventListener(MouseEvent.CLICK, startGameHandler);

			createGame();
		}

		private function createGame(): void {
			var game: ChargeGame = new ChargeGame();

			stage.addChild(game);
			mouseFollower();
		}


		private function mouseFollower(): void {
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
		private function mouseFollowerZ(evt: Event) {
			heart1.x += ((mouseX + 20) - heart1.x) / 5;
			heart1.y += ((mouseY + 20) - heart1.y) / 5;	
			heart2.x += ((heart1.x + 30) - heart2.x) / 5;
			heart2.y += ((heart1.y + 30) - heart2.y) / 5;
			heart3.x += ((heart2.x + 25) - heart3.x) / 5;
			heart3.y += ((heart2.y + 25) - heart3.y) / 5;
		}
	}
}