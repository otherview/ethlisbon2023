<template>
  <div>
    <div class="top-banner">
      <img :src="bannerImg" alt="Top Banner" /> <!-- The banner image is now bound to the bannerImg property -->
    </div>
    <button class="connect-btn">Connect!</button>
  </div>
</template>

<script>
// Import the banner image from assets
import bannerImg from '@/assets/banner.png';

export default {
  name: 'ConnectingSplash',
  setup() {
    return { bannerImg };
  },
};
</script>

<style scoped>
.top-banner img {
  width: 100%; /* Full width */
  object-fit: cover; /* Cover ensures the image covers the area without distortion */
}
.connect-btn {
  background-color: #4CAF50; /* Green */
  border: none;
  color: white;
  padding: 15px 32px;
  text-align: center;
  text-decoration: none;
  display: inline-block;
  font-size: 16px;
}
</style>
