<template>
  <div id="app">
    <battleship-map></battleship-map>
  </div>
</template>

<script>

import BattleshipMap from "./components/BattleshipMap.vue";

export default {
  name: 'App',
  components: {
    BattleshipMap
  }
};
</script>

<style>
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
}
</style>
