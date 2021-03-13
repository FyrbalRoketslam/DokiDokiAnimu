package lib.charge {
	import flash.display.MovieClip;
	import com.greensock.*;
	import flash.utils.getQualifiedClassName;
	import flash.events.Event;
	import lib.charge.DokiPhysics;
	import lib.charge.ChargeGame;
	import flash.utils.Timer;

	public class Guy extends MovieClip {
		public var status: String;
		private var dir: String;
		private var combat: String;

		private var siiHealth: Number = 100;
		private var siiDamage: Number = 5;
		private var siiSpeed: Number = 2;
		private var pbbHealth: Number = 80;
		private var pbbDamage: Number = 50;
		private var pbbSpeed: Number = 3;
		private var cddHealth: Number = 500;
		private var cddDamage: Number = 0;
		private var cddSpeed: Number = 1;
		private var scgHealth: Number = 100;
		private var scgDamage: Number = 40;
		private var scgSpeed: Number = 2;
		private var health: Number;
		private var damage: Number;
		private var speed: Number;
		
		private var song: Guy;

		private var curFrame: Number;
		private var attackFrames: Number;
		private var hitFrame: Number;

		private var target: Guy;

		public var enemies: Array;
		public var friends: Array;

		var cddX: Number;
		var cddY: Number;
		private var cddMoveTimer:Number = 0;
		private var cddTarget:Number = 0;

		private var dokiPhysics: DokiPhysics;
		public var chargeGame: ChargeGame;


		public function Guy() {
			var className: String = getQualifiedClassName(this);

			enemies = new Array();
			//set the default conditions for a generic guy
			dir = "Good";
			setStatus("Walk");

			curFrame = 0;
			attackFrames = 8;
			hitFrame = 5;

			if (className == "SII") {
				health = siiHealth;
				damage = siiDamage;
				speed = siiSpeed;
			} else if (className == "PBB") {
				health = pbbHealth;
				damage = pbbDamage;
				speed = pbbSpeed;
			} else if (className == "CDD") {
				health = cddHealth;
				damage = cddDamage;
				speed = cddSpeed;
			} else if (className == "SCG") {
				health = scgHealth;
				damage = scgDamage;
				speed = ((Math.ceil(Math.random() * 5)) + 1);
				//trace(speed);
			}

			/*//Randomize health, speed, and damage
			health = Math.ceil(Math.random() * 50 + 75);
			damage = Math.ceil(Math.random() * 10 + 5);
			speed = Math.random() * 2 + 2;*/

		}

		public function setDir(newDir: String, combatType: String): void {
			dir = newDir;
			combat = combatType;

			if (status == "Walk") {
				gotoAndStop(1);
			} else if (status == "Fight") {
				gotoAndStop(2);
			} else {
				gotoAndStop(3);
			}

			//gotoAndStop(status + dir); //DieLeft
		}

		public function setStatus(state: String): void {
			trace("Status = " + state);

			status = state;
			//play the correct frames for status
			if (status == "Walk") {
				gotoAndStop(1);
			} else if (status == "Fight") {
				gotoAndStop(2);
			} else {
				gotoAndStop(3);
			}
			//gotoAndStop(status + dir);
		}

		public function getStatus(): String {
			return status;
		}

		public function attack(): void {
			var className: String = getQualifiedClassName(this);
			var dokiPhysics: DokiPhysics = new DokiPhysics();

			if (className != "SII") {
				target.takeDamage(damage);
			} else if (className == "SII") {
				trace(dokiPhysics);
				//dokiPhysics.singSong(target, damage, chargeGame);
				trace(chargeGame.currentStage.playingField, chargeGame.currentStage, chargeGame);
				chargeGame.currentStage.playingField.addChild(dokiPhysics.singSong(target, damage, chargeGame, this.x, this.y));
				//target.takeDamage(damage);
				//trace(this, target, health, damage);
			}

			if (target.getStatus() == "Die") {
				setStatus("Walk");
			}

			curFrame = 0;
		}

		public function takeDamage(amount: Number): void {
			//trace("Took " + amount + " damage!");

			if (status != "Die") {
				//trace(health, damage);
				health -= amount;
				if (health <= 0) {
					die();
				}
			}
		}

		public function die(): void {
			var dokiPhysics: DokiPhysics = new DokiPhysics();
			setStatus("Die");
			trace(this + " has died!");
			health = 0;

			var className: String = getQualifiedClassName(this); //http://www.rblab.com/blog/2010/03/as3-snippet-get-class-name-from-object/

			if (className == "CDD") {
				//var rock2:MovieClip = new MovieClip();
				cddX = this.x;
				cddY = this.y;
				trace(cddX, cddY + " is CDD");
				//chargeGame.currentStage.playingField.addChild(rock2);
				//rock2.x = cddX;
				//rock2.y = cddY;
				chargeGame.currentStage.playingField.addChild(dokiPhysics.rockDeath(cddX, cddY, chargeGame));
				//chargeGame.createGuy("Good", "Rock", new Rock());
				//dokiPhysics.dispatchEvent(new Event("Rock"));
				//trace(this);
			}
		}

		public function setTarget(newTarget: Guy): void {
			target = newTarget;
			setStatus("Fight");
		}

		private function lookForTarget(): void {
			for each(var enemy: Guy in enemies) {
				if (enemy.getStatus() != "Die" && ((dir == "Bad" && x < enemy.x) || (dir == "Good" && x > enemy.x || combat == "Ranged" && x > enemy.x - 200))) {
					setTarget(enemy);
					break;
				}
			}
		}
		
		/*private function checkForSong(){
			for each(var enemy: Guy in enemies){
				if(hitTestObject(song)){
					dokiPhysics.songDamage();
				}
			}
		}*/

		public function purge(): void {
			var i: int;

			for (i = 0; i < friends.length; i++) {
				if (friends[i].name == name) {
					friends.splice(i, 1);
					i = friends.length;
				}
			}
			//trace(this);
			parent.removeChild(this);

		}

		public function update(): void {
			var className: String = getQualifiedClassName(this); //http://www.rblab.com/blog/2010/03/as3-snippet-get-class-name-from-object/
			//var cddTarget:Number = 0;
			
			if (status == "Die") {
				health -= 1;
				if (health <= -15) { //fixed from 60 & 30 - messed up parallax
					purge();
				} else if (health <= -13) { //INSERT GREENSOCK DEATH

					if (className == "SCG") {
						TweenLite.to(this, 0.2, {
							x: (this.x + 50),
							y: (this.y - 20),
							alpha: 0
						});
					} else {
						TweenLite.to(this, 0.2, {
							x: (this.x - 50),
							y: (this.y - 20),
							alpha: 0
						});
					}

					/*//blink
					if (alpha == 0)
					{
						alpha = 1;
					}
					else
					{
						alpha = 0;
					}*/
				}
			} else if (status == "Walk") {
				if (dir == "Good" && className != "CDD") {
					x += speed;
			} else if (dir == "Good" && className == "CDD"){
					moveCounter();
					/*cddTarget = this.x + speed;
					speed *= .95
					x += speed;//(cddTarget - this.x)/2;*/
				} else {
					x -= speed;
				}
				

				lookForTarget();
			} else if (status == "Fight") {
				if (curFrame == hitFrame) {
					attack();
				}
				curFrame++;
			}


		}
		
		private function moveCounter(){
			if(cddMoveTimer == 0){
				moveCDD();
				cddMoveTimer ++;
				//trace("moveTimer");
			}else if(cddMoveTimer > 0 && cddMoveTimer < 50){
				cddMoveTimer ++;
				//trace("0<cMT<100");
			} else if(cddMoveTimer >= 50){
				cddMoveTimer = 0;
				//trace("cMT=0");
			}
		}
		
		private function moveCDD(){
			trace(this, this.x);
			cddTarget = this.x + 50;
			//speed *= .95
			addEventListener(Event.ENTER_FRAME, updateCDD);
		}
		
		private function updateCDD(evt:Event){
			this.x += (cddTarget - this.x)/8;
			//trace("cddTarget = " + cddTarget);
		}

	}
}