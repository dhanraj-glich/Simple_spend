import { defineConfig } from 'vite';

// Stable asset names let the lightweight service worker cache the complete app shell.
export default defineConfig({
  build: {
    rollupOptions: { output: { entryFileNames: 'assets/main.js', chunkFileNames: 'assets/[name].js', assetFileNames: asset => asset.name?.endsWith('.css') ? 'assets/styles.css' : 'assets/[name][extname]' } }
  }
});
