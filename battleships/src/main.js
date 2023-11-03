import { createApp } from 'vue'
import './style.css'
import { createPinia } from 'pinia'
import App from './App.vue'
import router from './router'; // make sure the path is correct

const pinia = createPinia()

createApp(App).use(pinia).use(router).mount('#app')
