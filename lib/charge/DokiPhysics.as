package lib.charge {

	import flash.events.Event;
	import flash.display.MovieClip;
	import lib.charge.Guy;
	import lib.charge.ChargeGame;

	public class DokiPhysics extends Guy {

		private var xDiff: Number;
		private var yDiff: Number;
		public var xVel: Number;
		public var yVel: Number;
		public var rock: Guy = new Rock();
		private var song: Guy = new SIIAttack();
		private var guy: Guy = new Guy();
		private var target: Object;
		private var damage: Number;
		private var cGame: ChargeGame;


		private var power: Number;

		public function DokiPhysics() {
			//this.addEventListener("Rock", rockDeath)
		}

		//Mostly taken from ShootGame.as makeArrow()
		public function rockDeath(cddX: Number, cddY: Number, chargeGame: ChargeGame) {
			cGame = chargeGame;
			xVel = 0;
			yVel = 0;
			//var gravity: Number = .75;

			trace("rockDeath called");
			rock = new Rock();
			addChild(rock)

			cddY += 200;

			//trace(rock);
			//game.currentStage.playingField.addChild(rock);
			rock.gotoAndStop(Math.ceil(Math.random() * 3));
			rock.x = cddX;
			rock.y = cddY;
			trace(rock.x, rock.y + " rock cord pre");


			var xDiff: Number = cddX - chargeGame.enemyBase.x;
			var yDiff: Number = cddY - chargeGame.enemyBase.y + 100;
			//trace(Math.sqrt(Math.pow(xDiff, 2) + Math.pow(yDiff, 2)))
			var distance: Number = Math.sqrt(Math.pow(xDiff, 2) + Math.pow(yDiff, 2) / 15);
			trace(distance + " kjhrtu");

			power = distance / 15;

			xVel = power * Math.cos(rock.rotation / 180 * Math.PI);
			yVel = (cddY + chargeGame.enemyBase.y) / yDiff; //power;// * Math.sin(rock.rotation / 180 * Math.PI);
			trace(xVel, yVel + " vels");

			addEventListener(Event.ENTER_FRAME, rockThrown);
			//rock.hitTestObject();
			return this;
		}

		private function rockThrown(evt: Event) {
			//hitTestObject(rock);
			rock.x += xVel - 10;
			rock.y += yVel;
			//trace("oh she goes");
			trace(rock.x, rock.y + " rock cord post");
			//trace("Rock thrown");
			//trace(chargeGame.enemyBase.x)

			if (rock.x >= cGame.enemyBase.x) {
				trace("base reached");
				cGame.enemyScore--;
				cGame.enemyField.text = "Enemy Health: " + cGame.enemyScore;
				removeEventListener(Event.ENTER_FRAME, rockThrown);
				rock.y = 1000;
				//parent.removeChild(rock);
			}
		}

		public function singSong(initTarget: Object, damdage: Number, chargeGame: ChargeGame, siiX: Number, siiY: Number) {
			cGame = chargeGame;
			target = initTarget;
			//trace(target.name);
			damage = damdage;
			song = new SIIAttack();
			song.x = siiX;
			song.y = siiY + 50;
			this.addChild(song);
			song.gotoAndPlay(1);
			trace(this + " is the parent of song");
			song.name = "song";
			trace("sung", song.name);
			addEventListener(Event.ENTER_FRAME, songSung);
			return this;

		}

		private function songSung(evt: Event) {
			song.x += 5;

			if (song.x >= target.x) {
				songDamage();
			}
		}

		public function songDamage(): void {x	
			target.takeDamage(damage);
			//trace("taken damage " + target);
			removeEventListener(Event.ENTER_FRAME, songSung);
			this.removeChild(song);
			if (target.getstatus() == "Die") {
				trace(this + " is what song is trying to be removed from");
				song.parent.removeChild(song);
			}
		}
	}


}