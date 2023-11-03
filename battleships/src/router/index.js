import { createRouter, createWebHistory } from 'vue-router';

// Components
import Home from "@/view/Home.vue";
import Debug from "@/view/Debug.vue";

// Define routes
const routes = [
    {
        path: '/ethlisbon2023/battleships/',
        name: 'Home',
        component: Home
    },
    {
        path: '/ethlisbon2023/battleships/debug',
        name: 'Debug',
        component: Debug
    }
];

// Create the router instance
const router = createRouter({
    history: createWebHistory(),
    routes
});

export default router;
