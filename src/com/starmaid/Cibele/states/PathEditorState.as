package com.starmaid.Cibele.states {
    import com.starmaid.Cibele.management.ScreenManager;
    import com.starmaid.Cibele.utils.EnemyGroup;
    import com.starmaid.Cibele.utils.MapNodeContainer;
    import com.starmaid.Cibele.utils.DataEvent;
    import com.starmaid.Cibele.entities.PathFollower;
    import com.starmaid.Cibele.entities.TeamPowerBar;
    import com.starmaid.Cibele.entities.IkuTursoBoss;
    import com.starmaid.Cibele.entities.EuryaleBoss;
    import com.starmaid.Cibele.entities.BossEnemy;
    import com.starmaid.Cibele.entities.MapNode;
    import com.starmaid.Cibele.entities.PartyMember;
    import com.starmaid.Cibele.management.Path;
    import com.starmaid.Cibele.entities.PathNode;
    import com.starmaid.Cibele.entities.SmallEnemy;
    import com.starmaid.Cibele.entities.IkuTursoEnemy;
    import com.starmaid.Cibele.entities.EuryaleEnemy;
    import com.starmaid.Cibele.entities.Enemy;
    import com.starmaid.Cibele.utils.DHPoint;
    import com.starmaid.Cibele.base.GameObject;
    import com.starmaid.Cibele.base.GameState;

    import org.flixel.*;

    import flash.display.StageDisplayState;
    import flash.filesystem.File;
    import flash.filesystem.FileStream;
    import flash.filesystem.FileMode;
    import flash.net.FileReference;

    public class PathEditorState extends PlayerState {
        public var pathWalker:PathFollower;
        public var _path:Path;
        public var _mapnodes:MapNodeContainer;
        public var enemies:EnemyGroup;
        public var boss:BossEnemy;
        public var showNodes:Boolean;
        public var filename:String, graph_filename:String;
        public var dataFile:File, backupFile:File, writeFile:File,
                   graphDataFile:File;
        public var shouldAddEnemies:Boolean = true;
        public var readExistingGraph:Boolean = true;
        protected var teamPower:Number = 0, maxTeamPower:Number = 40;
        public var teamPowerBar:TeamPowerBar, animatingTeamPower:Boolean = false;
        private var teamPowerAnimationObjects:Array, teamPowerDelta:Number = 0;

        public static const MODE_READONLY:Number = 0;
        public static const MODE_EDIT:Number = 1;
        public var editorMode:Number;

        override public function create():void {
            super.create();
            this.addEventListener(GameState.EVENT_ENEMY_DIED, this.enemyDied);
        }

        override public function postCreate():void {
            if (this.filename != null) {
                this.dataFile = File.applicationDirectory.resolvePath(
                    "assets/" + this.filename);
                this.writeFile = File.applicationStorageDirectory.resolvePath(
                    this.filename);
                this.backupFile = File.applicationStorageDirectory.resolvePath(
                    this.filename + ".bak");
                this.graphDataFile = File.applicationDirectory.resolvePath(
                    "assets/" + this.graph_filename);

                if (!this.writeFile.exists) {
                    this.editorMode = MODE_READONLY;
                    FlxG.flashGfxSprite.mouseEnabled = false;
                } else {
                    this.editorMode = MODE_EDIT;
                    FlxG.flashGfxSprite.mouseEnabled = true;
                }
                //this.editorMode = MODE_EDIT; //turn this on in order to edit
            }

            this.showNodes = ScreenManager.getInstance().DEBUG ||
                this.editorMode == MODE_EDIT;

            pathWalker = new PathFollower(new DHPoint(player.x-10, player.y-100));

            pathWalker.initFootsteps();

            _path = new Path();
            pathWalker.precon_path = _path;
            pathWalker.setPlayerReference(player);

            _mapnodes = new MapNodeContainer(_path, player);
            this.pathWalker.setMapNodes(this._mapnodes);
            this.player.setMapNodes(this._mapnodes);

            this.enemies = new EnemyGroup(player, pathWalker);
            pathWalker.setEnemyGroupReference(this.enemies);

            this.readIn();
            if (this.readExistingGraph) {
                this.readGraphIn();
            }

            if (this._path.hasNodes()) {
                this.pathWalker.moveToNextPathNode();
            }

            this.boss = new (this.getBossClass())(new DHPoint(0, 0));

            add(this.boss);
            this.boss.addVisibleObjects();
            this.boss._mapnodes = this._mapnodes;
            this.pathWalker.bossRef = this.boss;
            this.enemies.addEnemy(this.boss);

            this.pathWalker.addVisibleObjects();

            for (var i:int = 0; i < this.enemies.length(); i++) {
                this.enemies.get_(i).addVisibleObjects();
            }

            this.teamPowerBar = new TeamPowerBar(this.maxTeamPower);
            this.teamPowerBar.setPoints(this.teamPower);
            this.buildTeamPowerAnimationObjects();

            super.postCreate();

            add(pathWalker.debugText);
        }

        public function buildTeamPowerAnimationObjects():void {
            this.teamPowerAnimationObjects = new Array();
            var cur:GameObject;
            for (var i:int = 0; i < 2; i++) {
                cur = new GameObject(new DHPoint(0, 0));
                cur.makeGraphic(10, 10, 0xffff0000);
                cur.visible = false;
                cur.scrollFactor = new DHPoint(0, 0);
                this.teamPowerAnimationObjects.push(cur);
                FlxG.state.add(cur);
            }
        }

        public function updateTeamPowerAnimation():void {
            var cur:GameObject, curDisp:DHPoint,
                curScreenPos:DHPoint = new DHPoint(0, 0),
                finishedCount:Number = 0;
            for (var i:int = 0; i < this.teamPowerAnimationObjects.length; i++) {
                cur = this.teamPowerAnimationObjects[i];
                cur.getScreenXY(curScreenPos);
                curDisp = curScreenPos.sub(this.teamPowerBar.getPos());
                cur.dir = curDisp.normalized().reverse().mulScl(10);

                if (cur.pos.sub(this.teamPowerBar.getPos())._length() < 10) {
                    cur.visible = false;
                    finishedCount += 1;
                }
            }

            if (finishedCount >= this.teamPowerAnimationObjects.length) {
                this.animatingTeamPower = false;
                this.animatingTeamPowerEndCallback();
            }
        }

        override public function update():void {
            super.update();

            this._mapnodes.update();
            this._path.update();

            this.teamPowerBar.setPos(null);
            this.teamPowerBar.update();
            this.teamPowerBar.setHighlight(this.teamPowerIsActive());
            if (this.animatingTeamPower) {
                this.updateTeamPowerAnimation();
            }

            if (FlxG.mouse.justReleased()) {
                if (FlxG.keys["A"]) {
                    this._path.addNode(new DHPoint(FlxG.mouse.x, FlxG.mouse.y),
                                       this.showNodes);
                    this.pathWalker.moveToNextPathNode();
                } else if(FlxG.keys["S"]){
                    this._mapnodes.addNode(new DHPoint(FlxG.mouse.x, FlxG.mouse.y),
                                           this.showNodes);
                    this.pathWalker.moveToNextPathNode();
                } else if (FlxG.keys["Z"]) {
                    var en:SmallEnemy = new (this.getEnemyClass())(new DHPoint(FlxG.mouse.x,
                                                                   FlxG.mouse.y));
                    add(en);
                    this.enemies.addEnemy(en);
                } else if (FlxG.keys["Q"]) {
                    /*
                    var boss:BossEnemy = new (this.getBossClass())(new DHPoint(FlxG.mouse.x,FlxG.mouse.y));
                    add(boss);
                    this.enemies.addEnemy(boss);
                    */
                }
            }

            if (FlxG.keys.justReleased("W")) {
                this.writeOut();
            } else if (FlxG.keys.justReleased("C")) {
                this._path.clearPath();
                this._mapnodes.clearNodes();
            }
        }

        public function writeBackup():void {
            var f:File = this.writeFile;
            var str:FileStream = new FileStream();
            if (!f.exists) {
                return;
            }
            str.open(f, FileMode.READ);
            var fileContents:String = str.readUTFBytes(f.size);
            str.close();

            var fBak:File = this.backupFile;
            str.open(fBak, FileMode.WRITE);
            str.writeUTFBytes(fileContents);
            str.close();
        }

        public function writeOut():void {
            if (this.editorMode != MODE_EDIT) {
                return;
            }
            this.writeBackup();
            var f:File = this.writeFile;
            var str:FileStream = new FileStream();
            str.open(f, FileMode.WRITE);

            var fString:String = "";
            var curNode:PathNode = null;
            var curMapNode:MapNode = null;
            var curEnemy:Enemy = null;

            var i:int;

            for (i = 0; i < this._path.nodes.length; i++) {
                curNode = this._path.nodes[i];
                fString += "pathnode " + curNode.pos.x + "x" + curNode.pos.y +
                           "\n";
            }

            for (i = 0; i < this._mapnodes.nodes.length; i++) {
                curMapNode = this._mapnodes.nodes[i];
                fString += "mapnode " + curMapNode.pos.x + "x" +
                           curMapNode.pos.y + "\n";
            }

            for (i = 0; i < this.enemies.length(); i++) {
                curEnemy = this.enemies.get_(i);
                fString += curEnemy.enemyType + " " + curEnemy.pos.x + "x" +
                           curEnemy.pos.y + "\n";
            }

            str.writeUTFBytes(fString);
            str.close();
            this.writeBackup();
        }

        public function getAllNodes():Array {
            var allNodes:Array = new Array();
            for (var k:int = 0; k < this._mapnodes.path.nodes.length; k++) {
                allNodes.push(this._mapnodes.path.nodes[k]);
            }
            for (var h:int = 0; h < this._mapnodes.nodes.length; h++) {
                allNodes.push(this._mapnodes.nodes[h]);
            }
            return allNodes;
        }

        public function readGraphIn():void {
            var f:File = this.graphDataFile;
            var str:FileStream = new FileStream();
            if (f == null || !f.exists) {
                return;
            }
            str.open(f, FileMode.READ);
            var fileContents:String = str.readUTFBytes(f.size);
            str.close();

            var lines:Array = fileContents.split("\n");
            var line:Array, generator:GraphGenerator;
            var node1:MapNode, node2:MapNode, score:Number;
            generator = new GraphGenerator(this as LevelMapState);
            for (var i:int = 0; i < lines.length - 1; i++) {
                line = lines[i].split(" ");
                node1 = this.getMapNodeById(line[0]);
                node2 = this.getMapNodeById(line[1]);
                score = Number(line[2]);
                if (node1 != null && node2 != null) {
                    node1.addEdge(node2, score);
                    if (ScreenManager.getInstance().DEBUG) {
                        generator.rayCast(node1.pos, node2.pos, 0xffff00ff, -1,
                                          1, true);
                    }
                }
            }
        }

        public function clearAllAStarMeasures():void {
            var allNodes:Array = this.getAllNodes();
            for (var i:int = 0; i < allNodes.length; i++) {
                allNodes[i].clearAStarData();
            }
        }

        public function getMapNodeById(_id:String):MapNode {
            var mapNode:MapNode = this._mapnodes.nodesHash[_id];
            if (mapNode != null) {
                return mapNode;
            }
            var pathNode:MapNode = this._path.nodesHash[_id];
            if(pathNode != null) {
                return pathNode;
            }
            return null;
        }

        public function readIn():void {
            if (this.dataFile == null) {
                return;
            }
            var f:File = this.dataFile;
            if (this.editorMode == MODE_EDIT) {
                if (this.writeFile.exists) {
                    f = this.writeFile;
                }
            }
            var str:FileStream = new FileStream();
            if (!f.exists) {
                return;
            }
            str.open(f, FileMode.READ);
            var fileContents:String = str.readUTFBytes(f.size);
            str.close();

            var lines:Array = fileContents.split("\n");
            var line:Array, coords:Array, prefix_:String;
            for (var i:int = 0; i < lines.length - 1; i++) {
                line = lines[i].split(" ");
                prefix_ = line[0];
                if (prefix_.indexOf("pathnode") == 0) {
                    coords = line[1].split("x");
                    this._path.addNode(
                        new DHPoint(Number(coords[0]), Number(coords[1])),
                        this.showNodes);
                } else if (prefix_.indexOf("mapnode") == 0) {
                    coords = line[1].split("x");
                    this._mapnodes.addNode(
                        new DHPoint(Number(coords[0]), Number(coords[1])),
                        this.showNodes);
                } else if (prefix_.indexOf("enemy") == 0 && this.shouldAddEnemies) {
                    coords = line[1].split("x");
                    var en:SmallEnemy = new (this.getEnemyClass())(
                        new DHPoint(Number(coords[0]), Number(coords[1])));
                    add(en);
                    this.enemies.addEnemy(en);
                } else if (prefix_.indexOf("boss") == 0 && this.shouldAddEnemies) {
                    /*
                    coords = line[1].split("x");
                    var bo:BossEnemy = new (this.getBossClass())(
                        new DHPoint(Number(coords[0]), Number(coords[1])));
                    add(bo);
                    this.enemies.addEnemy(bo);
                    */
                }
            }
        }

        private function getEnemyClass():Class {
            if (this is IkuTurso) {
                return IkuTursoEnemy;
            } else if (this is Euryale) {
                return EuryaleEnemy;
            } /*else if (this is Hiisi) {
                return HiisiEnemy;
            }*/
            return IkuTursoEnemy;
        }

        private function getBossClass():Class {
            if (this is IkuTurso) {
                return IkuTursoBoss;
            } else if (this is Euryale) {
                return EuryaleBoss;
            } /*else if (this is Hiisi) {
                return HiisiBoss;
            }*/
            return IkuTursoBoss;
        }

        private function increaseTeamPower(amt:Number):void {
            this.animatingTeamPower = true;
            this.teamPowerDelta = amt;
            var curScreenPos:DHPoint = new DHPoint(0, 0);
            this.player.getScreenXY(curScreenPos);
            this.teamPowerAnimationObjects[0].setPos(curScreenPos);
            this.teamPowerAnimationObjects[0].visible = true;
            this.pathWalker.getScreenXY(curScreenPos);
            this.teamPowerAnimationObjects[1].setPos(curScreenPos);
            this.teamPowerAnimationObjects[1].visible = true;
        }

        private function animatingTeamPowerEndCallback():void {
            this.teamPower += this.teamPowerDelta;
            this.teamPowerBar.setPoints(this.teamPower);
            this.player.showTeamPowerDelta(this.teamPowerDelta);
            this.pathWalker.showTeamPowerDelta(this.teamPowerDelta);
            this.teamPowerDelta = 0;
            if (ScreenManager.getInstance().DEBUG) {
                trace("increased team power to " + this.teamPower);
            }
            FlxG.stage.dispatchEvent(
                new DataEvent(GameState.EVENT_TEAM_POWER_INCREASED,
                              {'team_power': this.teamPower}));
        }

        private function teamPowerIsActive():Boolean {
            var partyMembersInRange:Boolean = this.pathWalker.isOnscreen();
            var playerTargeting:Boolean = this.player.inAttack();
            return partyMembersInRange && playerTargeting;
        }

        private function enemyDied(event:DataEvent):void {
            var partyMembersInRange:Boolean = this.pathWalker.isOnscreen();
            var playerTargeting:Boolean = this.player.inAttack();
            var damagedBy:PartyMember = event.userData['damaged_by'];
            if (damagedBy != null) {
                if (ScreenManager.getInstance().DEBUG) {
                    trace("an enemy was killed by " +
                        event.userData['damaged_by'].slug +
                        " and inRange=" + partyMembersInRange);
                }

                if ((damagedBy == this.player && partyMembersInRange) ||
                    (damagedBy == this.pathWalker && partyMembersInRange &&
                     playerTargeting))
                {
                    this.increaseTeamPower(1);
                }
            }
        }
    }
}
