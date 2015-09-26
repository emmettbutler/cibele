package com.starmaid.Cibele.entities {
    import com.starmaid.Cibele.management.SoundManager;
    import com.starmaid.Cibele.management.ScreenManager;
    import com.starmaid.Cibele.management.LevelTracker;
    import com.starmaid.Cibele.base.GameSound;
    import com.starmaid.Cibele.utils.MapNodeContainer;
    import com.starmaid.Cibele.states.PathEditorState;
    import com.starmaid.Cibele.states.LevelMapState;
    import com.starmaid.Cibele.base.GameObject;
    import com.starmaid.Cibele.base.GameState;
    import com.starmaid.Cibele.utils.GlobalTimer;
    import com.starmaid.Cibele.utils.LRUDVector;
    import com.starmaid.Cibele.utils.DHPoint;
    import com.starmaid.Cibele.management.Path;

    import org.flixel.*;

    public class PartyMember extends GameObject {
        [Embed(source="/../assets/fonts/Nexa Bold.otf", fontFamily="NexaBold-Regular", embedAsCFF="false")] public var GameFont:String;
        [Embed(source="/../assets/images/characters/cib_shadow.png")] private var ImgShadow:Class;

        public static const STATE_IN_ATTACK:Number = 1;
        public static const STATE_MOVE_TO_ENEMY:Number = 34987651333;
        public static const STATE_AT_ENEMY:Number = 91823419673;
        public static const STATE_WALK:Number = 2398476188;
        public static const PARTICLE_CIBELE:Number = 1;
        public static const PARTICLE_ICHI:Number = 2;

        public var lastAttackTime:Number = 0;
        public var footsteps:FootstepTrail = null;
        public var footstepOffset:DHPoint;
        public var attackRange:Number = 70;
        public var nameText:FlxText;
        public var footPos:DHPoint;
        public var sightRange:Number = 280;
        public var bossSightRange:Number;
        public var targetEnemy:Enemy;
        public var attackAnimDuration:Number;
        public var walkTarget:DHPoint, finalTarget:DHPoint;
        public var particleType:Number;
        private var particles:ParticleExplosion;
        protected var _nameTextOffset:DHPoint;
        protected var _mapnodes:MapNodeContainer;
        protected var _cur_path:Path;
        protected var shadow_sprite:GameObject;
        protected var footstepOffsets:LRUDVector;
        protected var attackSounds:Array;
        protected var teamPowerDeltaText:FlxText;
        protected var emoji:Object;
        protected var _debug_sightRadius:CircleSprite,
                      _debug_attackRadius:CircleSprite;

        public function PartyMember(pos:DHPoint) {
            super(pos);
            this._nameTextOffset = new DHPoint(0, 0);
            this.nameText = new FlxText(pos.x, pos.y, 500, "My Name");
            this.nameText.setFormat("NexaBold-Regular",16,0xff616161,"left");
            this.teamPowerDeltaText = new FlxText(pos.x, pos.y, 500, "");
            this.teamPowerDeltaText.setFormat("NexaBold-Regular", 16, 0xff616161, "left");
            this.footPos = new DHPoint(0, 0);
            this.bossSightRange = 1200;
            this.attackAnimDuration = 2*GameSound.MSEC_PER_SEC;
            this.walkTarget = new DHPoint(0, 0);
            this.footstepOffsets = new LRUDVector();
            this.setupDebugSprites();

            this.emoji = {};
            this.emoji[Emote.HAPPY] = new Emote(
                Emote.HAPPY, (FlxG.state as GameState).ui_color_flag);
            this.emoji[Emote.SAD] = new Emote(
                Emote.SAD, (FlxG.state as GameState).ui_color_flag);
            this.emoji[Emote.ANGRY] = new Emote(
                Emote.ANGRY, (FlxG.state as GameState).ui_color_flag);

            if(ScreenManager.getInstance().levelTracker.level == LevelTracker.LVL_HI) {
                this.nameText.color = 0xffffffff;
                this.teamPowerDeltaText.color = 0xffffffff;
            }
        }

        override public function destroy():void {
            for (var k:Object in this.emoji) {
                this.emoji[k].destroy();
            }
            this.emoji = null;
            if (this.nameText != null) {
                this.nameText.destroy();
                this.nameText = null;
                this.teamPowerDeltaText.destroy();
                this.teamPowerDeltaText = null;
            }
            super.destroy();
        }

        public function setupSprites():void { }
        public function setupFootsteps():void { }

        public function setupDebugSprites():void {
            if (ScreenManager.getInstance().DEBUG) {
                this._debug_sightRadius = new CircleSprite(this.pos,
                                                           this.sightRange);
                this._debug_attackRadius = new CircleSprite(this.pos,
                                                            this.attackRange);
            }
        }

        public function setupParticles():void {
            this.particles = new ParticleExplosion(13, this.particleType, 2, .4, 12);
            this.particles.gravity = new DHPoint(0, .3);
        }

        public function initFootsteps():void {
            this.footsteps = new FootstepTrail(this);
        }

        public function setMapNodes(nodes:MapNodeContainer):void {
            this._mapnodes = nodes;
        }

        public function get nameTextOffset():DHPoint {
            return this._nameTextOffset;
        }

        public function buildShadowSprite():void {
            this.shadow_sprite = new GameObject(this.pos);
            this.shadow_sprite.zSorted = true;
            this.shadow_sprite.loadGraphic(ImgShadow,false,false,70,42);
        }

        public function addVisibleObjects():void {
            if (ScreenManager.getInstance().DEBUG) {
                FlxG.state.add(this._debug_sightRadius);
                FlxG.state.add(this._debug_attackRadius);
            }
            for (var k:Object in this.emoji) {
                this.emoji[k].addVisibleObjects();
            }
            this.particles.addVisibleObjects();
        }

        public function emote(mood:Number):void {
            this.emoji[mood].run(
                new DHPoint(this.pos.x + this.nameTextOffset.x,
                            this.pos.y + this.nameTextOffset.y));
        }

        public function playAttackSound():void {
            var snd:Class = this.attackSounds[
                Math.floor(Math.random() * this.attackSounds.length)
            ];
            SoundManager.getInstance().playSound(
                snd, 2*GameSound.MSEC_PER_SEC, null, false, .2
            );
        }

        public function buildBestPath(worldPos:DHPoint):Boolean {
            // examine nearby nodes to find the shortest path along the graph
            // from current position to worldPos

            var maxTries:Number = 10;

            // get closest N nodes to player
            var closeNodes:Array = this._mapnodes.getNClosestGenericNodes(maxTries, this.footPos);
            var curNode:MapNode = closeNodes[0]['node'], tries:Number = 0;

            // check each of these nodes for obstructions
            var res:Object = (FlxG.state as LevelMapState).pointsCanConnect(this.footPos, curNode.pos);
            while (!res["canConnect"] && tries < maxTries && curNode != null) {
                curNode = closeNodes[tries]['node'];
                if (curNode != null) {
                    res = (FlxG.state as LevelMapState).pointsCanConnect(this.footPos, curNode.pos);
                }
                if (ScreenManager.getInstance().DEBUG) {
                    trace(this.slug + ": trying again...");
                }
                tries += 1;
            }

            // if we found an unobstructed node, generate a path and initialize state
            if (res["canConnect"]) {
                this._cur_path = Path.shortestPath(
                    curNode,
                    this._mapnodes.getClosestNode(worldPos)
                );
                (FlxG.state as PathEditorState).clearAllAStarMeasures();

                this.walkTarget = this._cur_path.currentNode.pos;
                this.finalTarget = worldPos;

                if (ScreenManager.getInstance().DEBUG) {
                    trace(this.slug + ": path: " + this._cur_path.toString());
                }
                return true;
            }
            return false;
        }

        public function initWalk(worldPos:DHPoint, usePaths:Boolean=true):void {
            this.setFootPos();
            var useNodes:Boolean = true;
            if (this._mapnodes != null && FlxG.state is LevelMapState) {
                var closestNode:MapNode = this._mapnodes.getClosestNode(this.pos);
                var connectInfo:Object = (FlxG.state as LevelMapState).pointsCanConnect(this.footPos, worldPos);
                if (closestNode == null || connectInfo["canConnect"]) {
                    useNodes = false;
                    if (ScreenManager.getInstance().DEBUG) {
                        trace(this.slug + ": not using pathfinding (closestNode == " + closestNode + ")");
                    }
                } else {
                    var destinationDisp:Number = this.footPos.sub(worldPos)._length();
                    var nearestNodeDisp:Number = this.footPos.sub(closestNode.pos)._length();
                    if (!usePaths || destinationDisp < nearestNodeDisp) {
                        this.walkTarget = worldPos;
                        this.finalTarget = worldPos;
                        this._cur_path = null;
                    } else {
                        useNodes = this.buildBestPath(worldPos);
                    }
                }
            } else {
                useNodes = false;
            }

            if (!useNodes) {
                this.walkTarget = worldPos;
                this.finalTarget = worldPos;
                this._cur_path = null;
            }

            this._state = STATE_WALK;
        }

        override public function update():void {
            super.update();

            if (ScreenManager.getInstance().DEBUG) {
                this._debug_sightRadius.setPos(this.footPos.sub(
                    new DHPoint(this._debug_sightRadius.radius,
                                this._debug_sightRadius.radius)
                ));
                this._debug_attackRadius.setPos(this.footPos.sub(
                    new DHPoint(this._debug_attackRadius.radius,
                                this._debug_attackRadius.radius)
                ));
            }

            if (this.footsteps != null) {
                this.footsteps.update();
            }

            if (this.particles != null) {
                this.particles.update();
            }

            this.nameText.x = this.pos.x + this._nameTextOffset.x;
            this.nameText.y = this.footPos.y - this.frameHeight * this.scale.y - 30;
            this.teamPowerDeltaText.x = this.pos.x + this._nameTextOffset.x;
            this.teamPowerDeltaText.y = (this.pos.y + this._nameTextOffset.y * this.scale.y) - 40;

            this.setFootPos();
        }

        protected function setFootPos():void {
            this.footPos.x = this.x + (this.frameWidth/2);
            this.footPos.y = this.y + this.frameHeight;
        }

        public function isAttacking():Boolean{
            return this._state == STATE_IN_ATTACK;
        }

        public function directionToObj(obj:DHPoint):DHPoint {
            return obj.sub(this.pos);
        }

        public function attack():void {
            if (this.canAttack()) {
                this._state = STATE_IN_ATTACK;
                this.lastAttackTime = this.currentTime;
            }
        }

        public function runParticles(pos:DHPoint):void {
            this.particles.run(pos);
        }

        public function runAttackParticles():void {
            if(this.targetEnemy != null) {
                if(this.targetEnemy.isSmall()) {
                    this.runParticles(this.targetEnemy.getMiddlePos().sub(new DHPoint(0, this.targetEnemy.height/3)));
                } else {
                   this.runParticles(this.getMiddlePos().sub(new DHPoint(this.width/2, this.height - 20)));
                }
            } else {
                this.runParticles(this.getMiddlePos().sub(new DHPoint(this.width/2, this.height - 20)));
            }
        }

        public function hasCurPath():Boolean {
            return this._cur_path != null;
        }

        public function timeSinceLastAttack():Number {
            return this.currentTime - this.lastAttackTime;
        }

        public function canAttack():Boolean {
            return this.timeSinceLastAttack() > this.attackAnimDuration;
        }

        public function enemyIsInAttackRange(en:Enemy):Boolean {
            if (en == null) { return false; }
            var disp:Number = en.getAttackPos().sub(this.footPos)._length();
            return disp < this.attackRange;
        }

        public function enemyIsInMoveTowardsRange(en:Enemy):Boolean{
            if (en == null) { return false; }
            var range:Number = this.sightRange;
            if (en is BossEnemy) {
                range = this.bossSightRange;
            }
            return en.getAttackPos().sub(this.footPos)._length() < range;
        }

        public function get teamPowerDamageMul():Number {
            if (!(FlxG.state is PathEditorState)) {
                return 1;
            }
            return ((FlxG.state as PathEditorState).teamPower * .02) + 1;
        }

        public function showTeamPowerDelta(delta:Number):void {
            this.teamPowerDeltaText.text = (delta >= 0 ? "+" : "") + delta + "";
            GlobalTimer.getInstance().setMark(
                "delta" + this.slug + Math.random() * 100000,
                1.3 * GameSound.MSEC_PER_SEC,
                function():void {
                    teamPowerDeltaText.text = "";
                }
            );
        }

        public function resolveStatePostAttack():void {}
    }
}
