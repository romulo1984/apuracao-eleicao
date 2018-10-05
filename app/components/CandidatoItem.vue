<script>
  export default {
    props: {
      candidato: Object,
      geral: Object
    },
    computed: {
      percent() {
        let votosCandidatoTotalizados = this.candidato.v
        let votosValidos = this.geral.vv
        let percent = ((votosCandidatoTotalizados / votosValidos) * 100).toFixed(2)
        return isNaN(percent) ? 0 : percent
      },
      eleito() {
        if(this.executivo) {
          if(this.candidato.matematicamenteEleito) {
            return `<span class="badge badge-primary">Matematicamente Eleito</span>`
          } else if(this.candidato.e === 's') {
            return `<span class="badge badge-success">Segundo Turno</span>`
          }
        } else {
          if(this.candidato.e === 's') {
            return `<span class="badge badge-success">Eleito</span>`
          }
        }
      }
    },
    methods: {
      getCandidateImage(id) {
        if(SIMULATE_ENV) {
          return `http://interessados.divulgacao.tse.jus.br/2018/divulgacao/homologacaotre/7555/fotos/br/${id}.jpeg`
        }
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
             {{ candidato.cc.split(' ')[0] }} <span v-html="eleito"></span>
           </h6>
         </div>
         <div class="ml-3 text-right">
           <h4>{{ percent }}%</h4>
           <h6>{{ candidato.v }} votos</h6>
         </div>
       </div>
       <div class="progress">
         <div class="progress-bar" role="progressbar" :style="`width: ${percent}%`" :aria-valuenow="percent" aria-valuemin="0" aria-valuemax="100"></div>
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
