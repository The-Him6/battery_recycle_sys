<template>
  <svg
    :width="size"
    :height="size"
    viewBox="0 0 64 64"
    fill="none"
    xmlns="http://www.w3.org/2000/svg"
    aria-hidden="true"
  >
    <rect x="16" y="10" width="32" height="44" rx="10" :fill="bodyFill" />
    <rect x="26" y="6" width="12" height="6" rx="2" :fill="capFill" />
    <rect x="21" y="16" width="22" height="32" rx="7" :fill="innerFill" />
    <path d="M34.5 20L26 34H32L29.5 44L38 30H32L34.5 20Z" :fill="boltFill" />
    <rect x="19" y="13" width="26" height="2" rx="1" fill="rgba(255,255,255,0.38)" />
  </svg>
</template>

<script setup>
defineProps({
  size: {
    type: [Number, String],
    default: 32
  },
  bodyFill: {
    type: String,
    default: '#7fa36b'
  },
  capFill: {
    type: String,
    default: '#5f7f50'
  },
  innerFill: {
    type: String,
    default: '#edf5e7'
  },
  boltFill: {
    type: String,
    default: '#8fb67b'
  }
})
</script>
















