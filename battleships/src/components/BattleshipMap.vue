<template>
  <div>
    <div class="top-banner">
      <img :src="bannerImg" alt="Top Banner" /> <!-- The banner image is now bound to the bannerImg property -->
    </div>
    <p>
      &nbsp;
    </p>

    <div class="grid-map">
      <div class="grid" @click="clickCell($event)">
        <div
            v-for="(cell, index) in cells"
            :key="index"
            class="cell"
            :data-row="getRow(index)"
            :data-col="getCol(index)"
        ></div>
      </div>
    </div>

    <div class="game-log">
      <h2>Game Log</h2>
        <!-- loop through log messages in gameLog -->
        <div class="log-msg" v-for="(log, index) in gameLog" :key="index">
          {{ log }}
        </div>
    </div>
  </div>
</template>

<script>
// Import the banner image from assets
import bannerImg from '@/assets/banner.png'; // Adjust the path if necessary

export default {
  name: 'BattleshipMap',
  setup() {
    return { bannerImg };
  },
  data() {
    return {
      gridSize: 20,
      gameLog: [],
    };
  },
  computed: {
    cells() {
      return Array.from({ length: this.gridSize * this.gridSize });
    }
  },
  methods: {
    getRow(index) {
      return Math.floor(index / this.gridSize);
    },
    getCol(index) {
      return index % this.gridSize;
    },
    clickCell(event) {
      const cell = event.target;
      if (cell.classList.contains('cell')) {
        const row = cell.dataset.row;
        const col = cell.dataset.col;
        let logMsg = `Cell clicked: Row ${row}, Column ${col}`;
        console.log(logMsg);
        this.gameLog.push(logMsg);
      }
    },
  },
};
</script>

<style scoped>
.top-banner img {
  width: 100%; /* Full width */
  object-fit: cover; /* Cover ensures the image covers the area without distortion */
}

.grid-map {
  display: flex;
  justify-content: center;
  align-items: center;
  height: calc(100vh - 30vh); /* Subtract the height of the top banner */
  width: 100%;
  margin: 0 auto; /* Center the grid map horizontally */
}

.grid {
  display: grid;
  grid-template-columns: repeat(20, 1fr); /* Creates a 20x20 grid */
  grid-gap: 2px; /* Space between cells */
  width: 100%; /* Grid takes full width of the container */
}

.cell {
  width: 100%; /* Each cell takes up 100% of the column width */
  padding-bottom: 20%; /* Padding to maintain aspect ratio */
  background-color: #eee; /* Default cell background color */
  border: 1px solid #ccc; /* Cell border */
  box-sizing: border-box;
  transition: background-color 0.3s; /* Smooth transition for background color */
}

.cell:hover {
  background-color: orange; /* Cell background color on hover */
  cursor: pointer; /* Cursor changes to pointer on hover */
}

.game-log {
  height: 30vh; /* Set the height of the game log */
  overflow-y: scroll; /* Enable vertical scrolling */
  border: 1px solid #ccc; /* Add a border */
  padding: 10px; /* Add some padding */

  /* console appearance, neon green and monospace with dark grey background */
  background-color: #000;
  font-family: monospace;
  color: #0f0;
}
</style>
