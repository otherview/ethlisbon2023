<template>
  <div>
    <div class="top-banner">
      <img :src="bannerImg" alt="Top Banner" /> <!-- Update the source path to your image -->
    </div>

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
  </div>
</template>

<script>

import bannerImg from "../assets/banner.png";

export default {
  name: 'BattleshipMap',
  setup() {

    return {
      bannerImg,
    }
  },
  data() {
    return {
      gridSize: 20,
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
      if(cell.classList.contains('cell')) {
        const row = cell.dataset.row;
        const col = cell.dataset.col;
        console.log(`Cell clicked: Row ${row}, Column ${col}`);
      }
    },
  },
};
</script>

<style scoped>
.grid-map {
  width: 100vh;
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100vh; /* Use full screen height to center the grid vertically */
  margin: 0 auto; /* Centers the container */
}

.grid {
  display: grid;
  grid-template-columns: repeat(20, 1fr); /* Creates a 20x20 grid */
  grid-gap: 2px; /* Space between cells */
  width: 100%; /* Ensure the grid takes the full width of the container */
}

.cell {
  width: 100%; /* 100% of the column width */
  padding-bottom: 20%; /* Adjust padding to make cells larger */
  background-color: #eee; /* Cell color */
  border: 1px solid #ccc; /* Cell border */
  box-sizing: border-box;
  transition: background-color 0.3s; /* Smooth background color transition */
}

.cell:hover {
  background-color: orange; /* Change hover color to orange */
  cursor: pointer; /* Change cursor to pointer on hover */
}

.top-banner {
  max-height: 30vh;
}
</style>
