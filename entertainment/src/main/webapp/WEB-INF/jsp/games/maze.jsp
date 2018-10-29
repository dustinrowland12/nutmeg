<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>

<head>
	<link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/games/maze.css"/>">
</head>
<body>
	<h2>Maze</h2>
	<div id="vue-maze">
		<div class="loader" v-if="showAll != true">
			<i class="fas fa-spinner fa-spin fa-3x fa-fw"></i>
			<span>Loading...</span>
		</div>
		<transition name="fade">
			<div v-if="showAll">
				<transition name="slide">
					<div v-if="showMazeAreaInput">
						<h3>Instructions</h3>
						<p>
							Enter the maze dimensions you desire below. Dimensions must be between {{minDimension}} and {{maxDimension}}. Click Create New Maze and a maze will be created. The ball will start flashing to indicate
							you can move the ball with the arrow keys on your keyboard. If you click away from the ball, it will stop flashing, and you will not be able to continue until you click
							on the ball to return focus to it. You can generate a new maze any time you wish with the Create New Maze button. 
						</p>
						<h3>Maze Dimensions</h3>
						<div class="form-group">
							<label for="width">Width</label>
							<input type="text" class="form-control" name="width" v-model="inputWidth" @keydown.enter="validateCoordinates">
						</div>
						<div class="form-group">
							<label for="length">Length</label>
							<input type="text" class="form-control" name="length" v-model="inputLength" @keydown.enter="validateCoordinates">
						</div>
						<button class="btn btn-primary" @click="validateCoordinates">Create New Maze</button>
						<div class="divider" v-if="showMaze">
							<hr/>
						</div>
					</div>
				</transition>
				<template v-if="showMaze">
					<div class="maze-section">
						<div class="btn-toolbar justify-content-between">
							<button type="button" class="btn btn-dark" @click="toggleInputArea">{{showHideButtonText}}</button>
							<div class="btn-group" role="group" aria-label="Options">
								<div class="btn-group" role="group">
								    <button type="button" title="Cursor Type" class="btn btn-dark dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
								    	<span id="cursorIcons" :class="cursorIcon.className"></span>
							    	</button>
							    	<div class="dropdown-menu" style="min-width: 0px;" aria-labelledby="cursorIcons">
								    	<div class="dropdown-item" v-for="icon in cursorIcons" @click="updateCursorIcon(icon)" :class="{active: icon == cursorIcon}"><span :class="icon.className"></span></div>
								    </div>
							    </div>
								<button type="button" class="btn btn-dark" @click="transposeMaze" title="Transpose">&nbsp;<span class="fas fa-sync"></span>&nbsp;</button>
								<button type="button" class="btn btn-dark" @click="adjustCellSize('subtract')" title="Smaller">&nbsp;<span class="fas fa-minus"></span>&nbsp;</button>
								<button type="button" class="btn btn-dark" @click="adjustCellSize('add')" title="Larger">&nbsp;<span class="fas fa-plus"></span>&nbsp;</button>
							</div>
						</div>
						<div class="game-container" ref="gameContainer">
							<div class="maze" id="maze" ref="game" :style="{ 'grid-template-columns': gridTemplateColumns, 'grid-template-rows': gridTemplateRows, 'border-width': mazeBorderWidth }">
								<template v-for="cell in cells">
									<grid-cell :cell="cell" :cursor="cursor"></grid-cell>
								</template>
								<button class="cursor" :class="cursorButtonClasses" @focus="activateCursor(true)" @focusout="activateCursor(false)" ref="cursor"
									:style="{ 'grid-column': cursor.x, 'grid-row': cursor.y }"
									@keydown.up.prevent.stop="moveCursor('top')" @keydown.left.prevent.stop="moveCursor('left')" @keydown.right.prevent.stop="moveCursor('right')" @keydown.down.prevent.stop="moveCursor('bottom')" >
									<transition name="fade">
										<span :class="[cursorIcon.className, cursorDirectionClass]" :style="{ 'font-size': cursorSizeWithUnit }"></span>
									</transition>
								</button>
							</div>
						</div>
						<transition name="fade">
							<template v-if="complete">
								<div class="game-container">
									<h4>Congratulations! You win!</h4>
								</div>
\							</template>
						</transition>
					</div>
				</template>
			</div>
		</transition>
		<!-- Modal -->
		<div class="modal fade" id="modalCompleteGame" tabindex="-1" role="dialog"
			aria-labelledby="modalCompleteGameLabel" aria-hidden="true">
			<div class="modal-dialog" role="document">
				<div class="modal-content">
					<div class="modal-header">
						<h5 class="modal-title" id="modalCompleteGameLabel">You Win!</h5>
						<button type="button" class="close" data-dismiss="modal"
							aria-label="Close">
							<span aria-hidden="true">&times;</span>
						</button>
					</div>
					<div class="modal-body">Congratulations! Would you like to play again?</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-secondary" data-dismiss="modal">No Thanks</button>
						<button type="button" class="btn btn-primary" @click="newGameFromModal">New Maze</button>
					</div>
				</div>
			</div>
		</div>
	</div>
	<!-- common functions -->
	<script type="text/javascript" src="<c:url value="/resources/js/common/utils.js"/>"></script>
	<!-- enum dependencies -->
	<script type="text/javascript" src="<c:url value="/resources/js/enums/maze-wall-type.js"/>"></script>
	<!-- model dependencies -->
	<script type="text/javascript" src="<c:url value="/resources/js/models/maze-cell.js"/>"></script>
	<script type="text/javascript" src="<c:url value="/resources/js/models/maze-cursor.js"/>"></script>
	<script type="text/javascript" src="<c:url value="/resources/js/models/maze-wall.js"/>"></script>
	<!-- Vue components -->
	<script type="text/javascript" src="<c:url value="/resources/js/components/maze.js"/>"></script>
	
</body>