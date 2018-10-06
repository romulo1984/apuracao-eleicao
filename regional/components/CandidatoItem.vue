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
      getCandidateImage(id, uf) {
        if(SIMULATE_ENV) {
          return PROXY_TRIBUNA + `interessados.divulgacao.tse.jus.br/2018/divulgacao/homologacaotre/7555/fotos/${uf}/${id}.jpeg`
        }
        return PROXY_TRIBUNA + `interessados.divulgacao.tse.jus.br/2018/divulgacao/oficial/297/fotos/${uf}/${id}.jpeg`
      }
    }
  }
</script>

<template>
 <div>
   <div class="candidato-item media mb-5">
     <img :src="getCandidateImage(candidato.sqcand, geral.cdabr)" :alt="candidato.nm" class="candidato-image mr-3">
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
       <div class="pprogress">
         <div class="pprogress-bar" role="pprogressbar" :style="`width: ${percent}%`" :aria-valuenow="percent" aria-valuemin="0" aria-valuemax="100"></div>
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

  pprogress {
    vertical-align: baseline;
  }

  .pprogress {
    display: -ms-flexbox;
    display: flex;
    height: 1rem;
    overflow: hidden;
    font-size: .75rem;
    background-color: #e9ecef;
    border-radius: .25rem;
  }

  .pprogress-bar {
    display: -ms-flexbox;
    display: flex;
    -ms-flex-direction: column;
    flex-direction: column;
    -ms-flex-pack: center;
    justify-content: center;
    color: #fff;
    text-align: center;
    white-space: nowrap;
    background-color: #007bff;
    transition: width 0.6s ease;
  }

  @media screen and (prefers-reduced-motion: reduce) {
    .pprogress-bar {
      transition: none;
    }
  }
  .pprogress-bar-animated {
    -webkit-animation: pprogress-bar-stripes 1s linear infinite;
    animation: pprogress-bar-stripes 1s linear infinite;
  }

  @-webkit-keyframes pprogress-bar-stripes {
    from {
      background-position: 1rem 0;
    }
    to {
      background-position: 0 0;
    }
  }

  @keyframes pprogress-bar-stripes {
    from {
      background-position: 1rem 0;
    }
    to {
      background-position: 0 0;
    }
  }

  .pprogress-bar-striped {
    background-image: linear-gradient(45deg, rgba(255, 255, 255, 0.15) 25%, transparent 25%, transparent 50%, rgba(255, 255, 255, 0.15) 50%, rgba(255, 255, 255, 0.15) 75%, transparent 75%, transparent);
    background-size: 1rem 1rem;
  }

  .pprogress, .pprogress-bar {
    height: 8px;
  }
</style>
