
<script>
  export default {
    props: ['percent', 'color', 'inner'],
    computed: {
        circle() {
            return ((this.percent / 100) * 100 * Math.PI) + ',9999'
        }
    }
  }
</script>

<template>
  <div class="progress-circle__container">
      <span class="progress-circle__percent">{{ percent }}%</span>

        <svg class="progress-circle" viewBox="0 0 106 106" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
            <g id="Page-1" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">
                <g id="ProgressBar" transform="translate(-17.000000, -17.000000)">
                    <circle id="Oval" :stroke="inner" stroke-width="5" fill-rule="nonzero" cx="70" cy="70" r="50"></circle>
                    <path class="progress-circle__path" d="M70,120 C97.6142375,120 120,97.6142375 120,70 C120,42.3857625 97.6142375,20 70,20 C42.3857625,20 20,42.3857625 20,70 C20,97.6142375 42.3857625,120 70,120 Z" id="Oval-Copy" :stroke="color" stroke-width="5" :stroke-dasharray="circle" fill-rule="nonzero" transform="translate(70.000000, 70.000000) rotate(-125.000000) translate(-70.000000, -70.000000) "></path>
                </g>
            </g>
        </svg>

      </span>
  </div>
</template>

<style lang="scss" scoped>
    .progress-circle {
        max-width:50px;
        max-height:50px;
        width:100%;
        transform: scaleX(-1) rotate(-55deg);
        
        &__percent {
            position:absolute;
            top:50%;
            left:50%;
            transform: translate(-50%,-50%);
            font-size: 14px;
            color: rgba(0, 0, 0, .5)
        }
        
        &__container {
            display:inline-block;
            position:relative;
        }
        
        &__path {
            transition: 0.5s ease-in-out all;
        }
    }
</style>
