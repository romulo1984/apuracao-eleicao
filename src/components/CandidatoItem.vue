<script>
  export default {
    props: {
      candidato: Object
    },
    methods: {
      getCandidateImage(id) {
        return `http://interessados.divulgacao.tse.jus.br/2018/divulgacao/oficial/295/fotos/br/${id}.jpeg`
      }
    }
  }
</script>

<template>
 <div>
   <div class="candidato-item media mb-5">
     <img :src="getCandidateImage(candidato.sqcand)" :alt="candidato.nm" class="candidato-image mr-3">
     <div class="media-body">
       <div class="media">
         <div class="media-body">
           <h5 class="mt-0">
             <span class="text-black-50">{{ candidato.n }}</span>
             {{ candidato.nm }}
           </h5>
           <h6 class="text-black-50">
             {{ candidato.cc.split(' ')[0] }}
           </h6>
         </div>
         <div class="ml-3 text-right">
           <h4>0%</h4>
           <h6>0 votos</h6>
         </div>
       </div>
       <div class="progress">
         <div class="progress-bar" role="progressbar" style="width: 25%" aria-valuenow="25" aria-valuemin="0" aria-valuemax="100"></div>
       </div>
     </div>
   </div>
 </div>
</template>

<style lang="scss" scoped>
  * {
    font-weight: 400;
  }
  .candidato-image {
    border-radius: 15px;
    width: 52px;
  }
  .progress, .progress-bar {
    height: 8px;
  }
</style>
