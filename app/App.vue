<script>
  import CandidatoItem from './components/CandidatoItem'
  import ProgressCircle from './components/ProgressCircle'
  import axios from 'axios'
  import _orderBy from 'lodash/orderBy'

  window.PROXY_TRIBUNA = 'https://tribunaonline.com.br/secureproxy/?'
  // window.PROXY_TRIBUNA = 'http://'

  function getApiEndpoint(cargo, turno) {
    let BASE_API = ''
    let codEleicao = ''

    BASE_API = PROXY_TRIBUNA + 'interessados.divulgacao.tse.jus.br/2018/divulgacao/oficial/'
    codEleicao = (turno === 1) ? '000295' : '000296'

    const codCargo = {
      presidente: 1,
      governador: 3,
      senador: 5,
      dfederal: 6,
      destadual: 7,
      ddistrital: 8
    }

    return BASE_API + parseInt(codEleicao) + '/dadosdivweb/br/br-c000' + codCargo[cargo] + '-e' + codEleicao + '-w.js'
  }

  export default {
    name: 'App',
    components: {
      CandidatoItem,
      ProgressCircle
    },
    data() {
      return {
        geralPresidente: {},
        cargo: 'presidente',
        turno: 2,
        updateTimeBase: 15,
        updateTime: 15,
      }
    },
    mounted() {
      this.getGeralPresidente()
      this.counter()
    },
    computed: {
      link() {
        return getApiEndpoint(this.cargo, this.turno)
      },
      completedSteps() {
        let completed = Math.floor((this.geralPresidente.st / this.geralPresidente.s) * 100)
        return isNaN(completed) ? 0 : completed
      },
      candidatoOrderedByName() {
        if(this.geralPresidente.cand) {
          const newEl = this.geralPresidente.cand.map((item) => {
            const calc = item.v > (parseInt(this.geralPresidente.vv) + parseInt(this.geralPresidente.ena))/2
            const newItem = {...item, matematicamenteEleito: calc}
            return newItem
          })

          return _orderBy(newEl, item => parseInt(item.seq))
        }
        return [];
      }
    },
    methods: {
      changeTurno(turno) {
        this.turno = turno
        this.getGeralPresidente()
      },
      getGeralPresidente() {
        return axios.get(getApiEndpoint(this.cargo, this.turno))
          .then(res => this.geralPresidente = res.data)
      },
      counter() {
        setInterval(() => {
            if(this.turno === 2) {
              if(this.updateTime === 0) {
                this.getGeralPresidente()
                  .then(() => this.updateTime = this.updateTimeBase)
                  .catch(() => this.updateTime = this.updateTimeBase)
              } else {
                this.updateTime--
              }
            }
          }, 1000)
      }
    }
  }
</script>

<template>
  <div class="row mt-5">
    <div class="col-md-12">
      <div class="section-head mb-2 pb-3">
        <div class="media">
          <div class="media-body">
            <h2>
              Presidente
              <div class="btn btn-sm btn-outline-secondary turn" @click="changeTurno(1)" :class="{'selected': turno === 1}">1º turno</div>
              <div class="btn btn-sm btn-outline-secondary turn" @click="changeTurno(2)" :class="{'selected': turno === 2}">2º turno</div>
            </h2>
            <p class="m-0 text-black-50">
              seções apuradas: <strong>{{ geralPresidente.st }}</strong> de {{ geralPresidente.s }}
            </p>
          </div>
          <div class="ml-3">
            <ProgressCircle :percent="completedSteps" :color="'#007bff'" :inner="'#cccccc'"/>
          </div>
        </div>
      </div>
      <div class="mb-4" v-if="turno === 2">
        <img src="https://s3.amazonaws.com/static.tribunaonline.com.br/general-assets-apps/apuracao/presidente/bar-chart-preloader.176c94fd.svg" alt="Carregando..." width="25">
        <span class="text-black-50">atualizando em {{ updateTime }}</span>
      </div>
      <div class="mb-4" v-else>
        <span class="text-black-50">apuração encerrada</span>
      </div>
      <candidato-item v-for="candidato in candidatoOrderedByName" :key="candidato.sqcand" :candidato="candidato" :geral="geralPresidente"></candidato-item>
    </div>
  </div>
</template>

<style lang="scss" scoped>
  * {
    font-family: 'Open Sans', sans-serif;
  }
  .section-head {
    border-bottom: 1px solid #ccc;
  }
  
  .turn {
    opacity: 0.4;
    &.selected {
      opacity: 1;
    }
    &:hover {
      color: #000 !important;
      background-color: #fff;
      opacity: 0.6;
    }
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
